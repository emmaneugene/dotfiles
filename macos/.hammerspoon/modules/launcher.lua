local launcher = {}

local categories = {
  e = {
    name = "File Explorer",
    apps = {
      { name = "Finder", bundle = "com.apple.finder" },
    }
  },
  t = {
    name = "Terminal",
    apps = {
      { name = "Ghostty", bundle = "com.mitchellh.ghostty" },
    }
  },
  i = {
    name = "IDE",
    apps = {
      { name = "Cursor",   bundle = "com.todesktop.230313mzl4w4u92" },
      { name = "VSCode",   bundle = "com.microsoft.VSCode" },
      { name = "IntelliJ", bundle = "com.jetbrains.intellij" },
      { name = "PyCharm",  bundle = "com.jetbrains.pycharm" },
    }
  },
  o = {
    name = "Notes",
    apps = {
      { name = "Obsidian", bundle = "md.Obsidian" },
    }
  },
  p = {
    name = "API Client",
    apps = {
      { name = "Postman", bundle = "com.postmanlabs.mac" },
    }
  },
  a = {
    name = "Activity Monitor",
    apps = {
      { name = "Activity Monitor", bundle = "com.apple.ActivityMonitor" },
    }
  },
  s = {
    name = "Screenshot utility",
    apps = {
      { name = "Shottr", bundle = "cc.ffitch.shottr" },
    }
  },
  d = {
    name = "DB Client",
    apps = {
      { name = "DBeaver", bundle = "org.jkiss.dbeaver.core.product" },
    }
  },
  g = {
    name = "Admin Chats",
    apps = {
      { name = "Discord",  bundle = "com.hnc.Discord" },
      { name = "WhatsApp", bundle = "net.whatsapp.WhatsApp" },
    }
  },
  k = {
    name = "ADE",
    apps = {
      { name = "Codex", bundle = "com.openai.codex" },
    }
  },
  l = {
    name = "LLM chat",
    apps = {
      { name = "ChatGPT", bundle = "com.openai.chat" },
    }
  },
  x = {
    name = "Editor",
    apps = {
      { name = "Zed", bundle = "dev.zed.Zed" },
    }
  },
  c = {
    name = "Chat",
    apps = {
      { name = "Telegram", bundle = "ru.keepcoder.Telegram" },
    }
  },
  b = {
    name = "Browser",
    apps = {
      { name = "Firefox", bundle = "org.mozilla.firefox" },
      { name = "Zen",     bundle = "app.zen-browser.zen" },
    }
  },
  n = {
    name = "Alt Browser",
    apps = {
      { name = "Chromium", bundle = "org.chromium.Chromium" },
      { name = "Helium",   bundle = "net.imput.helium" },
    }
  },
  m = {
    name = "Mail",
    apps = {
      { name = "Mail",    bundle = "com.apple.mail" },
      { name = "Outlook", bundle = "com.microsoft.Outlook" },
    }
  }
}

function launcher.init()
  hs.hotkey.bind(hyper, "`", hs.reload)

  local activeModal = nil
  local activeAlertId = nil

  local function dismissActive()
    if activeAlertId then hs.alert.closeSpecific(activeAlertId) end
    if activeModal then activeModal:exit() end
    activeModal = nil
    activeAlertId = nil
  end

  function launchFromCategory(category)
    dismissActive()

    if #category.apps == 1 then
      hs.application.launchOrFocusByBundleID(category.apps[1].bundle)
      return
    end

    local index = 1
    local modal = hs.hotkey.modal.new()
    activeModal = modal

    local function showCurrent()
      if activeAlertId then hs.alert.closeSpecific(activeAlertId) end
      local app = category.apps[index]
      local label = "[" .. index .. "/" .. #category.apps .. "]: "
          .. app.name
      activeAlertId = hs.alert.show(label, hs.alert.defaultStyle, hs.screen.primaryScreen(), 999999)
    end

    local function dismiss()
      dismissActive()
    end

    modal:bind("", "tab", function()
      index = (index % #category.apps) + 1
      showCurrent()
    end)

    modal:bind("shift", "tab", function()
      index = ((index - 2) % #category.apps) + 1
      showCurrent()
    end)

    modal:bind("", "return", function()
      local bundle = category.apps[index].bundle
      dismiss()
      hs.application.launchOrFocusByBundleID(bundle)
    end)

    modal:bind("", "escape", dismiss)

    modal:enter()
    showCurrent()
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
