hs.hotkey.alertDuration = 0.25
hs.window.animationDuration = 0

hs.ipc.cliInstall()
hs.alert.show("Hammerspoon config loaded")

hyper = { "cmd", "alt", "ctrl", "shift" }
ctrlAlt = { "ctrl", "alt" }
ctrlCmd = { "ctrl", "cmd" }
ctrlAltCmd = { "ctrl", "alt", "cmd" }

-- Import from modules/ as needed
local modules = {
  "launcher"
}

for _, module in ipairs(modules) do
  local ok, mod = pcall(require, "modules." .. module)
  if ok and mod then
    if type(mod.init) == "function" then
      mod.init()
    end
  else
    print("Failed to load module: " .. module)
  end
end
