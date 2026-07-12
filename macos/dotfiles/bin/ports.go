// Script to manage dev processes listening on local ports
// Source: https://github.com/LarsenCundric/port-whisperer/tree/main
package main

import (
	"bufio"
	"context"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"os/signal"
	"path/filepath"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"syscall"
	"text/tabwriter"
	"time"
)

type PortInfo struct {
	Port        int
	PID         int
	PPID        int
	ProcessName string
	RawName     string
	Command     string
	CWD         string
	ProjectRoot string
	ProjectName string
	Framework   string
	Status      string
	MemoryKB    int
	Uptime      string
	GitBranch   string
}

type Scanner struct {
	gitRootCache map[string]string
	branchCache  map[string]BranchEntry
	maxCacheSize int
}

type BranchEntry struct {
	value   string
	expires time.Time
}

type DockerInfo struct {
	Name  string
	Image string
}

func NewScanner() *Scanner {
	return &Scanner{
		gitRootCache: map[string]string{},
		branchCache:  map[string]BranchEntry{},
		maxCacheSize: 200,
	}
}

func (s *Scanner) setGitRootCache(dir, root string) {
	if len(s.gitRootCache) >= s.maxCacheSize {
		for k := range s.gitRootCache {
			delete(s.gitRootCache, k)
			break
		}
	}
	s.gitRootCache[dir] = root
}

func (s *Scanner) setBranchCache(root, branch string) {
	if len(s.branchCache) >= s.maxCacheSize {
		for k := range s.branchCache {
			delete(s.branchCache, k)
			break
		}
	}
	s.branchCache[root] = BranchEntry{value: branch, expires: time.Now().Add(30 * time.Second)}
}

func main() {
	if err := run(os.Args[1:]); err != nil {
		fmt.Fprintf(os.Stderr, "ports: %v\n", err)
		os.Exit(1)
	}
}

func run(args []string) error {
	showAll := false
	filtered := args[:0]
	for _, arg := range args {
		switch arg {
		case "--all", "-a":
			showAll = true
		default:
			filtered = append(filtered, arg)
		}
	}
	args = filtered

	scanner := NewScanner()
	if len(args) == 0 {
		ports, err := scanner.Scan(false)
		if err != nil {
			return err
		}
		if !showAll {
			ports = filterDevPorts(ports)
		}
		printPorts(ports, !showAll)
		return nil
	}

	switch args[0] {
	case "help", "--help", "-h":
		printHelp()
		return nil
	case "watch":
		return watch(scanner, showAll)
	case "kill":
		return killCommand(scanner, args[1:])
	case "clean":
		return cleanCommand(scanner, args[1:])
	case "ps":
		ports, err := scanner.Scan(false)
		if err != nil {
			return err
		}
		if !showAll {
			ports = filterDevPorts(ports)
		}
		printProcesses(ports)
		return nil
	}

	port, err := strconv.Atoi(args[0])
	if err != nil {
		return fmt.Errorf("unknown command %q; run ports --help", args[0])
	}
	info, err := scanner.PortDetails(port)
	if err != nil {
		return err
	}
	if info == nil {
		fmt.Printf("No listener found on :%d\n", port)
		return nil
	}
	printDetail(*info)
	return nil
}

func (s *Scanner) PortDetails(port int) (*PortInfo, error) {
	ports, err := s.Scan(true)
	if err != nil {
		return nil, err
	}
	for i := range ports {
		if ports[i].Port == port {
			return &ports[i], nil
		}
	}
	return nil, nil
}

