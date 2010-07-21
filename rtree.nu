;; SQLite rtree search demo
(set filename "rtree.sqlite")
(load "NuSQLite")

(if ((NSFileManager defaultManager) fileExistsAtPath:filename)
    (then (set sqlite ((NuSQLite alloc) initWithPath:filename))
          (sqlite open))
    
    (else (puts "rebuilding database")
          (set sqlite ((NuSQLite alloc) initWithPath:filename))
          (sqlite open)
          
          (sqlite executeSQL:"CREATE VIRTUAL TABLE zipcode_index USING rtree(id, minX, maxX, minY, maxY);")
          
          (set postalcodes ((NSString stringWithContentsOfFile:"test/US/US.txt") lines))
          (postalcodes each:
               (do (postalcode)
                   (set parts (postalcode componentsSeparatedByString:"\t"))
                   (if (> (parts count) 10)
                       (set info (dict code:(parts 1)
                                       latitude:(parts 9)
                                       longitude:(parts 10)))
                       (sqlite executeSQL:"INSERT INTO zipcode_index VALUES($1, $2, $3, $4, $5);"
                               withParameters:(array (info code:)
                                                     (info longitude:) (info longitude:)
                                                     (info latitude:) (info latitude:))))))))

(puts "querying database")

(set latitude 37.3852778)
(set longitude -122.1130556)
(set EPSILON 0.03)

(set result (sqlite executeSQL:"SELECT * FROM zipcode_index WHERE minX >= $1 AND maxX <= $2 AND minY >= $3 AND maxY <= $4"
                    withParameters:(array (- longitude EPSILON)
                                          (+ longitude EPSILON)
                                          (- latitude EPSILON)
                                          (+ latitude EPSILON))))

(puts (result description))

(set best nil)
(set bestd 1e6)

(result each:
        (do (r)
            
            (set d1 (- (r minX:) longitude))
            (set d2 (- (r minY:) latitude))
            (set d (+ (* d1 d1) (* d2 d2)))
            
            (if (< d bestd)
                (set bestd d)
                (set best r))))

(puts (best description))
(puts "ok")