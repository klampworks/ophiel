(use srfi-37)
(define λ lambda)
(include "generator.ss")

(define (usage script-name)
  (display #"Usage: ~|script-name| -g -i <input-file>\n")
  (display "-g\t--gen\tGenerate a name list from input file.\n")
  (display "-n\t--name\tPick a name at random from input file.\n")
  (display "-i\t--input\tInput file.\n"))

(define options
 (list (option '(#\i "input") #t #f
               (λ (option name arg gen name input-file)
                 (values gen name arg)))
       (option '(#\n "name") #f #f
               (λ (option name arg gen name input-file)
                 (values gen #t arg)))

       (option '(#\g "gen") #f #f
	       (λ (option name arg gen name input-file)
		  (values #t name arg)))))

(define (main args)
  (receive (gen name input-file)
    (args-fold (cdr args)
               options
               (λ (option name arg . seeds)
                 (display #"Unrecognised option: ~|name|\n")
		 (usage (car args)))
               (λ (operand gen name input-file)
                 (display #"Ignoring operand ~|operand|.\n")
		 (values gen name input-file))
	       #f
	       #f
               ""
	       )
    (cond
      (gen (gen-name-list-stdout input-file))
      (name (display (pick-name input-file)) (newline))
      (else (display "No action specified.\n") (usage (car args))))
     0))