func (s *Scanner) Scan(detailed bool) ([]PortInfo, error) {
	raw, err := getListeningPortsRaw()
	if err != nil {
		return nil, err
	}
	pids := uniquePIDs(raw)
	processes := batchProcessInfo(pids)
	cwds := batchCWD(pids)
	dockerPorts := dockerPortMap()

	ports := make([]PortInfo, 0, len(raw))
	for _, entry := range raw {
		info := PortInfo{
			Port:        entry.Port,
			PID:         entry.PID,
			ProcessName: entry.ProcessName,
			RawName:     entry.ProcessName,
			Status:      "healthy",
		}
		if ps, ok := processes[entry.PID]; ok {
			info.PPID = ps.PPID
			info.Command = ps.Command
			info.MemoryKB = ps.RSSKB
			info.Uptime = ps.Elapsed
			if strings.Contains(ps.Stat, "Z") {
				info.Status = "zombie"
			} else if ps.PPID == 1 && isDevProcess(entry.ProcessName, ps.Command) {
				info.Status = "orphaned"
			}
			info.Framework = detectFrameworkFromCommand(ps.Command, entry.ProcessName)
		}
		if docker := dockerPorts[entry.Port]; docker.Name != "" {
			info.ProcessName = "docker"
			info.ProjectName = docker.Name
			info.Framework = detectFrameworkFromImage(docker.Image)
		}
		if cwd := cwds[entry.PID]; cwd != "" {
			info.CWD = cwd
			root := s.findProjectRoot(cwd)
			if info.ProjectName == "" && isMeaningfulRoot(root) {
				info.ProjectRoot = root
				info.ProjectName = filepath.Base(root)
				if info.Framework == "" {
					info.Framework = detectFramework(root)
				}
				if detailed {
					info.GitBranch = s.gitBranch(root)
				}
			}
		}
		ports = append(ports, info)
	}
	sort.Slice(ports, func(i, j int) bool { return ports[i].Port < ports[j].Port })
	return ports, nil
}

type rawPort struct {
	Port        int
	PID         int
	ProcessName string
}

func getListeningPortsRaw() ([]rawPort, error) {
	out, err := command(10*time.Second, "lsof", "-nP", "-iTCP", "-sTCP:LISTEN", "-Fpcn")
	if err != nil {
		return nil, err
	}

	seen := map[int]bool{}
	var result []rawPort
	var pid int
	var name string
	for _, line := range strings.Split(out, "\n") {
		if line == "" {
			continue
		}
		switch line[0] {
		case 'p':
			pid, _ = strconv.Atoi(line[1:])
			name = ""
		case 'c':
			name = line[1:]
		case 'n':
			port := parsePort(line[1:])
			if port == 0 || seen[port] || pid == 0 {
				continue
			}
			seen[port] = true
			result = append(result, rawPort{Port: port, PID: pid, ProcessName: name})
		}
	}
	return result, nil
}

func dockerPortMap() map[int]DockerInfo {
	result := map[int]DockerInfo{}
	out, err := command(5*time.Second, "docker", "ps", "--format", "{{.Ports}}\t{{.Names}}\t{{.Image}}")
	if err != nil {
		return result
	}
	for _, line := range strings.Split(out, "\n") {
		if strings.TrimSpace(line) == "" {
			continue
		}
		parts := strings.Split(line, "\t")
		if len(parts) < 3 {
			continue
		}
		for _, port := range dockerHostPorts(parts[0]) {
			result[port] = DockerInfo{Name: parts[1], Image: parts[2]}
		}
	}
	return result
}

var dockerPortRe = regexp.MustCompile(`(?:^|[\s,])(?:[\d.]+|\[?::\]?):(\d+)->`)

func dockerHostPorts(ports string) []int {
	seen := map[int]bool{}
	var result []int
	for _, match := range dockerPortRe.FindAllStringSubmatch(ports, -1) {
		port, _ := strconv.Atoi(match[1])
		if port > 0 && !seen[port] {
			seen[port] = true
			result = append(result, port)
		}
	}
	return result
}

var portRe = regexp.MustCompile(`:(\d+)(?:\s|$|->)`)

func parsePort(addr string) int {
	matches := portRe.FindAllStringSubmatch(addr, -1)
	if len(matches) == 0 {
		return 0
	}
	port, _ := strconv.Atoi(matches[len(matches)-1][1])
	return port
}

type processInfo struct {
	PPID    int
	Stat    string
	RSSKB   int
	Elapsed string
	Command string
}

func batchProcessInfo(pids []int) map[int]processInfo {
	result := map[int]processInfo{}
	if len(pids) == 0 {
		return result
	}
	out, err := command(5*time.Second, "ps", "-p", joinInts(pids), "-o", "pid=,ppid=,stat=,rss=,etime=,command=")
	if err != nil {
		return result
	}
	for _, line := range strings.Split(out, "\n") {
		fields := strings.Fields(line)
		if len(fields) < 6 {
			continue
		}
		pid, _ := strconv.Atoi(fields[0])
		ppid, _ := strconv.Atoi(fields[1])
		rss, _ := strconv.Atoi(fields[3])
		result[pid] = processInfo{
			PPID:    ppid,
			Stat:    fields[2],
			RSSKB:   rss,
			Elapsed: fields[4],
			Command: strings.Join(fields[5:], " "),
		}
	}
	return result
}

