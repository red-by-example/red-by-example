Red [
    Author: " Arie van Wingerden, Mike Parr: minor mods to format, and  .aad  .cmt"
    Version: 5.2
    Description: {Generate the red-by-example website from templates}
    Remark: {All global variables are preceded by letter "x"}
]    ;--   extended version - mike - uses docsring, 2 directives .dcs  .dce  -see in design doc
                                                                      
rejoin: func [
    "Reduces and joins a block of values."
    block [block!] "Values to reduce and join"
][     
    if empty? block: reduce block [return block]
    append either series? first block [copy first block] [
        form first block
    ] next block
]

; Load the global index
do load %/c/red-by-example/gensite.txt
; Setup object with all output blocks and files per page
tmp: copy {xfiles: make object! [} 
foreach page global/xpages [
    print [ "Page: " page]            
    tmp: rejoin [tmp page {: make object! [blk: [] file: %} global/xfilebase
                 {publish/} page ".html" {] } ]
]
tmp: rejoin [tmp {]}]
do tmp

br: global/xbr

; Determine type of a word
wtype: function [ w ] [
    wtmp: remove-dialect w
    either w = wtmp [
        tmp: rejoin [{t: type? :} w]
        do bind load tmp 'w              ;-- t is now (eg)  action
    ] [
        tmp1: select global/xdialects pick w 1
        tmp2: select global/xcats tmp1
        t: rejoin [tmp2]        ;[{"} tmp2 {"}]    ; t now a dialect description.   ;mike why "" bug???
    ]
    return t   
]

mpath: function [a b] [   ;mike bug
  ;  print ["in mpath wth types  a b:     " type? a "="  a type? b "=" b]
     ; print rejoin ["xfiles/" a "/" b]   ; mike dbug
   ;  xx:   rejoin ["xfiles/" a "/" b]   ;mike
   ;   print   xx
   ; return get to path! rejoin ["xfiles/" a "/" b]     ;was
   return get  load rejoin ["xfiles/" a "/" b]
]

; Initialize index data
init: function [ ] [
    ; Sort index by word
    print "about to sort index"
    sort/skip global/xwords 3
    ; Create totals per category
    foreach [tword talias tcats] global/xwords [
        ; Sort categories per word
        sort tcats
        ; Create totals for category
        foreach ccat tcats [
            cpos: find global/xcatwords ccat
            either none? cpos [
                append global/xcatwords ccat
                append global/xcatwords 1
            ] [
                cval: first next cpos
                cval: cval + 1
                change next cpos cval
            ]
        ]
    ]
    ; Sort categories
    sort/skip global/xcats 2
]

; Write output to a large block
; Note: input arg is also a block!
;       per word in that block output must be written
wout: func [ pages arg br ] [
;print ["in wout arg, br: " arg "---" br]
    foreach page pages [
    ;    print ["wout, page, tmp  is " page "-------" tmp]   ;--mike bug
        tmp: rejoin [arg br]
        append mpath page "blk" tmp
    ]
]

to-top: function [ arg ] [
    tmp: rejoin [{<a href="#top">top</a>     }
                 {<a href="#ix-alpha">alphanumeric-index</a>     }
                 {<a href="#ix-cat">category-index</a>}]
    wout arg tmp br
]

; Translate characters that are not accepted by the file system
; to acceptable alphabetic equivalents
proper-name: function [ token ] [
    out: copy ""
    foreach char token [
        case [
            char = #"?" [append out copy "xqm"]
            char = #"=" [append out copy "xeq"]
            char = #"*" [append out copy "xmu"]
            char = #"~" [append out copy "xsn"]
            char = #"<" [append out copy "xlt"]
            char = #">" [append out copy "xgt"]
            char = #"/" [append out copy "xsl"]
            char = #"+" [append out copy "xpl"]
            char = #"!" [append out copy "xex"]
            char = #"%" [append out copy "xpc"]
            true [append out char]
        ]
    ]
    return out
]

remove-dialect: function [ name ] [
    pos1: pick name 1
    dialect: false
    foreach digit "0123456789" [
        if pos1 = digit [
            dialect: true
            break
        ]
    ]
    either dialect = true [
        return copy next name
    ] [
        return name
    ]
]

