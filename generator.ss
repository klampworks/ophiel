(import (srfi-26))
(define λ lambda)
(include "filters.ss")

;; Given a non-seekable iport, returns each line 
;; as a list of strings in revese order.
(define (iport->strlist iport)
  (port-fold cons () (cut read-line iport)))

(define (gen-name-list in-file)
  (call-with-input-file in-file 
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
