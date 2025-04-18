local launcher = {}

local appBindings = {
  e = "com.apple.finder",               -- Finder
  r = "com.apple.Preview",              -- Preview
  t = "org.alacritty",                  -- Alacritty
  y = "com.bitwarden.Desktop",          -- Bitwarden
  o = "md.Obsidian",                    -- Obsidian
  p = "com.postmanlabs.mac",            -- Postman
  a = "com.apple.ActivityMonitor",      -- ActivityMonitor
  s = "com.spotify.client",             -- Spotify
  d = "org.jkiss.dbeaver.core.product", -- DBeaver
  g = "com.tinyspeck.slackmacgap",      -- Slack
  l = "com.anthropic.claudefordesktop", -- Claude
  z = "us.zoom.xos",                    -- Zoom
  x = "com.microsoft.VSCode",           -- VisualStudioCode
  c = "ru.keepcoder.Telegram",          -- Telegram
  b = "org.mozilla.firefox",            -- Firefox
  n = "notion.id",                      -- Notion
  m = "com.microsoft.Outlook"           -- MicrosoftOutlook
}

function launcher.init()
  hs.hotkey.bind(hyper, "`", hs.reload)

  for key, bundle in pairs(appBindings) do
    hs.hotkey.bind(hyper, key, function() hs.application.launchOrFocusByBundleID(bundle) end)
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
