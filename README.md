ophiel
======

Fake personal info generator

Supports generating
* List of First name and Last name pairs taken from a given email address + password dump file
* Date of Birth within a given age range
* Email address using a given domain
* First line address (House number and street name)
* UK County
* UK Post code (random but conforms to conventional format)
* Matching UK County and Post Code pair
* Default looking Windows or OSX

Example

    $ ./ophiel -nsa -d --hostname=osx --email=hmail.com -i out.txt 
    alan.johnson
    1969.10.18
    tapirpulmoga8865@hmail.com
    61 beggarliness close
    Plymouth
    PL2 3YN
    Alan-Johnsons-Macbook-Pro

Developed and tested with [Gauche](http://practical-scheme.net/gauche/) but should work with any Scheme implementation.

Date of Birth
==

Output is YYYY.MM.DD.

The default range is 21-50 if one is not supplied. 

    $ ./ophiel -d
    1992.8.5

    $ ./ophiel --dob="70-71"
    1945.11.5

Email Address
==

Email addresses are generated from the [Unix words file](http://en.wikipedia.org/wiki/Words_%28Unix%29) with the addition of random numbers to avoid possible duplicates. Additionally, addresses may be composed of multiple words if too short or truncated if too long. The default domain is "puppies.com" if one is not supplied.

    $ ./ophiel -e
    witchmanstra069c@puppies.com

    $ ./ophiel --email="kittens.co.uk"
    Nazaritism8b3b@kittens.co.uk

Physical Address
===

Street names are generated from the [Unix words file](http://en.wikipedia.org/wiki/Words_%28Unix%29).

    $ ./ophiel -s
    21 mucofibrous close

Counties are selected from a hardcoded list since there aren't so many.

    $ ./ophiel -c
    Warwickshire

The first post code option generates nonsense post codes which conform to the formatting convention. 

    $ ./ophiel -p
    UG1 9VW

More convincing addresses with matching counties and post codes can also be generated. This uses a hard coded County to Post code mapping.

    $ ./ophiel -a
    South West London
    SW8 0HM

Names
===

The following options require an input file of names.

For example:

    jeremy.usborne
    alan.johnson
    gerrard.matthew

Such a file can be generated from a email + password dumps which are unfortunately quite commonplace these days. Anything that looks like a firstname.lastname combination is parsed out. Several filters are used to avoid strings that are obviously not names for example dictionary words or words without vowels.

    $ cat in.txt
    mark.corrigan@puppies.com
    jeremy.usborne123@puppies.com
    123alan.johnson@puppies.com
    123gerrard.matthew123@puppies.com
    super.hans@puppies.com
    big.suze@puppies.com
    dobby.zzz@puppies.com
    
    $ ./ophiel -g -i in.txt | tee out.txt 
    jeremy.usborne
    alan.johnson
    gerrard.matthew

Mark was rejected because "mark" is also a dictionary word. This is a false positive however under the same rules "Super Hans" and "Big Suse" are also rejected which is correct because they are not real names. Dobby is also rejected because "zzz" is obviously not a valid name (no vowels). Typical database leaks contain millions of email addresses so plenty of valid names can be teased out. Generating this output can take a few seconds to a few minutes depending on the number of records. The largest file I tested was a 2,096,995 line input file which produced a 107,939 line output file in 32 seconds.

With this output we can generate realistic names. Names are selected at random and pulled out from the file using a binary search so even with millions of records the process is still very quick (less than a second).

    $ ./ophiel -n -i out.txt 
    alan.johnson

First names and last names can be generated separately.

    $ ./ophiel -f -i out.txt 
    gerrard

    $ ./ophiel -l -i out.txt 
    johnson

Hostnames can also be generated which look like the default hostnames for Windows or OS X. The default is Windows style.

    $ ./ophiel -h -i out.txt
    Alan-Johnsons-PC

    $ ./ophiel --hostname=osx -i out.txt
    Gerrard-Matthews-Macbook-Pro