func batchCWD(pids []int) map[int]string {
	result := map[int]string{}
	if len(pids) == 0 {
		return result
	}
	out, err := command(10*time.Second, "lsof", "-a", "-p", joinInts(pids), "-d", "cwd", "-Fpn")
	if err != nil {
		return result
	}
	var pid int
	for _, line := range strings.Split(out, "\n") {
		if line == "" {
			continue
		}
		switch line[0] {
		case 'p':
			pid, _ = strconv.Atoi(line[1:])
		case 'n':
			if pid != 0 {
				result[pid] = line[1:]
			}
		}
	}
	return result
}

func command(timeout time.Duration, name string, args ...string) (string, error) {
	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()
	cmd := exec.CommandContext(ctx, name, args...)
	out, err := cmd.Output()
	if ctx.Err() == context.DeadlineExceeded {
		return "", fmt.Errorf("%s timed out", name)
	}
	if err != nil {
		return "", fmt.Errorf("%s failed: %w", name, err)
	}
	return string(out), nil
}

func uniquePIDs(ports []rawPort) []int {
	seen := map[int]bool{}
	var pids []int
	for _, p := range ports {
		if !seen[p.PID] {
			seen[p.PID] = true
			pids = append(pids, p.PID)
		}
	}
	sort.Ints(pids)
	return pids
}

func joinInts(values []int) string {
	parts := make([]string, len(values))
	for i, v := range values {
		parts[i] = strconv.Itoa(v)
	}
	return strings.Join(parts, ",")
}

func filterDevPorts(ports []PortInfo) []PortInfo {
	filtered := ports[:0]
	for _, p := range ports {
		if isDevProcess(p.ProcessName, p.Command) {
			filtered = append(filtered, p)
		}
	}
	return filtered
}

func isDevProcess(processName, command string) bool {
	name := strings.ToLower(processName)
	cmd := strings.ToLower(command)
	systemPrefixes := []string{
		"rapportd", "controlce", "spotify", "slack", "discord", "firefox",
		"chrome", "google", "safari", "figma", "notion", "zoom", "teams",
		"cursor", "code", "arc", "raycast", "loginwindow", "windowserver",
		"launchd", "mdworker", "cfprefsd", "coreaudio", "sharingd",
	}
	for _, prefix := range systemPrefixes {
		if strings.HasPrefix(name, prefix) {
			return false
		}
	}
	devNames := map[string]bool{
		"node": true, "npm": true, "npx": true, "yarn": true, "pnpm": true,
		"bun": true, "deno": true, "python": true, "python3": true,
		"uvicorn": true, "gunicorn": true, "flask": true, "django": true,
		"ruby": true, "rails": true, "go": true, "air": true, "cargo": true,
		"rustc": true, "java": true, "gradle": true, "mvn": true, "php": true,
		"mix": true, "elixir": true,
	}
	if devNames[name] || strings.HasPrefix(name, "python") {
		return true
	}
	if strings.Contains(name, "docker") || strings.HasPrefix(name, "com.dock") || strings.HasPrefix(name, "vpnkit") {
		return true
	}
	indicators := []string{" next", " vite", " nuxt", " webpack", " remix", " astro", " flask", " django", "manage.py", " uvicorn", " rails", " cargo"}
	padded := " " + cmd
	for _, indicator := range indicators {
		if strings.Contains(padded, indicator) {
			return true
		}
	}
	return false
}

func detectFrameworkFromImage(image string) string {
	img := strings.ToLower(image)
	switch {
	case strings.Contains(img, "postgres"):
		return "PostgreSQL"
	case strings.Contains(img, "redis"):
		return "Redis"
	case strings.Contains(img, "mysql"), strings.Contains(img, "mariadb"):
		return "MySQL"
	case strings.Contains(img, "mongo"):
		return "MongoDB"
	case strings.Contains(img, "nginx"):
		return "nginx"
	case strings.Contains(img, "localstack"):
		return "LocalStack"
	case strings.Contains(img, "rabbitmq"):
		return "RabbitMQ"
	case strings.Contains(img, "kafka"):
		return "Kafka"
	case strings.Contains(img, "elasticsearch"), strings.Contains(img, "opensearch"):
		return "Elasticsearch"
	case strings.Contains(img, "minio"):
		return "MinIO"
	case image != "":
		return "Docker"
	default:
		return ""
	}
}

