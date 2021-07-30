-- Use Caps as hyper key.
-- Remapped Caps with karabiner
local hyper = {"cmd", "alt", "ctrl", "shift"}

-- Switch application with hyper + key
local applications = {
    t = 'iTerm',
    s = 'Safari Technology Preview'
}

for key, app in pairs(applications) do
    hs.hotkey.bind(hyper, key, function()
        hs.application.launchOrFocus(app)
    end)
end

-- Automatically open minimized app with app switcher
hs.application.watcher.new(function(appName, eventType, _)
    if (eventType == hs.application.watcher.activated) then
        if (appName ~= "Finder") then
            local app = hs.application.frontmostApplication()
            local name = app:name()
            hs.application.launchOrFocus(name)
        end
    end
end):start()

-- Annotations for completion
hs.loadSpoon("EmmyLua")

-- Reload on file edit
hs.pathwatcher.new(hs.configdir, hs.reload):start()
hs.alert.show("Hammerspoon🔨")
