Red [ "search words folder for >   <   - mike parr" ]
; looks through every word doc, displays every line
; containing 
;   >    or    <          they should be escaped
; run me from dir containing words dir
              


dir-files: read %words/
;print dir-files
 change-dir %words/
foreach file dir-files[

 ; print ["on file:  " file]
  text: read/lines file
  foreach line text [
  
    either   find line " > "
      [print [file " :  has >  :  " line] ]  [ ] 
        
    either   find line " < "
      [print [file " :  has < :  " line] ]  [ ]     
     
      either   find line " >= "
      [print [file " :  has >=  :  " line] ]  [ ] 
        
    either   find line " <= "
      [print [file " :  has <= :  " line] ]  [ ]       
  ]
  
]
print "Done"
  