Red ["update spec only, in a rbe word file"]
;; the spec is between start and end,   .dcs  and  .dce

legal-file: function [the-word] [;-- substitute forbidden chars in file name         
	replace/all the-word "!" "xex"
	replace/all the-word "=" "xeq"
	replace/all the-word "*" "xmu"
	replace/all the-word "+" "xpl"
	replace/all the-word "?" "xqm"

	replace/all the-word "~" "xsn"
	replace/all the-word ">" "xgt"
	replace/all the-word "<" "xlt"
	replace/all the-word "%" "xpc"
	replace/all the-word "/" "xsl"
	return the-word
]

;------------------------------------------------
do-one-update: function [the-word] [
	print ["Doing " the-word]
	word-info: fetch-help (to word! the-word)
	if (find word-info "No matching") <> none [
		print ["Error!  Word not found: " the-word]
		quit
	]
	the-word: legal-file the-word
	;-- update file with new docstring, assume file exists  
	in-out-file: to file! (append copy the-word ".txt")
	word-entry: read/lines to file! in-out-file
	if word-entry/1 <> ".dcs" [
		print ["No .dcs at line 1 in " the-word]
		quit
	]

	n: find word-entry ".dce" ;--get examples text after .dce
	examples: next n
	;-- write new version of file
	write in-out-file ".dcs^/"
	write/append in-out-file rejoin ["Updated in RBE: " now/date "^/"]
	write/append in-out-file word-info
	write/append in-out-file ".dce^/"
	foreach eg-line examples [
		write/append/lines in-out-file eg-line
	]
]
;----------------------------------------------

the-word: copy ""
print "Ensure any files to be updated are in this folder."
in-source: ask "Want file input of names? (y  or  n) "
either in-source = "y" [
	file-name: ask "Enter file-list name: "
	word-list: read/lines to file! file-name
	foreach one-name word-list [
		do-one-update one-name
	]
	print "Done.  Move the files to the RBE  'words'  folder now!"
] [
	the-word: ask "Type the word: "
	do-one-help the-word
	print "Done.  Move the file to the RBE  'words'    folder now!"
]
print "done"

