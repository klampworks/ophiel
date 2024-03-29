(use srfi-26)
(use srfi-27)
(use srfi-19)
(use rfc.md5)
(use srfi-13)
(define λ lambda)
(include "filters.ss")

;; Given a non-seekable iport, returns each line 
;; as a list of strings in revese order.
(define (iport->strlist iport)
  (port-fold cons () (cut read-line iport)))

(define (gen-name-list in-file)
  (call-with-input-file 
    in-file 
    (λ (in) 
       (filter-valid-names 
	 (filter-known-words 
	   (filter-first.last 
	     (iport->strlist in)))))))

(define (gen-name-list-stdout in-file)
  (for-each
    (λ (str) (display str) (newline))
    (gen-name-list in-file)))

(define (gen-name-list-stdout-test)
  (for-each
    (λ (str) (display str) (newline))
    (gen-name-list "names.txt")))

(define (pick-name in-file)
  (call-with-input-file 
    in-file 
    (λ (in) 
       (let ((end (port-seek in 0 SEEK_END)))
	 (port-seek in (random-integer end))
	 (read-line in)
	 (let ((tmp (read-line in)))
	   (cond
	     ((eof-object? tmp)
	      (port-seek in 0)
	      (read-line))
	     (else tmp)))))))

(define (pick-fname in-file)
  (car (split (pick-name in-file))))

(define (pick-lname in-file)
  (cadr (split (pick-name in-file))))

(define (gen-year range)
  (let* ((split-range (string-split range #\-))
	(d-min (string->number (car split-range)))
	(d-max (string->number (cadr split-range)))
	(diff (- d-max d-min)))
    (- (date-year (current-date)) (+ d-min (random-integer diff)))))

(define (gen-month)
  (+ 1 (random-integer 11)))

(define (gen-day)
  (+ 1 (random-integer 28)))

(define (gen-dob range)
  #"~(gen-year range).~(gen-month).~(gen-day)")

(define (pick-word-stupid l-min l-max)
  (let* ((t (pick-name wordlist))
	 (len (string-length t)))
    (if (or (< len l-min) (> len l-max))
      (gen-email)
      t)))

(define (pick-word-mangled l-min l-max)
  (let* ((t (pick-name wordlist))
	 (len (string-length t)))
    (cond
      ((> len l-max) (substring t 0 l-max))
      ((< len l-min) 
       (string-append t (pick-word-mangled (- l-min len) (- l-max len))))
      (else t))))

(define (gen-number-32)
  (digest-hexify (md5-digest-string (date->string (current-date) "~s"))))

(define (gen-number digits)
  (let* ((t (gen-number-32))
	(len (string-length t)))
    (cond
      ((> len digits) (substring t 0 digits))
      (( < len digits)
       (string-append t (gen-number (- digits len))))
      (else t))))

(define (gen-email domain)
  #"~(pick-word-mangled 10 12)~(gen-number 4)@~|domain|")

(define street-endings
  '("road" "avenue" "close" "gardens" "street"))

(define (pick-list-item lst)
  (list-ref lst (random-integer (length lst))))

(define (pick-street-ending)
  (pick-list-item street-endings))

(define (gen-street)
  #"~(random-integer 100) ~(pick-word-stupid 3 20) ~(pick-street-ending)")

(define (gen-letter)
  (integer->char (+ (char->integer #\A) (random-integer 26))))

;;Basic post code of the format "ab1 2cd"
(define (gen-pcode)
  (string-append #"~(gen-letter)~(gen-letter)~(random-integer 10) "
		 #"~(random-integer 10)~(gen-letter)~(gen-letter)"))

(include "uk-counties.ss")

(define (pick-county)
  (pick-list-item uk-counties))

(define (gen-addr)
  (let ((pc (pick-list-item uk-pc-counties)))
    (string-append #"~(cadr pc)\n~(car pc)~(random-integer 10) "
		   #"~(random-integer 10)~(gen-letter)~(gen-letter)")))

(define (string-sub str old new)
  (string-map (λ (c) (if (char=? c old) new c)) str))

(define (string-capitalise str)
  (letrec ((sc (λ (str flag acc)
		  (if (null? str) 
		    (list->string (reverse acc))
		    (let ((c (car str)))
		      (if flag
		        (if (char-alphabetic? c) 
		      	  (sc (cdr str) #f (cons (char-upcase c) acc))
			  (sc (cdr str) #t (cons c acc)))
		        (if (not (char-alphabetic? c))
			  (sc (cdr str) #t (cons c acc))
			  (sc (cdr str) #f (cons c acc)))))))))
    (sc (string->list str) #t '())))


(define (gen-hostname hostname input-file)
  (let ((username 
	  (string-capitalise (string-sub (pick-name input-file) #\. #\-))))
    (cond
      ((string-ci=? hostname "osx")
       #"~|username|s-Macbook-Pro")
      (else 
	#"~|username|s-PC"))))
