Red ["Analyses words from red What command,etc, and those in rbe"]
;-- I have tried to get every Red word, to then compare against rbe
print "Analyses words in RBE and Red 'what' help"
print "needs gensite.txt in same folder"
print "Output files:"
print "    words-what-result.txt       words-rbe-result.txt"
print "    words-what-rbe-diff.txt     words-in-dialects.txt"

;-- output files:
what-file: %words-what-result.txt
rbe-file: %words-rbe-result.txt
diff-file: %words-what-rbe-diff.txt
dialect-file: %words-in-dialects.txt

;-- needs the rbe    gensite.txt file in same folder
dialects: "0123456789"

;-------------------get all constants------------------------------------------
; do:  ? logic!   ? char!  help float!  at console to get eg space off  pi
;--  and manually update  logic-vals  etc, if needed.
logic-vals: [on off no true yes false rebol]
char-vals: [null newline slash dbl-quote space lf tab CR dot escape comma sp]
float-vals: [pi]
constants: copy logic-vals
append constants append char-vals float-vals

;-------------------get all types ----------------------------------------------
types: [any-type! any-list! all-word! any-block! any-function!
	any-object! any-path! any-string! any-word! default! external!
	immediate! internal! scalar! series! number!
] ;-- manually, from red official docs on   -datatypes  typesets  typeset 

the-types: copy [] ;-- get the contents of the high-level types
foreach ty types [
	r: reduce ty
	append the-types to block! r ; todo shorten
]
the-types: unique the-types
append the-types types ;-- the high-level names themselves

;----------------- get 'what' info -------------------------------------------
what-out: what/buffer
word-names: constants
append word-names the-types

foreach line split what-out newline [
	;--get first item from each line (nb line starts with spaces)
	items: split (trim line) " "
	append word-names items/1
]
print ["******   The what command word count: " (length? word-names) - 1]
; print mold word-names
write/lines what-file word-names
;-- the file has strings and blocks, easier to sort by reading back in
word-names: sort read/lines what-file
write/lines what-file word-names

;--------------------RBE stuff ------------------------------------------------
dialect-name: function [di-code [char!]] [;--convert dialect RBE digit to description
	xcode: first next find global/xdialects di-code
	first next find global/xcats xcode
]
;---------------------------------------

do load %gensite.txt
;get words from RBE file - string-string-block triplets, ;leading digit shows its dialect
;make a block of RBE words, omitting any leading-digit dialect codes - e.g  3button
rbe-words: copy []
dialect-words: copy []
do load %gensite.txt

xw: copy global/xwords
forall xw [;-- get every 3rd one   - nb goes 1 too far

	either none = find dialects first first xw [
		append rbe-words first xw    
	] [
		;-- dialect word -also to another file (e.g 2button), and also remove dig, for rbe
        descrip: copy ""
        append rbe-words remove copy first xw     ;???????? bug 
        
		append descrip first xw       ;-- todo neaten
		append descrip "     -     "
		append descrip dialect-name to char! first first xw
		append dialect-words descrip
	]
	xw: next next xw
]

print ["*******   The RBE system word count " length? rbe-words]
write rbe-file "^/"
write/lines rbe-file rbe-words
print ["******    The RBE system dialect word count: " length? dialect-words]
write dialect-file ""
write/lines dialect-file sort dialect-words

diffs: difference rbe-words word-names
print ["******* The difference word count:   " length? diffs]
write diff-file ""
foreach d diffs [
	;analyse the difference
	either (find rbe-words d) = none [
		write/append diff-file "RBE - not in:      "
		write/append diff-file to string! d
	] [
		write/append diff-file "WHAT - not in:      "
		write/append diff-file to string! d
	]
	write/append diff-file "^/"
]
print "Done."
