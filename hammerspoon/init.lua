-- Use Caps as hyper key.
-- Remapped Caps with karabiner
local hyper = { 'cmd', 'alt', 'ctrl', 'shift' }

-- Switch application with hyper + key
local applications = {
    t = 'iTerm',
    s = 'Safari Technology Preview',
    m = 'Spotify',
}

for key, app in pairs(applications) do
    hs.hotkey.bind(hyper, key, function()
        hs.application.launchOrFocus(app)
    end)
end

-- Automatically open minimized app with app switcher
local appWatcher = hs.application.watcher.new(function(appName, eventType, _)
    if eventType == hs.application.watcher.activated then
        if appName ~= 'Finder' then
            hs.application.launchOrFocus(appName)
        end
    end
end)
appWatcher:start()

-- Annotations for completion
hs.loadSpoon('EmmyLua')

-- Reload on file edit
hs.pathwatcher.new(hs.configdir, hs.reload):start()
hs.hotkey.bind(hyper, 'R', function()
    hs.reload()
end)
hs.alert.show('Hammerspoon🔨')
