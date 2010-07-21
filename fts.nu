;; SQLite full text search demo
(set filename "fts.sqlite")
(load "NuSQLite")

(if ((NSFileManager defaultManager) fileExistsAtPath:filename)
    (then (set sqlite ((NuSQLite alloc) initWithPath:filename))
          (sqlite open))

    (else (puts "rebuilding database")
          (set sqlite ((NuSQLite alloc) initWithPath:filename))
          (sqlite open)
          
          (set story (NSString stringWithContentsOfFile:"test/29353.txt"))
          (set lines (story lines))
          
          (set paragraphs (array))
          (set section 1)
          (set paragraph 1)
          (set current nil)
          (lines eachWithIndex:
                 (do (line i)
                     (if (and (> i 50)
                              (< i 1063))
                         
                         (if (and (> (line length) 1))
                             (then (if (/\*.+\*.+\*/ findInString:line)
                                       (then (set section (+ section 1))
                                             (set paragraph 1))
                                       (else (if current
                                                 (then (current appendString:" ")
                                                       (current appendString:line))
                                                 (else (set current "")
                                                       (current appendString:line))))))
                             (else
                                  (if current
                                      (paragraphs << (dict section:section
                                                           paragraph:paragraph
                                                           text:current))
                                      (set paragraph (+ paragraph 1))
                                      (set current nil)))))))
          
          (sqlite executeSQL:"CREATE VIRTUAL TABLE paragraphs using FTS3(section, paragraph, text);")
          
          (paragraphs eachWithIndex:
               (do (paragraph i)
                   (sqlite executeSQL:"INSERT INTO paragraphs VALUES($1, $2, $3);"
                           withParameters:(array (paragraph section:) (paragraph paragraph:) (paragraph text:)))))))

(puts "querying database")
(set result (sqlite executeSQL:"SELECT * FROM paragraphs WHERE text MATCH $1;"
                    withParameters:(array "Hendricks")))
(puts (result description))
(puts "ok")

