-- Latest: https://github.com/zeitlings/alfred-ghostty-script
-- v1.0.0 - 02.01.2025

-- tab : t | window: n | split: d
property open_new : "t"
property reuse_tab : false
property timeout_seconds : 3
property shell_load_delay : 1.0 -- Delay for session to load
property switch_delay : 0.35 -- Delay when switching windows

on isRunning()
	application "Ghostty" is running
end isRunning

on summon()
	tell application "Ghostty" to activate
end summon

on hasWindows()
	if not isRunning() then return false
	tell application "System Events"
		return exists window 1 of process "Ghostty"
	end tell
end hasWindows

on waitForWindow(timeout_s)
	set end_time to (current date) + timeout_s
	repeat until hasWindows() or ((current date) > end_time)
		delay 0.05
	end repeat
	return hasWindows()
end waitForWindow

on handleWindow(just_activated)
	if just_activated then
		return
	end if
	set has_windows to hasWindows()
	set needs_window to not has_windows
	set override_reuse to (reuse_tab and not has_windows)
	tell application "System Events"
		if needs_window or override_reuse then
			keystroke "n" using command down -- New window
			return
		end if
		if not reuse_tab then
			if open_new is "d" and has_windows then
				keystroke "d" using command down -- New split right
			else
				keystroke open_new using command down -- New window or tab
			end if
		end if
	end tell
end handleWindow

on send(a_command, just_activated)
	if not just_activated then
		delay switch_delay
	end if
	
	set had_windows to hasWindows()
	handleWindow(just_activated)

	delay shell_load_delay
	
	if not waitForWindow(1) then
		display dialog "Failed to verify window exists"
		return
	end if

	tell application "System Events"
		repeat with i from 1 to length of a_command
			set char to text i thru i of a_command
			if char is " " then
				key code 49 -- Space bar
			else
				keystroke char
			end if
		end repeat
		keystroke return
	end tell
end send

on alfred_script(query)
	set just_activated to not isRunning()
	summon()
	if just_activated then
		if not waitForWindow(timeout_seconds) then
			display dialog "Failed to create initial window"
			return
		end if
	end if
	send(query, just_activated)
end alfred_script
