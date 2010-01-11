on run (argv)
	set filename to item 2 of argv
	set folderPath to item 1 of argv
	set htmlFile to filename & ".html"
	set htmlPath to folderPath & "/" & htmlFile
	set pdfPath to folderPath & "/" & filename & ".pdf"
	set errors to ""
	set nofile to false
	
	(*
	try
		do shell script "rm " & pdfPath
	on error
		set nofile to true
	end try
	*)
	
	tell application "Safari"
		activate
		open location "file://" & htmlPath
	end tell
	set maxloops to 100
	tell application "System Events"
		tell application process "Safari"
			set frontmost to true
			keystroke "p" using command down
			set notFound to true
			set cnt to 0
			repeat while notFound
				if exists sheet 1 of window 1 then
					# Current App uses the Print sheet (not dialog)
					set refSheet to a reference to sheet 1 of window 1
					set notFound to false
				else
					set cnt to cnt + 1
					if cnt > maxloops then
						set errors to errors & ": Error - Sheet 1 not found"
						return errors
					end if
				end if
			end repeat
			click menu button "PDF" of refSheet
			set notFound to true
			set cnt to 0
			repeat while notFound
				if exists menu item "Save as PDFÉ" of menu 1 of menu button "PDF" of refSheet then
					set notFound to false
				else
					set cnt to cnt + 1
					if cnt > maxloops then
						set errors to errors & ": Error - save as menu not found"
						return errors
					end if
				end if
			end repeat
			click menu item "Save as PDFÉ" of menu 1 of menu button "PDF" of refSheet
			keystroke folderPath
			keystroke return
			delay 1
			keystroke filename
			keystroke return
		end tell
	end tell
	
	tell application "Safari"
		activate
		tell application "System Events"
			keystroke "w" using {command down}
		end tell
	end tell
	if errors = "" then
		set errors to "success"
	end if
	return errors
end run
