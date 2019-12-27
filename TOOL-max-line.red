Red [ "longest line" ]
; displays longest line in html file
; use it to find culprit line if file is too wide.

; Usage: view html file in a browser, select all, paste to an editor (e.g Word)
; save as count.txt , then run me.

file-block: read/lines %count.txt
max-length: -1
place: 1
foreach line file-block [
   if ( length? line ) > max-length [
         max-length: length? line
         max-place: place
   ]
   place: place + 1
]                           
print ["Longest line is " max-length "at line number: " max-place]
print "Look at the line, and determine which word file it is from."
