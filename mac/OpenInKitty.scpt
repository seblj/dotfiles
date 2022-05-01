on is_running(appName)
    tell application "System Events" to (name of processes)
        contains appName
end is_running

on open_file(filepath, filename)
    tell application "System Events"
        keystroke "cd "
        keystroke filepath
        keystroke "; nvim "
        keystroke filename
        keystroke "; clear"
        key code 36
    end tell
end open_file

on run {input, parameters}
    tell application "Finder"
        set filename to name of file input
    end tell
    set parentPath to do shell script "dirname " & quoted form of POSIX path of input

    if not is_running("kitty") then
        tell application "kitty" to activate
    else
        tell application "System Events" to tell process "kitty"
            click menu item "New OS Window" of menu 1 of menu bar item "Shell" of menu bar 1
        end tell
        tell application "kitty" to activate
    end if
    open_file(parentPath, filename)
end run
