-------------------------------------------------------------------
-- Globals
-------------------------------------------------------------------
hs.window.animationDuration = 0

-------------------------------------------------------------------
-- Window Layouts
-------------------------------------------------------------------

-- These are just convenient names for layouts. We can use numbers
-- between 0 and 1 for defining 'percentages' of screen real estate.
units = {
  Top = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  Bottom = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
  Left = { x = 0.00, y = 0.50, w = 0.50, h = 1.00 },
  Right = { x = 0.50, y = 0.50, w = 0.50, h = 1.00 },
  TopLeft = { x = 0.00, y = 0.00, w = 0.50, h = 0.50 },
  TopRight = { x = 0.50, y = 0.00, w = 0.50, h = 0.50 },
  BottomLeft = { x = 0.00, y = 0.50, w = 0.50, h = 0.50 },
  BottomRight = { x = 0.50, y = 0.50, w = 0.50, h = 0.50 },
}

-- All of the mappings for moving the window of the 'current' application
-- to the right spot. Tries to map 'vim' keys as much as possible, but
-- deviates to a 'visual' representation when that's not possible.
mash = { 'alt', 'ctrl', 'cmd' }
hs.hotkey.bind(mash, 'up', function() hs.window.focusedWindow():move(units.Top, nil, true) end)
hs.hotkey.bind(mash, 'down', function() hs.window.focusedWindow():move(units.Bottom, nil, true) end)
hs.hotkey.bind(mash, 'left', function() hs.window.focusedWindow():move(units.Left, nil, true) end)
hs.hotkey.bind(mash, 'right', function() hs.window.focusedWindow():move(units.Right, nil, true) end)
hs.hotkey.bind(mash, '1', function() hs.window.focusedWindow():move(units.TopLeft, nil, true) end)
hs.hotkey.bind(mash, '2', function() hs.window.focusedWindow():move(units.TopRight, nil, true) end)
hs.hotkey.bind(mash, '3', function() hs.window.focusedWindow():move(units.BottomLeft, nil, true) end)
hs.hotkey.bind(mash, '4', function() hs.window.focusedWindow():move(units.BottomRight, nil, true) end)
hs.hotkey.bind(mash, 'c', function() hs.window.focusedWindow():centerOnScreen(nil, nil, nil) end)
hs.hotkey.bind(mash, 'z', function() hs.window.focusedWindow():toggleZoom() end)
hs.hotkey.bind(mash, 'm', function() hs.window.focusedWindow():maximize() end)
hs.hotkey.bind(mash, 'f',
  function() hs.window.focusedWindow():setFullScreen(not hs.window.focusedWindow():isFullScreen()) end)

-------------------------------------------------------------------
-- Launcher

-- We need to store the reference to the alert window
AppLauncherAlertWindow = nil

-- This is the key mode handle
LaunchMode = hs.hotkey.modal.new({}, nil, '')

-- Leaves the launch mode, returning the keyboard to its normal
-- state, and closes the alert window, if it's showing
function leaveMode()
  if AppLauncherAlertWindow ~= nil then
    hs.alert.closeSpecific(AppLauncherAlertWindow, 0)
    AppLauncherAlertWindow = nil
  end
  LaunchMode:exit()
end

-- So simple, so awesome.
function switchToApp(app)
  hs.application.open(app)
  leaveMode()
end

function openApp(name)
  local app = hs.application.get(name)

  if app then
    if app:isFrontmost() then
      app:hide()
    else
      app:mainWindow():focus()
    end
  else
    hs.application.launchOrFocus(name)
  end

  leaveMode()
end

-- Enters launch mode.
hs.hotkey.bind({ 'cmd' }, 'e', function()
  LaunchMode:enter()
  AppLauncherAlertWindow = hs.alert.show('App Launcher Mode:\na - Calendar\nb - Browser\ne - Mail\ng - Telegram\ny - Spotify\nn - Bear\ns - Slack\nt - Terminal'
    , 'infinite')
end)

-- When in launch mode, hitting cmd+e again leaves it
LaunchMode:bind({ 'cmd' }, 'e', function() leaveMode() end)

-- Mapped keys
LaunchMode:bind({}, 'a', function() openApp('Calendar') end)
LaunchMode:bind({}, 'b', function() openApp('Firefox') end)
LaunchMode:bind({}, 'e', function() openApp('Thunderbird') end)
LaunchMode:bind({}, 'g', function() openApp('Telegram') end)
LaunchMode:bind({}, 'n', function() openApp('Bear') end)
LaunchMode:bind({}, 's', function() openApp('Slack') end)
LaunchMode:bind({}, 't', function() openApp('Alacritty') end)
LaunchMode:bind({}, 'y', function() openApp('Spotify') end)
LaunchMode:bind({}, 'v', function() openApp('Visual Studio Code') end)
LaunchMode:bind({}, 'z', function() openApp('zoom.us') end)
LaunchMode:bind({}, '`', function() hs.reload(); leaveMode() end)
