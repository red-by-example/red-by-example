
RED BY EXAMPLE  - USER GUIDE 2019
=================================

By Arie van Wingerden and Mike Parr  (mikeparr@live.com) V1.0 December 2019.
This document is both a description of the software, and a user guide.

ABOUT RED BY EXAMPLE
====================

Arie's idea of the RBE website - is to provide additional help about Red words, via examples and descriptions.  

The main page provides a big index containing every Red word, including dialect words.  Clicking on a word takes you to examples.  The main page also has words listed by category (e.g. input/output, maths, series etc).

The gensite(4).red  program builds the index and links it to information and examples about that word.  Thanks to Arie for writing this powerful program.

Gensite.txt contains tables of words and their categories (a word can be in several categories).  A word might be in a dialect, and, within the program  a digit prefix indicates a dialect. (Thus the same word can exist in several dialects, e.g. group, 3group, 4group.  The group word is in the main language, and 2 dialects.)

The /words folder contains one file for each word.  There are rudimentary formatting directives in these files, and links to other word files can easily be expressed.  Note that the text is pre-formatted, so the author needs to do sensible layout, such as newlines, even in plain-english paragraphs.  

There are a number of separate tiny Red programs - 'tools' - which assist the author.  In particular, they attempt to automate the process of checking the RBE index against the words actually contained in the Red system, and indicating words which have no examples yet.  See below.

In addition to the big index of words and examples, there are major separate pages for beginners, about: draw, parse, series, Vid.


===========================================================

USER GUIDE
==========

The original way of using the software by Mike and Arie was via Google drive. A first task was to decide on a list of word categories (new ones can be added).

We split up the words between us, and worked on them separately, with occasional reviews.

Gensite.red is executed, which generates all the pages.  Finally, the contents of /publish -   pages and images - are uploaded manually.

Adding New Words To RBE
-----------------------
Look in gensite.txt - if the word is not there, make an entry.  Look at similar words to see how categories are expressed.  In the table, the full range of characters can be used, e.g. "char?".

Create a txt file of the same name in /words.  There is a set of escapes for certain non-file-name characters - see below.  For example, "xqm" stands for question-mark  "?".  So we use "charxqm.txt" in this case.

Use the 'fetch-help' tool below - this creates a template file for the word, containing the docstring. Not all docstrings are suitable - for example, "String!" does not have a useful docstring for beginners.

(Note - in the early days of RBE, an attempt was made to write something equivalent to the docstring, but easier for beginners.  As Red got bigger, I used the actual docstring, unchanged, in many cases.  The more recent words illustrate this).
 
Write the doc.  Have a look at other text files to get the idea.  Be careful with line lengths - this is not done automatically.  75 max is suggested.  Notepad++ can help - see below.

Run gensite.red.  Have a look at index.html in a browser.  If the formatting is wrong, you are likely to have a long line somewhere - there is a tool to help you find this line.

Upload all the html pages.




How To Add A New Dialect Page
-----------------------------

Note: RBE handles a word that has a different meaning in a dialect.

Perhaps have a look at how Draw is linked in.

Create a new html page, basically empty, just a heading, in /pages.

In gensite.txt, line 10-ish, add the dialect to xpages, before help.   Near line  22, xdialects, add a digit, and invent a new code - e.g #2 "d04".

Add it to xcats list.

in the long word list, enter all its words referred to, preceded by its digit e.g 2box etc.

 
Using  '>' etc in Red code and hyperlinks
----------------------------------------
     
You can use Red code such as:

      sp>sp      sp<=sp          (where sp=space)

So,with embedded Red code such as:
   a < b
RBE will translate it to  
   a &lt; b
whereas stuff like <a href.....
will not be changed.


 

Using notepad++ to alter line lengths (75 chars suggested)
----------------------------------------------------------

To neaten long pages with lots of lines that are a bit too long,  in a big page - eg vid.html, or in  a long word file, we can use notepad++, like this:
    select text (i.e the whole text) then resize the editor window, until the width  looks ok.  Then, use  ctrl-i, which splits lines based on window size.  Save the file.
 
 
 
Red by Example Design Document (Arie, amended by Mike Parr Dec 2016)
====================================================================
The following directory structure is used:
    main-dir/
        design/
            design.txt (this document)
        pages/
            about.html
            contact.html
            ...
        publish
            about.html
            contact.html
            ...
        words/
            a.txt
            b.txt
            c.txt
            ...
            

In main dir also are stored some individual files:
    basehtml.txt   ->   this is the template for the site, page headers etc
    gensite.red    ->   Red script to generate the whole site
    gensite.txt    ->   config file with lots of info
    
Dir "design"        contains this design document.   //moved to readme now

Dir "pages"         contains the source used to generate these pages.

Dir "publish"       contains all generated stuff + images to be uploaded.

Dir "words"         contains all individual word docs.
    

