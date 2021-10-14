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
hs.hotkey.bind(mash, 'f', function() hs.window.focusedWindow():setFullScreen(not hs.window.focusedWindow():isFullScreen()) end)

-------------------------------------------------------------------
-- Launcher

-- We need to store the reference to the alert window
appLauncherAlertWindow = nil

-- This is the key mode handle
launchMode = hs.hotkey.modal.new({}, nil, '')

-- Leaves the launch mode, returning the keyboard to its normal
-- state, and closes the alert window, if it's showing
function leaveMode()
  if appLauncherAlertWindow ~= nil then
    hs.alert.closeSpecific(appLauncherAlertWindow, 0)
    appLauncherAlertWindow = nil
  end
  launchMode:exit()
end

-- So simple, so awesome.
function switchToApp(app)
  hs.application.open(app)
  leaveMode()
end

-- Enters launch mode.
hs.hotkey.bind({ 'cmd' }, 'e', function()
  launchMode:enter()
  appLauncherAlertWindow = hs.alert.show('App Launcher Mode:\na - Calendar\nb - Browser\ne - Mail\ng - Telegram\ny - Spotify\nn - Bear\ns - Slack\nt - Terminal', 'infinite')
end)

-- When in launch mode, hitting cmd+e again leaves it
launchMode:bind({ 'cmd' }, 'e', function() leaveMode() end)

-- Mapped keys
launchMode:bind({}, 'a',  function() switchToApp('Calendar.app') end)
launchMode:bind({}, 'b',  function() switchToApp('Firefox.app') end)
launchMode:bind({}, 'e',  function() switchToApp('Thunderbird.app') end)
launchMode:bind({}, 'g',  function() switchToApp('Telegram.app') end)
launchMode:bind({}, 'n',  function() switchToApp('Bear.app') end)
launchMode:bind({}, 's',  function() switchToApp('Slack.app') end)
launchMode:bind({}, 't',  function() switchToApp('Alacritty.app') end)
launchMode:bind({}, 'y',  function() switchToApp('Spotify.app') end)
launchMode:bind({}, 'z',  function() switchToApp('zoom.us.app') end)
launchMode:bind({}, '`',  function() hs.reload(); leaveMode() end)
