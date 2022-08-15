-- Use Caps as hyper key.
-- Remapped Caps with karabiner
local hyper = { 'cmd', 'alt', 'ctrl', 'shift' }

-- Switch application with hyper + key
local applications = {
    t = 'kitty',
    s = 'Safari',
    m = 'Spotify',
    c = 'Google Chrome',
}

for key, app in pairs(applications) do
    hs.hotkey.bind(hyper, key, function()
        hs.application.launchOrFocus(app)
    end)
end

-- Comment back in if I one time try out yabai again
-- require('yabai')

-- Annotations for completion
hs.loadSpoon('EmmyLua')

-- Reload on file edit
hs.pathwatcher.new(hs.configdir, hs.reload):start()
hs.hotkey.bind(hyper, 'R', function()
    hs.reload()
end)
hs.alert.show('Hammerspoon🔨')
