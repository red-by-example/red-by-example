Red ["search words folder for non-RBE words  - mike parr"]
print "looks through every word doc file, reports ones not in rbe index"
print "run me from dir above the words dir.  It also needs gensite.txt"
print "Output to:   rbeindex-versus-folder-diffs.txt"
print ""
out-file: %rbeindex-versus-folder-diffs.txt

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

;get the index from gensite.txt

do load %gensite.txt
xw: copy global/xwords
xcats: copy global/xcats
rbe-file-words: copy []
;make into legal file names
xw: copy global/xwords
forall xw [;-- get every 3rd one   - nb goes 1 too far
	append rbe-file-words append legal-file first xw ".txt"
	xw: next next xw
]

;print legal-files

;get actual file names
dir-files: read %words/
change-dir %words/
actual-files: copy []
foreach file dir-files [
	append actual-files to string! file
]

;print actual-files
change-dir %../
print ["*******   The RBE index word count " length? rbe-file-words]

print ["******    The words folder file count:   " length? actual-files]
print "Differences:"
diffs: difference rbe-file-words actual-files
write out-file "Difference between RBE index, and actual Words folder^/"
foreach d diffs [
    write/append out-file  to string! d
    write/append out-file "^/"
]
print "Done"
