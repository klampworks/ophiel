(use srfi-37)
(define λ lambda)
(include "generator.ss")

(define (usage script-name)
  (display #"Usage: ~|script-name| -gnfl -e <domain.com> -d <21-50> -i <input-file>\n")
  (display "-g\t--gen\tGenerate a name list from input file.\n")
  (display "-n\t--name\tPick a name at random from input file.\n")
  (display "-f\t--fname\tPick a first name at random from input file.\n")
  (display "-l\t--lname\tPick a last name at random from input file.\n")
  (display "-d\t--dob\tGenerate a random date of birth within given range.\n")
  (display "-e\t--email\tGenerate a random email address using given domain.\n")
  (display "-i\t--input\tInput file.\n"))

(define options
 (list (option '(#\i "input") #t #f
               (λ (option arg-name arg gen name fname 
			  lname dob email input-file)
                 (values gen name fname lname dob email arg)))
       (option '(#\e "email") #f #t
               (λ (option arg-name arg gen name fname 
			  lname dob email input-file)
		  (if arg
		    (values gen name fname lname dob arg input-file)
		    (values gen name fname lname dob 
			    "puppies.com" input-file))))
       (option '(#\d "dob") #f #t
               (λ (option arg-name arg gen name fname 
			  lname dob email input-file)
               (cond
		 ((and arg (rxmatch #/^\d+-\d+$/ arg))
		  (values gen name fname lname arg email input-file))
		 ((not arg) (values gen name fname 
				    lname "21-50" email input-file))
		 (else (display "Expected dob range of format /^\d+-\d+$/.\n")
		  (values gen name fname lname "21-50" email input-file)))))
       (option '(#\l "lname") #f #f
               (λ (option arg-name arg gen name fname 
			  lname dob email input-file)
                 (values gen name fname #t dob email input-file)))
       (option '(#\f "fname") #f #f
               (λ (option arg-name arg gen name fname 
			  lname dob email input-file)
                 (values gen name #t lname dob email input-file)))
       (option '(#\n "name") #f #f
               (λ (option arg-name arg gen name fname 
			  lname dob email input-file)
                 (values gen #t fname lname dob email input-file)))
       (option '(#\g "gen") #f #f
	       (λ (option arg-name arg gen name fname 
			  lname dob email input-file)
		  (values #t name fname lname dob email input-file)))))

(define (main args)
  (receive (gen name fname lname dob email input-file)
    (args-fold (cdr args)
               options
               (λ (option name arg . seeds)
                 (display #"Unrecognised option: ~|name|\n")
		 (usage (car args)))
               (λ (operand gen name fname lname dob email input-file)
                 (display #"Ignoring operand ~|operand|.\n")
		 (values gen name fname lname dob email input-file))
	       #f
	       #f
	       #f
	       #f
	       #f
	       "" 
               ""
	       )
    (cond
      (gen (gen-name-list-stdout input-file))
      (name (display (pick-name input-file)) (newline))
      (fname (display (pick-fname input-file)) (newline))
      (lname (display (pick-lname input-file)) (newline))
      (dob (display (gen-dob dob)) (newline))
      (email (display (gen-email email)) (newline))
      (else (display dob) (display "No action specified.\n") (usage (car args))))
     0))
