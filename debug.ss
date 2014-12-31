(define λ lambda)

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
    (cut read-line iport)))
