Red ["Does checks on all .txt word files"]
print "Does first line = .dcs  ? - report if not"  ;document start
print "Results to file:    no-dcs-line-1.txt"
print "Run it from   words   dir"
out-file: %no-dcs-line-1.txt
this-dir: get-current-dir
file-list: read to file! this-dir
write/lines out-file "" ;--overwrite

foreach a-file file-list [
	if (find a-file ".txt") <> none [;--improve todo
		lines: read/lines a-file
		if lines/1 <> ".dcs" [
			print [a-file "   - no dcs"]
			write/append/lines out-file to string! a-file
		]
	]
]

