hs.hotkey.alertDuration = 0.25
hs.window.animationDuration = 0

hs.alert.show("Hammerspoon config loaded")

hyper = { "cmd", "alt", "ctrl", "shift" }
ctrlAlt = { "ctrl", "alt" }
ctrlCmd = { "ctrl", "cmd" }
ctrlAltCmd = { "ctrl", "alt", "cmd" }

local modules = {
  "amphetamine",
  "launcher",
  "windows"
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
