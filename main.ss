(use srfi-37)
(define λ lambda)

(define options
 (list (option '(#\i "input") #t #f
               (λ (option name arg input-file)
                 (values arg)))))

(define (main args)
  (receive (input-file)
    (args-fold (cdr args)
               options
               (λ (option name arg . seeds)
                 (error "Unrecognised option:" name))
               (λ (operand input-file)
                 (display #"Ignoring operand ~|operand|.\n")
		 (values input-file))
               "")
     (print "input-file = " input-file)
     0))