func (s *Scanner) findProjectRoot(dir string) string {
	if cached, ok := s.gitRootCache[dir]; ok {
		return cached
	}
	markers := []string{".git", "package.json", "Cargo.toml", "go.mod", "pyproject.toml", "Gemfile", "pom.xml", "build.gradle"}
	current := dir
	for depth := 0; depth < 15; depth++ {
		for _, marker := range markers {
			if _, err := os.Stat(filepath.Join(current, marker)); err == nil {
				s.setGitRootCache(dir, current)
				return current
			}
		}
		parent := filepath.Dir(current)
		if parent == current {
			break
		}
		current = parent
	}
	s.setGitRootCache(dir, "")
	return ""
}

func isMeaningfulRoot(root string) bool {
	if root == "" || root == "/" {
		return false
	}
	base := filepath.Base(root)
	if base == "" || base == "/" || strings.HasPrefix(base, ".") {
		return false
	}
	ignored := map[string]bool{"tmp": true, "build": true, "dist": true, "deps": true, "_build": true, "MacOS": true}
	return !ignored[base]
}

func detectFramework(root string) string {
	pkg := filepath.Join(root, "package.json")
	if data, err := os.ReadFile(pkg); err == nil {
		text := strings.ToLower(string(data))
		checks := []struct{ needle, name string }{
			{`"next"`, "Next.js"}, {`"nuxt"`, "Nuxt"}, {`"@sveltejs/kit"`, "SvelteKit"},
			{`"svelte"`, "Svelte"}, {`"@remix-run/react"`, "Remix"}, {`"astro"`, "Astro"},
			{`"vite"`, "Vite"}, {`"@angular/core"`, "Angular"}, {`"vue"`, "Vue"},
			{`"react"`, "React"}, {`"express"`, "Express"}, {`"fastify"`, "Fastify"},
			{`"hono"`, "Hono"}, {`"koa"`, "Koa"}, {`"@nestjs/core"`, "NestJS"},
		}
		for _, check := range checks {
			if strings.Contains(text, check.needle) {
				return check.name
			}
		}
	}
	fileChecks := []struct{ path, name string }{
		{"vite.config.ts", "Vite"}, {"vite.config.js", "Vite"},
		{"next.config.js", "Next.js"}, {"next.config.mjs", "Next.js"},
		{"angular.json", "Angular"}, {"Cargo.toml", "Rust"}, {"go.mod", "Go"},
		{"manage.py", "Django"}, {"Gemfile", "Ruby"},
	}
	for _, check := range fileChecks {
		if _, err := os.Stat(filepath.Join(root, check.path)); err == nil {
			return check.name
		}
	}
	return ""
}

func detectFrameworkFromCommand(command, processName string) string {
	cmd := strings.ToLower(command)
	checks := []struct{ needle, name string }{
		{"next", "Next.js"}, {"vite", "Vite"}, {"nuxt", "Nuxt"},
		{"webpack", "Webpack"}, {"remix", "Remix"}, {"astro", "Astro"},
		{"flask", "Flask"}, {"django", "Django"}, {"manage.py", "Django"},
		{"uvicorn", "FastAPI"}, {"rails", "Rails"}, {"cargo", "Rust"},
	}
	for _, check := range checks {
		if strings.Contains(cmd, check.needle) {
			return check.name
		}
	}
	switch strings.ToLower(processName) {
	case "node":
		return "Node.js"
	case "python", "python3":
		return "Python"
	case "ruby":
		return "Ruby"
	case "java":
		return "Java"
	case "go":
		return "Go"
	}
	return ""
}

func (s *Scanner) gitBranch(root string) string {
	if root == "" {
		return ""
	}
	if cached, ok := s.branchCache[root]; ok {
		if time.Now().Before(cached.expires) {
			return cached.value
		}
		delete(s.branchCache, root)
	}
	out, err := command(3*time.Second, "git", "-C", root, "rev-parse", "--abbrev-ref", "HEAD")
	if err != nil {
		return ""
	}
	branch := strings.TrimSpace(out)
	s.setBranchCache(root, branch)
	return branch
}

