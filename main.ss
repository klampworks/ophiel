(use srfi-37)
(define λ lambda)
(include "generator.ss")

(define (usage script-name)
  (display #"Usage: ~|script-name| -g -i <input-file>\n")
  (display "-g\t--gen\tGenerate a name list from input file.\n")
  (display "-n\t--name\tPick a name at random from input file.\n")
  (display "-f\t--fname\tPick a first name at random from input file.\n")
  (display "-f\t--lname\tPick a last name at random from input file.\n")
  (display "-i\t--input\tInput file.\n"))

(define options
 (list (option '(#\i "input") #t #f
               (λ (option arg-name arg gen name fname lname input-file)
                 (values gen name fname lname arg)))
       (option '(#\l "lname") #f #f
               (λ (option arg-name arg gen name fname lname input-file)
                 (values gen name fname #t input-file)))
       (option '(#\f "fname") #f #f
               (λ (option arg-name arg gen name fname lname input-file)
                 (values gen name #t lname input-file)))
       (option '(#\n "name") #f #f
               (λ (option arg-name arg gen name fname lname input-file)
                 (values gen #t fname lname input-file)))
       (option '(#\g "gen") #f #f
	       (λ (option arg-name arg gen name fname lname input-file)
		  (values #t name fname lname input-file)))))

(define (main args)
  (receive (gen name fname lname input-file)
    (args-fold (cdr args)
               options
               (λ (option name arg . seeds)
                 (display #"Unrecognised option: ~|name|\n")
		 (usage (car args)))
               (λ (operand gen name fname lname input-file)
                 (display #"Ignoring operand ~|operand|.\n")
		 (values gen name fname lname input-file))
	       #f
	       #f
	       #f
	       #f
               ""
	       )
    (cond
      (gen (gen-name-list-stdout input-file))
      (name (display (pick-name input-file)) (newline))
      (fname (display (pick-fname input-file)) (newline))
      (lname (display (pick-lname input-file)) (newline))
      (else (display "No action specified.\n") (usage (car args))))
     0))
