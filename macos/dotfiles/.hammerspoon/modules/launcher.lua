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
      { name = "VSCode",   bundle = "com.microsoft.VSCode" },
      { name = "IntelliJ", bundle = "com.jetbrains.intellij" },
      { name = "PyCharm",  bundle = "com.jetbrains.pycharm" },
    }
  },
  o = {
    name = "Notes",
    apps = {
      { name = "Obsidian", bundle = "md.Obsidian" },
      -- { name = "Notion",   bundle = "notion.id" },
    }
  },
  p = {
    name = "API Client",
    apps = {
      -- { name = "Postman", bundle = "com.postmanlabs.mac" },
      { name = "Yaak", bundle = "app.yaak.desktop" },
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
      -- { name = "TablePro", bundle = "com.TablePro" },
    }
  },
  g = {
    name = "Admin Chats",
    apps = {
      -- { name = "Discord",  bundle = "com.hnc.Discord" },
      { name = "Slack", bundle = "com.tinyspeck.slackmacgap" },
    }
  },
  j = {
    name = "Cursor",
    apps = {
      { name = "Cursor",   bundle = "com.todesktop.230313mzl4w4u92" },
    }
  },
  k = {
    name = "Codex",
    apps = {
      { name = "Codex", bundle = "com.openai.codex" },
    }
  },
  l = {
    name = "Claude",
    apps = {
      { name = "Claude", bundle = "com.anthropic.claudefordesktop" },
    }
  },
  x = {
    name = "Editor",
    apps = {
      { name = "Zed", bundle = "dev.zed.Zed" },
    }
  },
  z = {
    name = "Video Conferencing",
    apps = {
      { name = "Zoom", bundle = "us.zoom.xos" },
    }
  },
  -- c = {
  --   name = "Chat",
  --   apps = {
  --     { name = "Telegram", bundle = "ru.keepcoder.Telegram" },
  --   }
  -- },
  b = {
    name = "Browser",
    apps = {
      { name = "Chrome", bundle = "com.google.Chrome" },
    }
  },
  n = {
    name = "Alt Browser",
    apps = {
      { name = "Helium", bundle = "net.imput.helium" },
    }
  },
  m = {
    name = "Mail",
    apps = {
      -- { name = "Mail",    bundle = "com.apple.mail" },
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

  -- Hide all notifications
  hs.hotkey.bind(ctrlCmd, "b", function()
    hs.osascript.applescript([[
        on pressIfClearAction(actionElement)
            tell application "System Events"
                set actionName to ""
                set actionDescription to ""

                try
                    set actionName to name of actionElement as text
                end try
                try
                    set actionDescription to description of actionElement as text
                end try

                set actionLabel to actionName & " " & actionDescription
                if actionLabel contains "Close" or actionLabel contains "Clear" then
                    perform actionElement
                    delay 0.05
                end if
            end tell
        end pressIfClearAction

        on pressMatchingControls(theElements)
            tell application "System Events"
                repeat with uiElement in theElements
                    try
                        set elementName to ""
                        set elementDescription to ""
                        set elementRole to ""
                        set elementHelp to ""

                        try
                            set elementName to name of uiElement as text
                        end try
                        try
                            set elementDescription to description of uiElement as text
                        end try
                        try
                            set elementRole to role of uiElement as text
                        end try
                        try
                            set elementHelp to help of uiElement as text
                        end try

                        repeat with actionElement in actions of uiElement
                            my pressIfClearAction(actionElement)
                        end repeat

                        set elementLabel to elementName & " " & elementDescription & " " & elementRole & " " & elementHelp
                        if elementLabel contains "Close" or elementLabel contains "Clear" then
                            if elementRole contains "button" then
                                click uiElement
                            else
                                perform action "AXPress" of uiElement
                            end if
                            delay 0.05
                        end if

                        my pressMatchingControls(UI elements of uiElement)
                    end try
                end repeat
            end tell
        end pressMatchingControls

        tell application "System Events"
            tell application process "NotificationCenter"
                try
                    my pressMatchingControls(UI elements of window "Notification Center")
                end try
            end tell
        end tell
    ]])
  end)

  -- Show control center
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
