(use srfi-37)
(define λ lambda)
(include "generator.ss")

(define (usage script-name)
  (display #"Usage: ~|script-name| -i <input-file>\n"))

(define options
 (list (option '(#\i "input") #t #f
               (λ (option name arg input-file)
                 (values arg)))))

(define (main args)
  (receive (input-file)
    (args-fold (cdr args)
               options
               (λ (option name arg . seeds)
                 (display #"Unrecognised option: ~|name|\n")
		 (usage (car args)))
               (λ (operand input-file)
                 (display #"Ignoring operand ~|operand|.\n")
		 (values input-file))
               "")
     (gen-name-list-stdout input-file)
     0))
