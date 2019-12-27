Red [ "search words folder, find short entries  - mike parr" ]
print "looks through every word doc file, reports on short/empty files" 
print "run me from dir above the words dir"

short: 30              
dir-files: read %words/
;
 change-dir %words/
foreach file dir-files[
 ; print ["on file:  " file]
    if (size? file ) < short  [
        print ["Less than " short " chars in file:  " to string! file]
    ]
  
]
print "Done"
  