func printPorts(ports []PortInfo, filtered bool) {
	if len(ports) == 0 {
		fmt.Println("No active listening ports found.")
		return
	}
	w := tabwriter.NewWriter(os.Stdout, 0, 0, 2, ' ', 0)
	fmt.Fprintln(w, "PORT\tPROCESS\tPID\tPROJECT\tFRAMEWORK\tUPTIME\tSTATUS")
	for _, p := range ports {
		fmt.Fprintf(w, ":%d\t%s\t%d\t%s\t%s\t%s\t%s\n",
			p.Port, value(p.ProcessName), p.PID, value(p.ProjectName), value(p.Framework), formatElapsed(p.Uptime), p.Status)
	}
	w.Flush()
	hint := ""
	if filtered {
		hint = " (--all to show everything)"
	}
	fmt.Printf("\n%d port(s) active%s\n", len(ports), hint)
}

type procRow struct {
	info  PortInfo
	ports []int
}

func printProcesses(ports []PortInfo) {
	byPID := map[int]*procRow{}
	for _, p := range ports {
		if existing, ok := byPID[p.PID]; ok {
			existing.ports = append(existing.ports, p.Port)
		} else {
			byPID[p.PID] = &procRow{info: p, ports: []int{p.Port}}
		}
	}
	var rows []*procRow
	for _, p := range byPID {
		sort.Ints(p.ports)
		rows = append(rows, p)
	}
	sort.Slice(rows, func(i, j int) bool { return rows[i].info.PID < rows[j].info.PID })
	w := tabwriter.NewWriter(os.Stdout, 0, 0, 2, ' ', 0)
	fmt.Fprintln(w, "PID\tPORTS\tPROCESS\tMEM\tPROJECT\tFRAMEWORK\tUPTIME\tCOMMAND")
	for _, p := range rows {
		fmt.Fprintf(w, "%d\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
			p.info.PID, joinPorts(p.ports), value(p.info.ProcessName), formatMemory(p.info.MemoryKB), value(p.info.ProjectName), value(p.info.Framework), formatElapsed(p.info.Uptime), compactCommand(p.info.Command))
	}
	w.Flush()
}

func joinPorts(ports []int) string {
	if len(ports) == 0 {
		return "-"
	}
	parts := make([]string, len(ports))
	for i, p := range ports {
		parts[i] = fmt.Sprintf(":%d", p)
	}
	return strings.Join(parts, ", ")
}

func printDetail(p PortInfo) {
	fmt.Printf("Port       :%d\n", p.Port)
	fmt.Printf("Process    %s\n", value(p.ProcessName))
	fmt.Printf("PID        %d\n", p.PID)
	fmt.Printf("PPID       %d\n", p.PPID)
	fmt.Printf("Status     %s\n", p.Status)
	fmt.Printf("Memory     %s\n", formatMemory(p.MemoryKB))
	fmt.Printf("Uptime     %s\n", formatElapsed(p.Uptime))
	fmt.Printf("Framework  %s\n", value(p.Framework))
	fmt.Printf("Project    %s\n", value(p.ProjectName))
	fmt.Printf("Directory  %s\n", value(p.ProjectRoot))
	fmt.Printf("Branch     %s\n", value(p.GitBranch))
	fmt.Printf("Command    %s\n", value(p.Command))
}

func killCommand(scanner *Scanner, args []string) error {
	force := false
	mode := ""
	var targets []int
	for _, arg := range args {
		switch arg {
		case "-f", "--force":
			force = true
		case "port":
			mode = "port"
		case "pid":
			mode = "pid"
		default:
			if mode == "" {
				return errors.New("usage: ports kill [-f|--force] port <n> [...] | pid <n> [...]")
			}
			expanded, err := expandTarget(arg)
			if err != nil {
				return err
			}
			targets = append(targets, expanded...)
		}
	}
	if mode == "" || len(targets) == 0 {
		return errors.New("usage: ports kill [-f|--force] port <n> [...] | pid <n> [...]")
	}
	signal := syscall.SIGTERM
	if force {
		signal = syscall.SIGKILL
	}
	failed := false
	for _, target := range targets {
		pid, label, ok := resolveKillTarget(scanner, target, mode)
		if !ok {
			if mode == "port" {
				fmt.Printf("No listener found on port :%d\n", target)
			} else {
				fmt.Printf("No process found with PID %d\n", target)
			}
			failed = true
			continue
		}
		if err := syscall.Kill(pid, signal); err != nil {
			fmt.Printf("Failed to kill %s: %v\n", label, err)
			failed = true
			continue
		}
		fmt.Printf("Sent %s to %s\n", signalName(signal), label)
	}
	if failed {
		return errors.New("one or more targets failed")
	}
	return nil
}

