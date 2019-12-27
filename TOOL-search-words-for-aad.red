Red [ "search words folder  - mike parr" ]
; looks through every word doc, displays every line
; containing  .cmt  at start (starts a comment line)
;             .aad  at start  (replaced by  Awaiting Additional Documentation)
               team   - anywhere in line (Arie's awaiting... text
; run me from dir containing words dir
              


dir-files: read %words/
;print dir-files
 change-dir %words/
foreach file dir-files[

 ; print ["on file:  " file]
  text: read/lines file
  foreach line text [
  
    either   find line ".cmt"
      [print [file " :   " line] ]  [ ] 
        
    either   find line " team"
      [print [file " :   " line] ]  [ ] 
       
    either   find line ".aad"
      [print [file " :   " line] ]  [ ]     
       
  ]
  
]
print "Done"
  