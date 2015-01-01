(use srfi-37)

(define options
 (list (option '(#\I "include") #t #f
               (lambda (option name arg paths files)
                 (values paths files)))))

(define (main args)
  (receive (include-paths files)
    (args-fold (cdr args)
               options
               (lambda (option name arg . seeds)         ; unrecognized
                 (error "Unrecognized option:" name))
               (lambda (operand paths files) ; operand
                 (display #"Ignoring operand ~|operand|.\n")
		 (values paths files))
               '()    ; initial value of include paths
               '()    ; initial value of include paths
               )
     (print "include paths = " (reverse include-paths))
     (print "files = " (reverse files))
     0))

