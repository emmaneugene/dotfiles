local launcher = {}

local categories = {
  -- e = {
  --   name = "File Explorer",
  --   apps = {
  --     { name = "Finder", bundle = "com.apple.finder" }
  --   }
  -- },
  -- t = {
  --   name = "Terminal",
  --   apps = {
  --     { name = "Ghostty", bundle = "com.mitchellh.ghostty" }
  --   }
  -- },
  -- i = {
  --   name = "IDE",
  --   apps = {
  --     { name = "IntelliJ", bundle = "com.jetbrains.intellij" },
  --     { name = "PyCharm",  bundle = "com.jetbrains.pycharm" },
  --     { name = "Cursor",   bundle = "com.todesktop.230313mzl4w4u92" }
  --   }
  -- },
  -- o = {
  --   name = "Notes",
  --   apps = {
  --     { name = "Obsidian", bundle = "md.Obsidian" }
  --   }
  -- },
  -- p = {
  --   name = "API Client",
  --   apps = {
  --     { name = "Postman", bundle = "com.postmanlabs.mac" }
  --   }
  -- },
  -- a = {
  --   name = "Activity Monitor",
  --   apps = {
  --     { name = "Activity Monitor", bundle = "com.apple.ActivityMonitor" }
  --   }
  -- },
  -- d = {
  --   name = "DB Client",
  --   apps = {
  --     { name = "DBeaver", bundle = "org.jkiss.dbeaver.core.product" }
  --   }
  -- },
  -- g = {
  --   name = "Admin Chats",
  --   apps = {
  --     { name = "WhatsApp", bundle = "net.whatsapp.WhatsApp" },
  --     { name = "Discord",  bundle = "com.hnc.Discord" }
  --   }
  -- },
  -- l = {
  --   name = "LLM",
  --   apps = {
  --     { name = "Claude", bundle = "com.anthropic.claudefordesktop" }
  --   }
  -- },
  -- x = {
  --   name = "Code Editor",
  --   apps = {
  --     { name = "VSCode", bundle = "com.microsoft.VSCode" }
  --   }
  -- },
  -- c = {
  --   name = "Chat",
  --   apps = {
  --     { name = "Telegram", bundle = "ru.keepcoder.Telegram" },
  --   }
  -- },
  -- b = {
  --   name = "Browser",
  --   apps = {
  --     { name = "Firefox", bundle = "org.mozilla.firefox" }
  --   }
  -- },
  -- n = {
  --   name = "Alt Browsers",
  --   apps = {
  --     { name = "Chromium", bundle = "org.chromium.Chromium" }
  --   }
  -- },
  -- m = {
  --   name = "Mail",
  --   apps = {
  --     { name = "Mail", bundle = "com.apple.mail" }
  --   }
  -- }
}

function launcher.init()
  hs.hotkey.bind(hyper, "`", hs.reload)

  function launchFromCategory(category)
    if #category.apps == 1 then
      hs.application.launchOrFocusByBundleID(category.apps[1].bundle)
      return
    end

    local choices = hs.fnutils.map(category.apps, function(app)
      return { text = app.name, bundleId = app.bundle }
    end)

    local chooser = hs.chooser.new(function(choice)
      if choice then
        hs.application.launchOrFocusByBundleID(choice.bundleId)
      end
    end)

    chooser:choices(choices)
    local primaryScreen = hs.screen.primaryScreen()
    local primaryFrame = primaryScreen:frame()
    chooser:show({
      x = primaryFrame.x + primaryFrame.w * 0.3,
      y = primaryFrame.y + primaryFrame.h * 0.2
    })
  end

  for key, category in pairs(categories) do
    hs.hotkey.bind(hyper, key, function()
      launchFromCategory(category)
    end)
  end

  -- Toggle dark mode
  hs.hotkey.bind(ctrlCmd, "o", function()
    hs.osascript.applescript([[
        tell application "System Events"
            tell appearance preferences
                set dark mode to not dark mode
            end tell
        end tell
    ]])
  end)

  -- Close notifications
  hs.hotkey.bind(ctrlCmd, "b", function()
    hs.osascript.applescript([[
        tell application "System Events" to tell application process "NotificationCenter"
            try
                repeat with uiElement in (actions of UI elements of scroll area 1 of group 1 of group 1 of window "Notification Center" of application process "NotificationCenter" of application "System Events")
                    if description of uiElement contains "Close" then
                        perform uiElement
                    end if
                    if description of uiElement contains "Clear" then
                        perform uiElement
                    end if
                end repeat
            return ""
            end try
        end tell
    ]])
  end)

  -- Hide all windows
  hs.hotkey.bind(ctrlCmd, "m", function()
    hs.osascript.applescript([[
        tell application "System Events"
            set visible of every process to false
        end tell
    ]])
  end)

  -- Show controls
  hs.hotkey.bind(ctrlCmd, "c", function()
    hs.osascript.applescript([[
        tell application "System Events"
            tell process "ControlCenter"
                click menu bar item 2 of menu bar 1
            end tell
        end tell
    ]])
  end)
end

return launcher
