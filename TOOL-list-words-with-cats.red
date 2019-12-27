Red [ "lists every word along with full rbe categs" ]
;-- Mike Parr June 2019 - mikeparr@live.com
print "Puts list of words and RBE categs into:   words-RBE-cats.txt"
print "Needs gensite.txt in same folder"

out-file: %words-RBE-cats.txt

do load %gensite.txt
xw: copy global/xwords
xcats: copy global/xcats

write out-file rejoin[now "      "  (length? xw) / 3  "words^/"]


forall xw [          ;-- "name"     alias (often "")    [catsegs list]
    word-name: first xw
    print word-name
    xw: next xw
    word-alias: first  xw
    xw: next xw
    word-cats: first  xw 
    write/append out-file rejoin[pad word-name 12  "- " ]
    foreach cat word-cats[
        write/append out-file rejoin ["      " second find xcats cat]
    ]
    write/append out-file "^/"    
]
print "Done!"
