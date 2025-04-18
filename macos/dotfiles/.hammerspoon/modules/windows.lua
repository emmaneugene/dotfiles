-- Window management (similar to Rectangle)
local windows = {}

-- Screen positions
local winPositions = {
  maximized = hs.layout.maximized,
  centered = { x = 0.15, y = 0.15, w = 0.7, h = 0.7 },
  left = { x = 0, y = 0, w = 0.5, h = 1 },
  right = { x = 0.5, y = 0, w = 0.5, h = 1 },
  topLeft = { x = 0, y = 0, w = 0.5, h = 0.5 },
  topRight = { x = 0.5, y = 0, w = 0.5, h = 0.5 },
  bottomLeft = { x = 0, y = 0.5, w = 0.5, h = 0.5 },
  bottomRight = { x = 0.5, y = 0.5, w = 0.5, h = 0.5 },
  top = { x = 0, y = 0, w = 1, h = 0.5 },
  bottom = { x = 0, y = 0.5, w = 1, h = 0.5 },
  thirdLeft = { x = 0, y = 0, w = 0.33, h = 1 },
  thirdMiddle = { x = 0.33, y = 0, w = 0.34, h = 1 },
  thirdRight = { x = 0.67, y = 0, w = 0.33, h = 1 },
  twoThirdLeft = { x = 0, y = 0, w = 0.67, h = 1 },
  twoThirdRight = { x = 0.33, y = 0, w = 0.67, h = 1 }
}

function windows.moveWindow(position)
  local win = hs.window.focusedWindow()
  if win then
    local screen = win:screen()
    win:move(position, screen, true)
  end
end

function windows.moveToScreen(direction)
  local win = hs.window.focusedWindow()
  if win then
    if direction == "left" then
      win:moveOneScreenWest()
    elseif direction == "right" then
      win:moveOneScreenEast()
    elseif direction == "up" then
      win:moveOneScreenNorth()
    elseif direction == "down" then
      win:moveOneScreenSouth()
    end
  end
end

function windows.init()
  hs.hotkey.bind(ctrlAlt, "return", function() windows.moveWindow(winPositions.maximized) end)
  hs.hotkey.bind(ctrlAlt, "delete", function() windows.moveWindow(winPositions.centered) end)
  hs.hotkey.bind(ctrlAlt, "left", function() windows.moveWindow(winPositions.left) end)
  hs.hotkey.bind(ctrlAlt, "right", function() windows.moveWindow(winPositions.right) end)
  hs.hotkey.bind(ctrlAlt, "up", function() windows.moveWindow(winPositions.top) end)
  hs.hotkey.bind(ctrlAlt, "down", function() windows.moveWindow(winPositions.bottom) end)
  hs.hotkey.bind(ctrlAlt, "[", function() windows.moveWindow(winPositions.topLeft) end)
  hs.hotkey.bind(ctrlAlt, "]", function() windows.moveWindow(winPositions.topRight) end)
  hs.hotkey.bind(ctrlAlt, ";", function() windows.moveWindow(winPositions.bottomLeft) end)
  hs.hotkey.bind(ctrlAlt, "'", function() windows.moveWindow(winPositions.bottomRight) end)
  hs.hotkey.bind(ctrlAlt, "i", function() windows.moveWindow(winPositions.thirdLeft) end)
  hs.hotkey.bind(ctrlAlt, "o", function() windows.moveWindow(winPositions.thirdMiddle) end)
  hs.hotkey.bind(ctrlAlt, "p", function() windows.moveWindow(winPositions.thirdRight) end)
  hs.hotkey.bind(ctrlAlt, "k", function() windows.moveWindow(winPositions.twoThirdLeft) end)
  hs.hotkey.bind(ctrlAlt, "l", function() windows.moveWindow(winPositions.twoThirdRight) end)
  hs.hotkey.bind(ctrlAltCmd, "left", function() windows.moveToScreen("left") end)
  hs.hotkey.bind(ctrlAltCmd, "right", function() windows.moveToScreen("right") end)
  hs.hotkey.bind(ctrlAltCmd, "up", function() windows.moveToScreen("up") end)
  hs.hotkey.bind(ctrlAltCmd, "down", function() windows.moveToScreen("down") end)
  hs.hotkey.bind(ctrlAlt, "h", function() hs.hints.windowHints() end)
end

return windows
