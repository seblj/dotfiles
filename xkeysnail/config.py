# -*- coding: utf-8 -*-
# autostart = true

import re
from xkeysnail.transform import *

def regex_str(applications):
    """
    Returns a regex string that match one of the applications in the list provided
    """
    applications = [app.casefold() for app in applications]
    return "|".join(str('^'+x+'$') for x in applications)

# Use the following for testing terminal keymaps
TERMINALS = [
    "alacritty",
    "gnome-terminal",
    "hyper",
    "kitty",
    "xterm",
]

# Use for browser specific hotkeys
BROWSERS = [
    "Chromium",
    "Chromium-browser",
    "Discord",
    "Epiphany",
    "Firefox",
    "Firefox Developer Edition",
    "Navigator",
    "firefoxdeveloperedition",
    "Waterfox",
    "Google-chrome",
    "microsoft-edge",
    "microsoft-edge-dev",
]

CHROMES = [
    "Chromium",
    "Chromium-browser",
    "Google-chrome",
    "microsoft-edge",
    "microsoft-edge-dev",
]

# [Global modemap] Change modifier keys as in xmodmap
define_conditional_modmap(lambda wm_class: wm_class.casefold() not in TERMINALS,{
    # - Mac Only
    Key.LEFT_META: Key.RIGHT_CTRL,  # Mac
    Key.RIGHT_META: Key.RIGHT_CTRL, # Mac - Multi-language (Remove)
    Key.RIGHT_CTRL: Key.RIGHT_META, # Mac - Multi-language (Remove)
})

# [Conditional modmap] Change modifier keys in certain applications
define_conditional_modmap(re.compile(regex_str(TERMINALS), re.IGNORECASE), {
    # - Mac Only
    Key.LEFT_META: Key.RIGHT_CTRL,  # Mac
    Key.RIGHT_META: Key.RIGHT_CTRL, # Mac - Multi-language (Remove)
    Key.RIGHT_CTRL: Key.LEFT_CTRL,  # Mac - Multi-language (Remove)
})

# Global keymaps
define_keymap(None, {
    K("RC-Tab"): K("Super-Tab"),
    K("RC-Shift-Tab"): K("Super-Shift-Tab"),

    K("RC-Space"): K("Super-Space"),

    K("RC-Left"): K("Super-Left"),
    K("RC-Right"): K("Super-Right"),
    K("RC-Up"): K("Super-Up"),
    K("RC-Down"): K("Super-Down"),

    K("C-Alt-Enter"): K("Super-Up"),
    K("C-Alt-Left"): K("Super-Left"),
    K("C-Alt-Right"): K("Super-Right"),

    K("RC-Shift-Left"): K("Super-Shift-Left"),
    K("RC-Shift-Right"): K("Super-Shift-Right"),
    K("Alt-BACKSPACE"): K("C-BACKSPACE"),

    K("Alt-Left"): K("C-Left"),
    K("Alt-Right"): K("C-Right"),

    # Lock pc
    K("C-Alt-L"): K("Super-L"),
})

# Keybindings for Chromes
define_keymap(re.compile(regex_str(CHROMES), re.IGNORECASE),{
    K("C-comma"): [K("Alt-e"), K("s"),K("Enter")],    # Open preferences
    K("RC-q"):              K("Alt-F4"),              # Quit Chrome(s) browsers with Cmd+Q
    K("RC-Left_Brace"):     K("Alt-Left"),            # Page nav: Back to prior page in history
    K("RC-Right_Brace"):    K("Alt-Right"),           # Page nav: Forward to next page in history
}, "Chrome Browsers")

# Keybindings for General Web Browsers
define_keymap(re.compile(regex_str(BROWSERS), re.IGNORECASE),{
    K("Alt-RC-I"): K("RC-Shift-I"),   # Dev tools
    K("Alt-RC-J"): K("RC-Shift-J"),   # Dev tools
    K("RC-Key_1"): K("Alt-Key_1"),    # Jump to Tab #1-#8
    K("RC-Key_2"): K("Alt-Key_2"),
    K("RC-Key_3"): K("Alt-Key_3"),
    K("RC-Key_4"): K("Alt-Key_4"),
    K("RC-Key_5"): K("Alt-Key_5"),
    K("RC-Key_6"): K("Alt-Key_6"),
    K("RC-Key_7"): K("Alt-Key_7"),
    K("RC-Key_8"): K("Alt-Key_8"),
    K("RC-Key_9"): K("Alt-Key_9"),    # Jump to last tab
    # Enable Cmd+Shift+Braces for tab navigation
    K("RC-Shift-Left_Brace"):   K("C-Page_Up"),     # Go to prior tab
    K("RC-Shift-Right_Brace"):  K("C-Page_Down"),   # Go to next tab
    # Enable Cmd+Option+Left/Right for tab navigation
    K("RC-M-Left"):             K("C-Page_Up"),     # Go to prior tab
    K("RC-M-Right"):            K("C-Page_Down"),   # Go to next tab
    # Enable Ctrl+PgUp/PgDn for tab navigation
    K("Super-Page_Up"):         K("C-Page_Up"),     # Go to prior tab
    K("Super-Page_Down"):       K("C-Page_Down"),   # Go to next tab
    # Use Cmd+Braces keys for tab navigation instead of page navigation
}, "General Web Browsers")

