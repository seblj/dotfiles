---------- DASHBOARD CONFIG ----------

local g = vim.g

g.dashboard_default_executive = 'telescope'
-- g.dashboard_custom_footer = {''}
g.dashboard_custom_section = {
    find_dotfiles = {
        description = {'  Open dotfiles        '},
        command = 'lua require"utils".edit_dotfiles()'
    },
    find_history = {
        description = {'  Recently opened files'},
        command = 'DashboardFindHistory'
    },
    find_word = {
        description = {'  Find word            '},
        command = 'DashboardFindWord'
    },
    last_session = {
        description = {'  New file             '},
        command = 'DashboardNewFile'}
    }

g.dashboard_custom_header = {
    "",
    "",
    "",
    "                    'c.        ",
    "                 ,xNMM.        ",
    "               .OMMMMo         ",
    "               OMMM0,          ",
    "     .;loddo:' loolloddol;.    ",
    "   cKMMMMMMMMMMNWMMMMMMMMMM0:  ",
    " .KMMMMMMMMMMMMMMMMMMMMMMMWd.  ",
    " XMMMMMMMMMMMMMMMMMMMMMMMX.    ",
    ";MMMMMMMMMMMMMMMMMMMMMMMM:     ",
    ":MMMMMMMMMMMMMMMMMMMMMMMM:     ",
    ".MMMMMMMMMMMMMMMMMMMMMMMMX.    ",
    " kMMMMMMMMMMMMMMMMMMMMMMMMWd.  ",
    " .XMMMMMMMMMMMMMMMMMMMMMMMMMMk ",
    "  .XMMMMMMMMMMMMMMMMMMMMMMMMK. ",
    "    kMMMMMMMMMMMMMMMMMMMMMMd   ",
    "     ;KMMMMMMMWXXWMMMMMMMk.    ",
    "       .cooc,.    .,coo:.      ",
    "",
}

