(use srfi-37)
(define λ lambda)
(include "generator.ss")

(define (usage script-name)
  (display #"Usage: ~|script-name| -g -i <input-file>\n")
  (display "-g\t--gen\tGenerate a name list from input file.\n")
  (display "-i\t--input\tInput file.\n"))

(define options
 (list (option '(#\i "input") #t #f
               (λ (option name arg gen input-file)
                 (values gen arg)))
       (option '(#\g "gen") #f #f
	       (λ (option name arg gen input-file)
		  (values #t arg)))))

(define (main args)
  (receive (gen input-file)
    (args-fold (cdr args)
               options
               (λ (option name arg . seeds)
                 (display #"Unrecognised option: ~|name|\n")
		 (usage (car args)))
               (λ (operand gen input-file)
                 (display #"Ignoring operand ~|operand|.\n")
		 (values gen input-file))
	       #f
               ""
	       )
    (cond
      (gen (gen-name-list-stdout input-file))
      (else (display "No action specified.\n") (usage (car args))))
     0))
