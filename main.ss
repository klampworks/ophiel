(use srfi-37)

(define options
 (list (option '(#\d "debug") #f #t
               (lambda (option name arg debug batch paths files)
                 (values (or arg "2") batch paths files)))
       (option '(#\b "batch") #f #f
               (lambda (option name arg debug batch paths files)
                 (values debug #t paths files)))
       (option '(#\I "include") #t #f
               (lambda (option name arg debug batch paths files)
                 (values debug batch (cons arg paths) files)))))

(define (main args)
  (receive (debug-level batch-mode include-paths files)
    (args-fold (cdr args)
               options
               (lambda (option name arg . seeds)         ; unrecognized
                 (error "Unrecognized option:" name))
               (lambda (operand debug batch paths files) ; operand
                 (values debug batch paths (cons operand files)))
               0      ; default value of debug level
               #f     ; default value of batch mode
               '()    ; initial value of include paths
               '()    ; initial value of files
               )
     (print "debug level = " debug-level)
     (print "batch mode = " batch-mode)
     (print "include paths = " (reverse include-paths))
     (print "files = " (reverse files))
     0))

