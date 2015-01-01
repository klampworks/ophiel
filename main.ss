(use srfi-37)

(define options
 (list (option '(#\i "input") #t #f
               (lambda (option name arg in)
                 (values arg)))))

(define (main args)
  (receive (in-)
    (args-fold (cdr args)
               options
               (lambda (option name arg . seeds)         ; unrecognized
                 (error "Unrecognized option:" name))
               (lambda (operand in) ; operand
                 (display #"Ignoring operand ~|operand|.\n")
		 (values in))
               '()    ; initial value of include paths
               )
     (print "input-file = " in-)
     0))