subst: function [ page dlm line ] [
    if none? (find line dlm) [
        return line
    ]
    result: copy ""
    found: false
    data: copy ""
    numdlm: 0
    forever [
        ; End of line
        if (length? line) = 0 [
            break
        ]
        ; We found a delimiter
        either (copy/part line 2) = dlm [
            numdlm: numdlm + 1
            either found = false [
                found: true    
            ] [
                ; We have consumed the data
                case [
                    dlm = "$$" [
                        result: rejoin [result {<a href="} page {.html#} 
                                proper-name data {">} 
                                remove-dialect data {</a>}]
                    ]
                    dlm = "&&" [
                        result: rejoin [result {<a href="} data {.html}                        
                                {">} data {</a>}]
                    ]
                    dlm = "%%" [
                        result: rejoin [result {<b style="color: green">; }
                                data {</b>}] 
                    ]
                    dlm = "##" [
                        result: rejoin [result {<b style="color: blue">}
                                data {</b>}] 
                    ]
                    dlm = "||" [
                        result: rejoin [result {<img src="} data {" alt="}
                                data {">}]
                    ]                    
                ]
                data: copy ""                    
                found: false
            ]
            line: skip line 2
        ] [
            either found = false [
                append result copy/part line 1
            ] [
                append data copy/part line 1
            ]
            line: skip line 1
        ]
    ]
    if (numdlm // 2) <> 0 [
        print[{Unbalanced delimiter"} dlm {in line "} head line]
    ]
    return result
]

; Substitute markup delimiters with HTML;
;    $$ delimied becomes hyperlink - Red words
;    && delimited becomes a page link
;    ## delimited becomes blue - Red printed output
;    %% delimited becomes green - comments
subst-markup: function [ page line ] [
    result: copy line
    foreach dlm global/xdelimiters [
        result: copy subst page dlm result
    ]
    return result
]



allow-compares-in: function [in-text] [  ;-- mike parr 13 sep 17   ;-- endcodes only > >= etc in Code (spaces surround) as &gt; etc
    r: copy []
    r: copy in-text
    froms: [" > " " < "   " <> "   " >= " " <= " " >> " " << " " >>> "]
    tos:   [" &gt; " " &lt; "   " &lt;&gt; "  " &gt;= " " &lt;= " " &gt;&gt; " " &lt;&lt; " " &gt;&gt;&gt; "]
    
    pos: 1
    while [pos <= length? froms] [
        replace/all r froms/:pos tos/:pos
        pos: pos + 1
    ]
    
  ;  unless r = in-text        ;debug - show changed lines
       ;  [print "Changing" print r print  in-text print " "]
    return r
]


; Write the output (write/lines not yet implemented)
; For every page!
write-output: function [ ] [
    ;print ["mike1 in write-output  " ]
    foreach page global/xpages [
        write mpath page "file" ""
       ; print ["mike3 in w-o, mpath is  " mpath page "file"]
        foreach line mpath page "blk" [
            write/append mpath page "file" allow-compares-in line    ;-- Mike added
           ; write/append mpath page "file" line
        ]
    ]
    print "about to exit write-output"
]

generate-todo: function [ ] [
    write global/xtodofile ""
    foreach todoword global/xtodowords [
        tmp: copy todoword
        append tmp "^(line)"
        write/append global/xtodofile tmp
    ]
]

get-dialect: function [ w ] [
    pos: pick w 1
    foreach digit "0123456789"[
        if pos = digit [
            return digit
        ]
    ]
    return #" "
]

generate-alpha-index: function [ dialect ] [

    ; Count number of words per dialect
    numwords: 0
    foreach [tword talias tcats] global/xwords [
        if dialect = #" " [
            numwords: numwords + 1
            continue
        ]
        if dialect = (pick tword 1) [
            numwords: numwords + 1        
        ]
    ]

    ; Dialect not yet implemented
    if numwords = 0 [
        exit
    ]
    
    ; Write header
    tmp: copy {<h2 id="ix-alpha">}
    either dialect = #" " [
        append tmp copy {Red words in alphanumerical order</h2><pre>}
    ] [
        append tmp select global/xcats (select global/xdialects dialect)
        append tmp copy { words in alphanumerical order</h2><pre>}
    ]        
    wout ["index"] tmp ""
   
    ; Loop thru words
    tcount: 0
    tmp: copy ""
    foreach [tword talias tcats] global/xwords [
        if (get-dialect tword) <> dialect [
            continue
        ]
        pname: proper-name tword
        tcount: tcount + 1
        tword: remove-dialect tword
        tlen: length? tword
        tmp: rejoin [tmp {<a href="#} pname {">} tword {</a>}]
        while [ tlen < global/xwordcol ] [
            append tmp copy " "
            tlen: tlen + 1
        ]
        if tcount // global/xwordcols = 0 [
            if tcount < numwords [
                append tmp copy "<br>"
            ]
            wout ["index"] tmp ""
            tmp: copy ""
        ]
    ]
    if tmp <> "" [
        wout ["index"] tmp ""
    ]
    wout ["index"] copy {</pre>} ""
    to-top ["index"]
]

generate-category-index: function [ ] [
    ; Wite header
    tmp: copy {<h2 id="ix-cat">Master index of categories</h2><pre>}
    wout ["index"] tmp ""
    ; Loop thru categories
    i: 0
    ccats: (length? global/xcats) / 2
    tmp: copy ""
    foreach [ ccat ccatdescr ] global/xcats [
        ; Create link
        tmp: rejoin [tmp {<a href="#cat-} ccat {">} ccatdescr {</a>}]
        ; Pad to max length
        tlen: length? ccatdescr
        while [ tlen < global/xcatcol ] [
            append tmp copy " "
            tlen: tlen + 1
        ]
        ; Columnize
        i: i + 1
        either (i // global/xcatcols) = 0 [
            if i < ccats [
                append tmp copy "<br>"
            ]
            wout ["index"] tmp ""
            tmp: copy ""
        ] [
            if i = ccats [
                wout ["index"] tmp ""
                tmp: copy ""
            ]
        ]
    ]
    wout ["index"] copy {</pre>} ""
    to-top ["index"]
]

generate-category-indices: function [ ] [
    foreach [ ccat ccatdescr ] global/xcats [
        ; Write header for category
        tmp: rejoin [{<h2 id="cat-} ccat {">Category:   } ccatdescr {</h2><pre>}]
        wout ["index"] tmp ""
        ; Loop thru words
        cwords: copy []
        cproper: copy []
        pcount: 0
        cnumwords: select global/xcatwords ccat
        foreach [tword talias tcats] global/xwords [
            if none? (find tcats ccat) [
                continue
            ]
            append cwords tword
            append cproper proper-name tword
        ]
        ; Output this categories' words
        i: 0
        tmp: copy ""
        while [ i < (length? cwords) ] [
            i: i + 1
            tword: remove-dialect pick cwords i
            pname: pick cproper i
            tlen: length? tword
            tmp: rejoin [tmp {<a href="#} pname {">} tword {</a>}]
            while [ tlen < global/xwordcol ] [
                append tmp copy " "
                tlen: tlen + 1
            ]
            either (i // global/xwordcols) = 0 [
                if i < (length? cwords) [
                    append tmp copy "<br>"
                ]
                wout ["index"] tmp ""
                tmp: copy ""
            ] [
                if i = (length? cwords) [
                    wout ["index"] tmp ""
                    tmp: copy ""
                ]
            ]
        ]
        wout ["index"] copy {</pre>} ""
        to-top ["index"]
    ] 
]



 
;put in extra stuff - .pre  .box etc  ok
;put paler blue in css   ok


generate-word-docs: function [ ] [
    foreach [tword talias tcats] global/xwords [
        pname: proper-name tword
        ; Write header                         ;mike bug adding - for space
                                                                 ;if not dialect. need the !, but not id dial
                                     ;maybe convert t to srteing, aappend !, if needed, inside wtype?                            
        tmp: rejoin [{<br><br><span class="mike-large" id="} pname {"> }
             remove-dialect tword {</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;type:&nbsp;&nbsp;}
             wtype tword {!--&nbsp;&nbsp;&nbsp;&nbsp;}]
        wout ["index"] tmp ""
        
        
        ; If an alias exists, point to that word
        if talias <> "" [
            tmp: rejoin [{<pre>This word is a synonym for <a href="#}
                 talias {">} talias {</a></pre>}]
            wout ["index"] tmp ""
            to-top ["index"]
            continue
        ]
        ; Categories
        wout ["index"] copy {Cats: } ""
        tmp: copy ""
        sep: copy ""
        foreach ccat tcats [
            append tmp sep
            sep: copy ", "
            tmp: rejoin [tmp {<a href="#cat-} ccat {">} select global/xcats ccat {</a>}]
        ]
        append tmp copy {<br>}
        wout ["index"] tmp ""
        ; Filename of word data file
        fname: rejoin [global/xfilebase "words/" pname copy ".txt"]
        fname: to-red-file fname                           ;  print ["bugbug " fname]
        ; Check if file does exist
        either not (exists? fname) [
            append global/xtodowords tword
            wout ["index"] copy {<pre>To do by red-by-example team ...</pre>} br
        ] [
            ; Process the word documentation
            wout ["index"] copy {<pre>} ""                
            wdata: read/lines fname         ;  print ["****bug " fname] print ["    " wdata]
            foreach wline wdata [
               ; print ["***bug line " wline]
                prf: copy/part wline 5
                directive: copy/part wline 4   ;mike  eg:    .abc -  not indented
                case [
                    ; Preformatted text
                    wline = ".pre" [        
                        wout ["index"] copy {</pre>Examples<pre>} ""
                    ]
                    
                     ;-- insert "..more to be done        
                     directive = ".aad" [     ;insert "more to do'....???
                        wout ["index"] copy {(Awaiting additional documentation by red-by-example team.)<br>} ""
                    ]
                    
                     ;-- dont show the docstart directive    
                     directive = ".dcs" [     ;insert "more to do'....???
                       ; wout ["index"] copy {(Awaiting additional documentation by red-by-example team.)<br>} ""
                    ]
                    
                     ;-- dont show docend directive  
                     directive = ".dce" [     ;insert "more to do'....???
                       ; wout ["index"] copy {(Awaiting additional documentation by red-by-example team.)<br>} ""
                    ]
                    
                    ; Nice box
                    prf = ".box " [
                       generate-box page copy skip wline 5      
                    ]
                    ; a comment line                      ;mike stuff - .cmt followed by any text
                      prf = ".cmt " [
                       ;do nothing      
                    ]     
                   
                    ; Substitute delimited text with HTML
                    true [
                        tmp: copy ""
                        append tmp subst-markup "index" wline
                        wout ["index"] tmp br
                    ]
                ]
            ]
            ;wout ["index"] copy {</pre>} ""     mike - moved lower
        ]
        wout ["index"] copy {<br>} ""    ;mike added
        to-top ["index"]
        wout ["index"] copy {<br></pre>} ""    ;mike to here
    ]
]

generate-page-links: function [ ] [
    tmp: copy "<pre>"
    foreach page global/xpages [
        tmp: rejoin [tmp {<a href="} page {.html">} page {</a>     }]
    ]
    append tmp copy {</pre>}
    wout global/xpages tmp ""
]

generate-box: function [ page line ] [
    ; First line
    tmp1: copy "%%"
    repeat i 73 [
        append tmp1 #"-" 
    ]
    append tmp1 "%%<br>"
    wout reduce [page] subst-markup "index" tmp1 ""
    ; Second line
    tmp2: copy "%% "
    append tmp2 line
    append tmp2 copy "%%"
    wout reduce [page] subst-markup "index" tmp2 br
    ; Third line
    wout reduce [page] subst-markup "index" tmp1 br
]

strip-markup: function [ line ] [
    foreach delim global/xdelimiters [
       replace/all line delim ""
    ]
    return line
]

gen-hdrs-index: function [ page line id ] [
    tmp: copy ""
    if id = 1 [
        append tmp copy {<pre>}
    ]
    tmp: rejoin [tmp {<a href="#} id {">} strip-markup line {</a>}]
    wout reduce [page] tmp "<br>"
]

gen-hdrs: function [ page id line popen pclose ] [
    tmp: copy ""
    if pclose = 1 [
        append tmp copy {</pre>}
    ]
    tmp: rejoin [tmp {<h2 id="} id {">} subst-markup "index" line {</h2>}]
    if popen = 1 [
        append tmp copy {<pre>}
    ]
    wout reduce [page] tmp ""
]

gen-top: function [ ] [
    tmp: copy {<a href="#top">top</a>}
    wout reduce [page] tmp ""
]

generate-extra-page: function [ page ] [
    ; Skip base page here
    if page = "index" [
        exit
    ]

    ; Generate file name for page
    tmp: rejoin [global/xfilebase {pages/} page {.html}]

    ; Read page contents
    ;print "mike gen:  " print tmp
    pfile: read/lines to-red-file tmp

    ; Preprocess header markup
    numhdrs: 0
    foreach line pfile [
        prf: copy/part line 5
        rest: copy skip line 5
        case [
            prf = ".hdr " [
                numhdrs: numhdrs + 1
                gen-hdrs-index page rest numhdrs
            ]
            prf = ".hop " [
                numhdrs: numhdrs + 1
                gen-hdrs-index page rest numhdrs
            ]
            prf = ".hcl " [
                numhdrs: numhdrs + 1
                gen-hdrs-index page rest numhdrs
            ]
            prf = ".hoc " [
                numhdrs: numhdrs + 1
                gen-hdrs-index page rest numhdrs
            ]
        ]
    ]
    if numhdrs > 0 [
        wout reduce [page] copy {</pre>} ""        
    ]
    ; Write page contents
    numhdrs: 0
    brvalue: copy "<br>"
    foreach line pfile [
        prf: copy/part line 5
        rest: copy skip line 5
        case [
            ; Preformatted text
            line = ".pre" [
                wout reduce [page] copy "</pre><pre>" ""
            ]
            ; Box layout
            prf = ".box " [
                generate-box page rest
            ]
            prf = ".hdr " [
                numhdrs: numhdrs + 1
                gen-hdrs page numhdrs rest 0 0
            ]
            prf = ".hop " [
                numhdrs: numhdrs + 1
                gen-hdrs page numhdrs rest 1 0
            ]
            prf = ".hcl " [
                numhdrs: numhdrs + 1
                gen-hdrs page numhdrs rest 0 1
            ]
            prf = ".hoc " [
                numhdrs: numhdrs + 1
                gen-hdrs page numhdrs rest 1 1
            ]
            line = ".top" [
                gen-top page
            ]
            line = ".bron" [
                brvalue: copy "<br>"
            ]
            line = ".broff" [
                brvalue: copy ""
            ]
            ; Other cases
            true [
                tmp: copy subst-markup "index" line
                wout reduce [page] tmp brvalue
            ]
        ]
    ]
]

generate-extra-pages: function [ ] [
    foreach page global/xpages [
        generate-extra-page page
    ]
]

main: function [ ] [
    ; Generate index.html first
    init
    foreach line global/xinfile [
        prf: copy/part line 5
        case [
            ; Replace .header with page header
            line = ".header" [
                foreach p global/xpages [
                    tmp: rejoin [{<h2>} p {</h2>}]
                    wout reduce [p] tmp ""
                ]
            ]
            ; Replace .date with current date
            line = ".date" [
                wout global/xpages copy to string! now/date ""    
                continue
            ]
            ; Replace .pages with page links
            line = ".pages" [
                generate-page-links
            ]
            ; When .generate found, generate the pages contents
            line = ".index" [
                ; Indices for dialects
                foreach digit "0123456789" [
                    generate-alpha-index digit
                ]
                ; Index for normal Red words
                generate-alpha-index #" "
                generate-category-index
                generate-category-indices
                generate-word-docs
                ; other pages
                generate-extra-pages
            ]
            ; Other lines just copied
            true [
                wout global/xpages line ""
            ]
        ]
    ]
    write-output
    ; Generate extra pages
    generate-extra-pages
    ; Generate to do words file
    generate-todo
    ; Ready
    print "Done!"
]

main
