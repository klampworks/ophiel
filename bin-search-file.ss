(define λ lambda)
(define λ lambda)

(define (cmp-port word iport)
  ;; Throw away first line since we are in the middle of a line.
  (unless (zero? (port-tell iport)) (read-line iport))
  (let ((line (read-line iport)))
    ;;(display word) (display " x ") (display line) (newline)
    ;;(newline)
    (cond
      ((eof-object? line) -2)
      ((string=? word line) 0)
      ;; Match but is proper noun, end search with -3.
      ((string-ci=? word line) -3)
      ((string-ci<? word line) -1)
      ((string-ci>? word line) 1))))

(define (bin-search-iport word iport st en)
  (let ((pos (div (+ st en) 2)))
    ;;(display "Pos: ") (display pos) (newline)
    ;;(display "St ") (display st) (newline)
    ;;(display "En ") (display en) (newline)
      (port-seek iport pos)
      (let ((res (cmp-port word iport)))
        (cond
	  ((zero? res) #t)
	  ((or (= pos st) (= pos en)) #f)
	  ((= -1 res) (bin-search-iport word iport st pos))
	  ((= 1 res) (bin-search-iport word iport pos en))
	  (else #f)))))

(define (bin-search-file word filename)
  (call-with-input-file 
    filename
    (λ (iport)
       (bin-search-iport word iport 0 
			(port-seek iport 0 SEEK_END)))))

(define (bin-search-file-run-test filename)
  (call-with-input-file 
    filename
    (λ (iport)
      (port-fold 
        (λ (word acc)
	   (let ((res (bin-search-file word filename)))
	     (cond 
	       (res 
		(cons (+ 1 (car acc)) (cons (+ 1 (cadr acc)) '() )))
	       (else 
	        (display "Could not find ") (display word) (newline)
		(cons (car acc) (cons (+ 1 (cadr acc)) '()))))))
        '(0 0)
      (λ () (read-line iport))))))

(define (bin-search-file-print-test-result result)
  (display "Found: ") (display (car result)) (newline)
  (display "Not found: ") (display (- (cadr result) (car result))) (newline)
  (display "Total: ") (display (cadr result)) (newline)
  (display "Success: ") (display (* 100 (/. (car result) (cadr result)))) 
    (display "%") (newline))

(define (bin-search-file-test filename)
  (bin-search-file-print-test-result (bin-search-file-run-test filename)))