func cleanCommand(scanner *Scanner, args []string) error {
	yes := false
	force := false
	for _, arg := range args {
		switch arg {
		case "-y", "--yes":
			yes = true
		case "-f", "--force":
			force = true
		default:
			return fmt.Errorf("unknown clean option %q", arg)
		}
	}

	ports, err := scanner.Scan(false)
	if err != nil {
		return err
	}
	candidates := cleanCandidates(ports)
	if len(candidates) == 0 {
		fmt.Println("No orphaned or zombie dev listeners found.")
		return nil
	}

	printCleanCandidates(candidates)
	if !yes && !confirm("Kill these processes? [y/N] ") {
		fmt.Println("Aborted.")
		return nil
	}

	signal := syscall.SIGTERM
	if force {
		signal = syscall.SIGKILL
	}
	seen := map[int]bool{}
	killed := 0
	failed := false
	for _, p := range candidates {
		if seen[p.PID] {
			continue
		}
		seen[p.PID] = true
		label := fmt.Sprintf("%s PID %d", value(p.ProcessName), p.PID)
		if err := syscall.Kill(p.PID, signal); err != nil {
			fmt.Printf("Failed to kill %s: %v\n", label, err)
			failed = true
			continue
		}
		fmt.Printf("Sent %s to %s\n", signalName(signal), label)
		killed++
	}
	fmt.Printf("Cleaned %d process(es).\n", killed)
	if failed {
		return errors.New("one or more processes failed")
	}
	return nil
}

func cleanCandidates(ports []PortInfo) []PortInfo {
	var candidates []PortInfo
	for _, p := range ports {
		if p.Status != "orphaned" && p.Status != "zombie" {
			continue
		}
		if p.ProcessName == "docker" {
			continue
		}
		if !isDevProcess(p.RawName, p.Command) && !isDevProcess(p.ProcessName, p.Command) {
			continue
		}
		candidates = append(candidates, p)
	}
	sort.Slice(candidates, func(i, j int) bool {
		if candidates[i].Status != candidates[j].Status {
			return candidates[i].Status < candidates[j].Status
		}
		return candidates[i].Port < candidates[j].Port
	})
	return candidates
}

func printCleanCandidates(ports []PortInfo) {
	fmt.Printf("Found %d orphaned/zombie dev listener(s):\n", len(ports))
	w := tabwriter.NewWriter(os.Stdout, 0, 0, 2, ' ', 0)
	fmt.Fprintln(w, "PORT\tPROCESS\tPID\tPROJECT\tSTATUS")
	for _, p := range ports {
		fmt.Fprintf(w, ":%d\t%s\t%d\t%s\t%s\n", p.Port, value(p.ProcessName), p.PID, value(p.ProjectName), p.Status)
	}
	w.Flush()
}

func confirm(prompt string) bool {
	fmt.Print(prompt)
	scanner := bufio.NewScanner(os.Stdin)
	if !scanner.Scan() {
		return false
	}
	answer := strings.ToLower(strings.TrimSpace(scanner.Text()))
	return answer == "y" || answer == "yes"
}

func resolveKillTarget(scanner *Scanner, n int, mode string) (int, string, bool) {
	if mode == "port" {
		info, _ := scanner.PortDetails(n)
		if info != nil {
			return info.PID, fmt.Sprintf(":%d (%s, PID %d)", info.Port, value(info.ProcessName), info.PID), true
		}
		return 0, "", false
	}
	if syscall.Kill(n, 0) == nil {
		return n, fmt.Sprintf("PID %d", n), true
	}
	return 0, "", false
}

func expandTarget(arg string) ([]int, error) {
	if strings.Contains(arg, "-") {
		parts := strings.SplitN(arg, "-", 2)
		start, err := strconv.Atoi(parts[0])
		if err != nil {
			return nil, fmt.Errorf("invalid range %q", arg)
		}
		end, err := strconv.Atoi(parts[1])
		if err != nil || start > end || end-start > 1000 {
			return nil, fmt.Errorf("invalid range %q", arg)
		}
		values := make([]int, 0, end-start+1)
		for i := start; i <= end; i++ {
			values = append(values, i)
		}
		return values, nil
	}
	n, err := strconv.Atoi(arg)
	if err != nil || n < 1 {
		return nil, fmt.Errorf("invalid target %q", arg)
	}
	return []int{n}, nil
}

