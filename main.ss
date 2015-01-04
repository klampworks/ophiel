(use srfi-37)
(define λ lambda)
(include "generator.ss")
(random-source-randomize! default-random-source)

(define (usage script-name)
  (display #"Usage: ~|script-name| -gnflspc -e <domain.com> -d <21-50> -i <input-file>\n")
  (display "-g\t--gen\tGenerate a name list from input file.\n")
  (display "-n\t--name\tPick a name at random from input file.\n")
  (display "-f\t--fname\tPick a first name at random from input file.\n")
  (display "-l\t--lname\tPick a last name at random from input file.\n")
  (display "-d\t--dob\tGenerate a random date of birth within given range.\n")
  (display "-e\t--email\tGenerate a random email streetess using given domain.\n")
  (display "-s\t--street\tGenerate a random physical streetess.\n")
  (display "-p\t--pcode\tGenerate a random UK post code.\n")
  (display "-c\t--county\tSelect a random UK county.\n")
  (display "-a\t--addr\tSelect a someway coherent UK county and post code combination.\n")
  (display "-i\t--input\tInput file.\n"))

(define options
 (list (option '(#\i "input") #t #f
               (λ (option arg-name arg gen name fname lname dob email street 
			  pcode county addr input-file)
                 (values gen name fname lname dob email street pcode county 
			 addr arg)))
       (option '(#\a "addr") #f #f
               (λ (option arg-name arg gen name fname lname dob email street 
			  pcode county addr input-file)
                 (values gen name fname lname dob email street pcode county 
			 #t input-file)))
       (option '(#\c "county") #f #f
               (λ (option arg-name arg gen name fname lname dob email street 
			  pcode county addr input-file)
                 (values gen name fname lname dob email street pcode #t 
			 addr input-file)))
       (option '(#\p "pcode") #f #f
               (λ (option arg-name arg gen name fname lname dob email street 
			  pcode county addr input-file)
                 (values gen name fname lname dob email street #t county 
			 addr input-file)))
       (option '(#\s "street") #f #f
               (λ (option arg-name arg gen name fname lname dob email street 
			  pcode county addr input-file)
                 (values gen name fname lname dob email #t pcode county 
			 addr input-file)))
       (option '(#\e "email") #f #t
               (λ (option arg-name arg gen name fname lname dob email street 
			  pcode county addr input-file)
		  (if arg
		    (values gen name fname lname dob arg street pcode county 
			    addr input-file)
		    (values gen name fname lname dob "puppies.com" street 
			    pcode county addr input-file))))
       (option '(#\d "dob") #f #t
               (λ (option arg-name arg gen name fname lname dob email street 
			  pcode county addr input-file)
               (cond
		 ((and arg (rxmatch #/^\d+-\d+$/ arg))
		  (values gen name fname lname arg email street pcode county 
			  addr input-file))
		 ((not arg) (values gen name fname lname "21-50" email street 
				    pcode county addr input-file))
		 (else (display "Expected dob range of format /^\d+-\d+$/.\n")
		  (values gen name fname lname "21-50" email street pcode 
			  county addr input-file)))))
       (option '(#\l "lname") #f #f
               (λ (option arg-name arg gen name fname lname dob email street 
			  pcode county addr input-file)
                 (values gen name fname #t dob email street pcode county 
			 addr input-file)))
       (option '(#\f "fname") #f #f
               (λ (option arg-name arg gen name fname lname dob email street 
			  pcode county addr input-file)
                 (values gen name #t lname dob email street pcode county 
			 addr input-file)))
       (option '(#\n "name") #f #f
               (λ (option arg-name arg gen name fname lname dob email street 
			  pcode county addr input-file)
                 (values gen #t fname lname dob email street pcode county 
			 addr input-file)))
       (option '(#\g "gen") #f #f
	       (λ (option arg-name arg gen name fname lname dob email street 
			  pcode county addr input-file)
		  (values #t name fname lname dob email street pcode county 
			  addr input-file)))))

(define (main args)
  (receive (gen name fname lname dob email street pcode county addr input-file)
    (args-fold (cdr args)
               options
               (λ (option name arg . seeds)
                 (display #"Unrecognised option: ~|name|\n")
		 (usage (car args)))
               (λ (operand gen name fname lname dob email street pcode county addr input-file)
                 (display #"Ignoring operand ~|operand|.\n")
		 (values gen name fname lname dob email street pcode county addr input-file))
	       #f #f #f #f #f #f  #f #f #f #f #f
	       )
      (when gen (gen-name-list-stdout input-file))
      (when name (display (pick-name input-file)) (newline))
      (when fname (display (pick-fname input-file)) (newline))
      (when lname (display (pick-lname input-file)) (newline))
      (when dob (display (gen-dob dob)) (newline))
      (when email (display (gen-email email)) (newline))
      (when street (display (gen-street)) (newline))
      (when county (display (pick-county)) (newline))
      (when pcode (display (gen-pcode)) (newline))
      (when addr (display (gen-addr)) (newline))
      (unless (or gen name fname lname dob email street pcode county addr)
	(display "No action specified.\n") (usage (car args)))
     0))
