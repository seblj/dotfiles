on run {input, parameters}
    tell application "iTerm"
        create window with default profile
        tell front window
            tell current session
                set parentPath to do shell script "dirname " & quoted form of POSIX path of input
                write text ("cd " & quote & parentPath & quote & "; " & "nvim " & quote & POSIX path of input & quote & "; clear")
            end tell
        end tell
    end tell
end run
