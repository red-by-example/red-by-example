Red [ "text to files" ]
;-- Mike Parr

print "Requests a file containing text"
print "and a file holding file names (assumed current dir, one per line)."
print "The text is written to every file."
print ""

text-file: to file! ask "Enter the file containing text:  "
new-text: read/lines text-file
file-list-name: to file! ask "Enter the file-list file:  "
file-list: read/lines file-list-name

foreach one-name file-list [
    write/lines to file! one-name new-text
    print [one-name " processed"]
]
print "Done!"