func watch(scanner *Scanner, showAll bool) error {
	previous := map[int]PortInfo{}
	recentlyKilled := map[int]time.Time{}
	ticker := time.NewTicker(2 * time.Second)
	defer ticker.Stop()

	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, os.Interrupt, syscall.SIGTERM)
	defer signal.Stop(sigCh)

	fmt.Println("Watching ports. Press Ctrl-C to stop.")
	for {
		ports, err := scanner.Scan(false)
		if err != nil {
			return err
		}
		if !showAll {
			ports = filterDevPorts(ports)
		}
		now := time.Now()
		for port, killedAt := range recentlyKilled {
			if now.Sub(killedAt) > 8*time.Second {
				delete(recentlyKilled, port)
			}
		}
		current := map[int]PortInfo{}
		for _, p := range ports {
			if _, hidden := recentlyKilled[p.Port]; hidden {
				continue
			}
			current[p.Port] = p
			if _, ok := previous[p.Port]; !ok {
				fmt.Printf("+ :%d %s PID %d %s\n", p.Port, value(p.ProcessName), p.PID, value(p.ProjectName))
			}
		}
		for port := range previous {
			if _, ok := current[port]; !ok {
				fmt.Printf("- :%d\n", port)
				recentlyKilled[port] = now
			}
		}
		previous = current
		select {
		case <-ticker.C:
		case <-sigCh:
			fmt.Println("\nStopped.")
			return nil
		}
	}
}

func value(s string) string {
	if s == "" {
		return "-"
	}
	return s
}

func formatMemory(kb int) string {
	if kb <= 0 {
		return "-"
	}
	if kb > 1024*1024 {
		return fmt.Sprintf("%.1f GB", float64(kb)/1024/1024)
	}
	if kb > 1024 {
		return fmt.Sprintf("%.1f MB", float64(kb)/1024)
	}
	return fmt.Sprintf("%d KB", kb)
}

func compactCommand(command string) string {
	if len(command) <= 80 {
		return value(command)
	}
	return command[:77] + "..."
}

func formatElapsed(etime string) string {
	if etime == "" {
		return "-"
	}
	var days, hours, minutes, seconds int
	parts := strings.Split(etime, "-")
	if len(parts) == 2 {
		days, _ = strconv.Atoi(parts[0])
		etime = parts[1]
	}
	timeParts := strings.Split(etime, ":")
	switch len(timeParts) {
	case 1:
		seconds, _ = strconv.Atoi(timeParts[0])
	case 2:
		minutes, _ = strconv.Atoi(timeParts[0])
		seconds, _ = strconv.Atoi(timeParts[1])
	case 3:
		hours, _ = strconv.Atoi(timeParts[0])
		minutes, _ = strconv.Atoi(timeParts[1])
		seconds, _ = strconv.Atoi(timeParts[2])
	}
	if days > 0 {
		if hours > 0 {
			return fmt.Sprintf("%dd %dh", days, hours)
		}
		return fmt.Sprintf("%dd", days)
	}
	if hours > 0 {
		if minutes > 0 {
			return fmt.Sprintf("%dh %dm", hours, minutes)
		}
		return fmt.Sprintf("%dh", hours)
	}
	if minutes > 0 {
		if seconds > 0 {
			return fmt.Sprintf("%dm %ds", minutes, seconds)
		}
		return fmt.Sprintf("%dm", minutes)
	}
	return fmt.Sprintf("%ds", seconds)
}

func signalName(sig syscall.Signal) string {
	if sig == syscall.SIGKILL {
		return "SIGKILL"
	}
	return "SIGTERM"
}

func printHelp() {
	fmt.Println(`ports - inspect and manage local listening ports

Usage:
  ports              Show likely dev servers
  ports --all        Show all listening TCP ports
  ports <port>       Show details for one port
  ports ps           Show one row per listening process
  ports clean        Kill orphaned/zombie dev listeners
  ports clean --yes  Clean without prompting
  ports kill port <n> [...]  Kill process listening on port(s)
  ports kill pid <n> [...]   Kill process by PID(s)
  ports kill -f ...          Force kill with SIGKILL
  ports watch        Watch port changes`)
}
