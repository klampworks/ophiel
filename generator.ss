(use srfi-26)
(use srfi-27)
(use srfi-19)
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
  (random-source-randomize! default-random-source)
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
  (random-source-randomize! default-random-source)
  (let* ((split-range (string-split range #\-))
	(d-min (string->number (car split-range)))
	(d-max (string->number (cadr split-range)))
	(diff (- d-max d-min)))
    (- (date-year (current-date)) (+ d-min (random-integer diff)))))

(define (gen-month)
  (random-source-randomize! default-random-source)
  (+ 1 (random-integer 11)))

(define (gen-day)
  (random-source-randomize! default-random-source)
  (+ 1 (random-integer 28)))

(define (gen-dob range)
  #"~(gen-year range).~(gen-month).~(gen-day)")
