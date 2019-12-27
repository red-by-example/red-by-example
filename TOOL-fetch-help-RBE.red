Red ["gets help for a word, puts info in named file"]
print "   also  allows word names from a 'batch' file (no blank lines allowed)"
print "Puts help for a word into a file of same name (.txt)"
print "Puts .dcs (doc start), .dce  (doc end) round info,  adds   .aad (awaiting...)"
print "Puts all gensite.txt templates into gensite-txt-entries.txt  " 
print ""              
;-------------------------------------------------
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
;--------------------------------------------------
do-one-help: function [the-word] [
	print ["Doing " the-word]
	word-info: fetch-help (to word! the-word)
	either (find word-info "No matching") <> none [
		print ["Error!  Word: " the-word]
	] [
		legal-word: legal-file copy the-word
		;-- make a file of that name, put help info into it
		out-file: to file! (append copy legal-word ".txt")
		write out-file ".dcs^/"
		write/append out-file word-info
		write/append out-file ".dce^/"
		write/append out-file ".aad^/"
	]
]
;---------------------------------------------------   

the-word: copy ""
gensite-file: %gensite-txt-entries.txt
write gensite-file ""
in-source: ask "want file input of names? (y  or  n) "
either in-source = "y" [
	file-name: ask "Enter file-list name: "
	word-list: read/lines to file! file-name
	foreach one-name word-list [
		do-one-help one-name
		write/lines/append gensite-file rejoin[{"} one-name {"} "      " {""} "       " {["CAT"]}  ]
	]
	print "Done.  Move the files to the RBE  'words'  folder now!"
] [
	the-word: ask "Type the word: "
	do-one-help the-word
	write/lines gensite-file rejoin[{"} the-word {"} "      " {""} "       " {["CAT"]}  ]
	print "Done.  Move the file to the RBE  'words'    folder now!"
]
print "done"