# Keybindings for terminals
define_keymap(re.compile(regex_str(TERMINALS), re.IGNORECASE),{
    K("LC-RC-f"): K("Alt-F10"),                       # Toggle window maximized state
    # Ctrl Tab - In App Tab Switching
    K("LC-Tab") : K("LC-PAGE_DOWN"),
    K("LC-Shift-Tab") : K("LC-PAGE_UP"),
    K("LC-Grave") : K("LC-PAGE_UP"),
    # Converts Cmd to use Ctrl-Shift
    K("RC-MINUS"): K("C-Shift-MINUS"),
    K("RC-EQUAL"): K("C-Shift-EQUAL"),
    K("RC-BACKSPACE"): K("C-Shift-BACKSPACE"),
    K("RC-W"): K("C-Shift-W"),
    K("RC-E"): K("C-Shift-E"),
    K("RC-R"): K("C-Shift-R"),
    K("RC-T"): K("C-Shift-t"),
    K("RC-Y"): K("C-Shift-Y"),
    K("RC-U"): K("C-Shift-U"),
    K("RC-I"): K("C-Shift-I"),
    K("RC-O"): K("C-Shift-O"),
    K("RC-P"): K("C-Shift-P"),
    K("RC-LEFT_BRACE"): K("C-Shift-LEFT_BRACE"),
    K("RC-RIGHT_BRACE"): K("C-Shift-RIGHT_BRACE"),
    K("RC-Shift-Left_Brace"):   K("C-Page_Up"),     # Go to prior tab (Left)
    K("RC-Shift-Right_Brace"):  K("C-Page_Down"),   # Go to next tab (Right)
    K("RC-A"): K("C-Shift-A"),
    K("RC-S"): K("C-Shift-S"),
    K("RC-D"): K("C-Shift-D"),
    K("RC-F"): K("C-Shift-F"),
    K("RC-G"): K("C-Shift-G"),
    K("RC-H"): K("C-Shift-H"),
    K("RC-J"): K("C-Shift-J"),
    K("RC-K"): K("C-Shift-K"),
    K("RC-L"): K("C-Shift-L"),
    K("RC-SEMICOLON"): K("C-Shift-SEMICOLON"),
    K("RC-APOSTROPHE"): K("C-Shift-APOSTROPHE"),
    K("RC-GRAVE"): K("C-Shift-GRAVE"),
    K("RC-Z"): K("C-Shift-Z"),
    K("RC-X"): K("C-Shift-X"),
    K("RC-C"): K("C-Shift-C"),
    K("RC-V"): K("C-Shift-V"),
    K("RC-B"): K("C-Shift-B"),
    K("RC-N"): K("C-Shift-N"),
    K("RC-M"): K("C-Shift-M"),
    K("RC-COMMA"): K("C-Shift-COMMA"),
    K("RC-Dot"): K("LC-c"),
    K("RC-SLASH"): K("C-Shift-SLASH"),
    K("RC-KPASTERISK"): K("C-Shift-KPASTERISK"),

    ### Special overrides
    K("Alt-Backspace"): K("Alt-Shift-Backspace"), # Wordwise delete word left of cursor in terminals
    K("Alt-Delete"): [K("Esc"),K("d")],      # Wordwise delete word right of cursor in terminals
    K("RC-Backspace"): K("C-u"),               # Wordwise delete line left of cursor in terminals
    K("RC-Delete"): K("C-k"),               # Wordwise delete line right of cursor in terminals
    ### Tab navigation
    K("RC-Shift-Left"):         K("C-Page_Up"),         # Tab nav: Go to prior tab (Left)
    K("RC-Shift-Right"):        K("C-Page_Down"),       # Tab nav: Go to next tab (Right)
}, "terminals")
