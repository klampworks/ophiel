(use gauche.process)
(import (srfi-26))
(define λ lambda)
(include "bin-search-file.ss")
(include "filters.ss")

(define (print-output iport)
  (let ((ret (read-line iport)))
    (cond 
      ((not (eof-object? ret))
       (display ret)
       (newline)
       (print-output iport)))))

(define (print-output-2 iport)
  (port-for-each 
    (λ (ret) 
      (display ret)
      (newline))
    (λ () (read-line iport))))

;; Given a non-seekable iport, returns each line 
;; as a list of strings in revese order.
(define (iport->strlist iport)
  (port-fold 
    cons 
    ()
    (λ () (read-line iport))))


#|
(define p (run-process '(ls -l) :output 's))
(define pp (process-output p 's))
|#

;;(print-output-2 pp)
;;(print-output (process-output p 's))
;;(display (read-string pp))

#|
(for-each
  (λ (str) (display str) (newline))
  (iport->strlist pp))
|#

(define in (open-input-file "names.txt"))
(define names (iport->strlist in))


(for-each (λ (s) (display s) (newline)) 
	  (filter-valid-names (filter-known-words (filter-first.last names))))
