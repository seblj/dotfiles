on run {input, parameters}
    if application "Terminal" is running then
        tell application "Terminal"
            set thePath to POSIX path of input
            set parentPath to do shell script "dirname " & quoted form of thePath
            do script "cd " & quote & parentPath & quote & "; "
                & "vim " & quote & POSIX path of input & quote
                & "; " & "clear"
            activate
        end tell
    else
        tell application "Terminal"
            set thePath to POSIX path of input
            set parentPath to do shell script "dirname " & quoted form of thePath
            do script "cd " & quote & parentPath & quote & "; "
                & "vim " & quote & POSIX path of input & quote
                & "; " & "clear" in window 1
            activate
        end tell
    end if
    return input
end run