Description of a word/page document:  //probably easier to look at examples
                                      // in practice it is simple.  
    - free text
    - markup:
        - anything between delimiters "$$" 
            becomes a hyperlink
        - anything between delimiteers "%%" 
            becomes green and "; " will be inserted up front; 
            to be used in true documentation;
        - anything between delimiters "##" 
            becomes blue;
            to be used for Red print output.
        - anything between delimiters "||" 
            is an image to be found in the "publish" dir;
            it must be a filename with extension, e.g. "pic.jpg"
        - if .pre is found stand-alone on a line,
            HTML </pre><pre> tags will be generated
        -  .box  generates neat Red comments round a line of code
            
NOTE: when using %% delimiters for a comment line, it is still possible to put things between ## and $$ in between.  That is very easy to add hyperlinks in comments!
      
NOTE: nesting of same type delimiters is NOT supported.
 
Description of basehtml.txt:
    - contains basic HTML and CSS code
    - contains markup strings:
        - applicable for ALL pages
            .box    ->  the data following that markup will be printed
                        in a nice box, followed by a space line
            .date   ->  will be replaced by current date  //nb use Textcrawler 
                         until date! type gets into Red
            .header ->  will be replaced by the red-by-example header
            .pages  ->  will be replaced with the site menu
            .pre    -> will be replaced by </pre><pre>

            .cmt    ->  comment line - all .cmt lines are ignored.
                        Use e.g. for notes to self about a particular word. (by Mike)
            .aad    ->  Produces the text:
                       (Awaiting additional documentation by red-by-example team.)<br> (byMike)
             .dcs and .dce    -> these lines indicate start and end of the docstring section.
            

            
        - applicable for INDEX page only
            .index  ->  will be replaced by all indices + individual word defs
            
Contents of individual pages (apart from INDEX page) in pages dir:
    - contain default, simple HTML documentation
    - may contain markup as described above
    - may contain extra markup:    (for section numbers etc - see in 'draw')
        .hdr    -> generates a <h2> of the text
        .hop    -> as .hdr, but followd by <pre>
        .hcl    -> as .hds but preceded by </pre>
        .hoc    -> as .hdr but preceded by </pre> and followed by <pre>
        .bron   -> following lines will be appended with <br>
        .broff  -> following lines will NOT be appended with <br>
    - a TOC will be generated automatically for the last mentioned group
      of markup tags.
    - note that in the header types (.hdr .hop etc.) it is allowed to
      use other markup tags
    
Where appropriate <br> tags are inserted after lines.

For dialects like VID and Parse there are overlaps, in that the some
dialect words are also a plain Red words. These words have a one digit
prefix as described in gensite.txt.

File name Escapes
-----------------

Special characters that are not allowed in file names are reworded:
    ?   ->  xqm      (e.g. lengthxqm.txt instead of length?.txt)
    =   ->  xeq
    *   ->  xmu
    ~   ->  xsn      (e.g. xorxsn.txt instead of xor~.txt)
    <   ->  xlt
    >   ->  xgt
    /   ->  xsl
    +   ->  xpl
    !   ->  xex
    %   ->  xpc


Mike's Tools  (tiny red programs, to assist the writer).
========================================================

Many of these programs request console input when you run them.  Look at the comments in each program for more info.

TOOL-check-all-word-files.red
     Reports on word text files with do not have a required .dcs (doc start) item as first line.

TOOL-search-words-for-aad.red
    reports on words containing .aad etc (awaiting additional documentation).

TOOL-fetch-help-RBE.red
    fetches Red help (the docstring) for a word, puts it in a file, with appropriate directives  (.dcs .dce etc)
    Also allows for a batch of word names.

TOOL-find-empty-word-files.red
    Looks through every word doc file, reports on short/empty files.

TOOL-find-files-not-in-rbe.red
    Looks through every word doc file, reports ones not in rbe index.  In error, you might have miss-spelled a file name, for example.

TOOL-list-words-with-cats.red
    Lists every word along with full rbe categs, from gensite.txt.  This is a more readable format. 

TOOL-max-line.red
    due to the use of <pre> tags, accidental long lines can screw up the appearance in a browser.  This tool looks through a created html file, and finds the position of the longest line. This makes it easy to find which file it is in.    Instructions are in the red code file.  The index.html file is huge, for example, difficult to scan by eye.

TOOL-RBE-what-extractor.red
    Analyses words from red  'What' command,etc, and those in RBE.  An attempt is made to get a list of every Red word.  This is not just the 'what' output.  It gets constants, types, subtypes etc.  This is used to find words that need to appear in RBE.

TOOL-search-bad-html.red 
    looks through every word doc, displays every line  containing  >    or    <     - they should be escaped.  Run me from dir containing words dir.   Written to test my processing of stuff like  "  a > b".  This should not be needed now.

 
TOOL-text-to-files.red   
    Requests a file containing text, and a file holding file names (assumed current dir, one per line).  The text is written to every file.   Used e.g. to place 'This word is a color.' in a group of files.  Useful when working on a lot of similar words at once..


TOOL-update-spec.red     
    Updates the spec part (only)  of a word file (or a batch of file names.) using the Red 'help' docstring  info.  It leaves any extra stuff - such as examples - untouched.  The spec is between start and end,   .dcs  and  .dce   - useful if the docstring has been updated within Red, and you want this version in RBE.
 

-----------------------end---------------------

 
 




6


