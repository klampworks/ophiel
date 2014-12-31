
;; Return the first.lastname part of a string or nothing.
;; i.e. "john.smith1992@yahoo.com" -> "john.smith"
(define (extract-first.last str)
  (let ((match (rxmatch #/([a-z]{3,}\.[a-z]{3,})/i str)))
    (cond
      (match (match 1)))))

;; Match words with at least one vowel in.
(define (valid-name? str)
  (rxmatch #/[aeiou]/i str))

(define (split-and pred? str)
  (let ((split (string-split str ".")))
    (and (pred? (car split))
	 (pred? (cadr split)))))

;; Returns true if given word appears in standard wordlist.
;; TODO Linear search.
(define (known-word? str)
  (bin-search-file str "/usr/share/dict/words"))
#|
  (call-with-input-file 
    "/usr/share/dict/words" 
    (λ (ip)
       (port-fold 
	 (λ (a b) 
	    (or b (string=? str a))) #f (λ () (read-line ip))))))
|#

;; Given a "first.lastname" pair, return true if either name 
;; appears in a standard word list.
(define (split-known-word? str)
  (let ((split (string-split str ".")))
    (or (known-word? (car split))
	(known-word? (cadr split)))))

;; Given a list of names, return a new list based on the output of
;; extract-first.last.
(define (filter-first.last lst)
  (fold (λ (str acc) 
	   (let ((res (extract-first.last str))) 
	     (if (not (undefined? res))
	       (cons res acc)
	       acc)))
	'() lst))

(define (filter-known-words lst)
  (filter (λ (word) (not (split-known-word? word))) lst))

(define (filter-valid-names lst)
  (filter (cut split-and valid-name? <>) lst))
