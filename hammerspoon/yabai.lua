local hyper = { 'cmd', 'alt', 'ctrl', 'shift' }

local map = function(mod, key, cmd)
    hs.hotkey.bind(mod, key, function()
        hs.execute('/usr/local/bin/' .. cmd)
    end)
end

-- Move to windows
map(hyper, 'h', 'yabai -m window --focus west')
map(hyper, 'j', 'yabai -m window --focus south')
map(hyper, 'k', 'yabai -m window --focus north')
map(hyper, 'l', 'yabai -m window --focus east')

-- Move to spaces
map(hyper, '1', 'yabai -m space --focus 1')
map(hyper, '2', 'yabai -m space --focus 2')
map(hyper, '3', 'yabai -m space --focus 3')

map({ 'ctrl', 'alt' }, 'left', 'yabai -m window --warp west')
map({ 'ctrl', 'alt' }, 'up', 'yabai -m window --warp south')
map({ 'ctrl', 'alt' }, 'down', 'yabai -m window --warp north')
map({ 'ctrl', 'alt' }, 'right', 'yabai -m window --warp east')

-- map({ 'shift', 'alt' }, '1', 'yabai -m window --space 1')
-- map({ 'shift', 'alt' }, '2', 'yabai -m window --space 2')
-- map({ 'shift', 'alt' }, '3', 'yabai -m window --space 3')

map(hyper, 'f', 'yabai -m window --toggle zoom-fullscreen')
