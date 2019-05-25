
		Overriding Allegro UNIX Email Program

By default, Allegro uses the UNIX "mail" program to support its email 
facility on UNIX. Typically mail acts a front-end to the sendmail utility. 
If your environment is not set-up to support using the standard email 
facility, the environment variable, cdn_mail_unix, is provided to override 
Allegro's use of the UNIX mail program. This variable should refer to a 
front-end processing script that you will write. This script should convert 
UNIX mail's input requirements to your mail program interface needs before
calling your email program.

On Windows, Allegro uses the MAPI API for email. There is no ability at
the Allegro level to override the mail program.

Allegro will write out a temporary file that is passed as an argument 
to the your processing script. Your program should read the file,
convert the data into a format expected by your program, and then
call your email program.

The format of this input file is shown below. Data format descriptions are:
 - User names are what typed by the user in Allegro. So they can have
   either full Internet names or local names but they are all prefixed
   with "SMTP".
 - Multiple To: and Cc: users are supported, separated by whitespace. 
 - The Cc line is optional.
 - The message file will be deleted when your script exits.

Caveats:
 - Make sure your mail processing script has the execute permission bits set.
 - The cdn_mail_unix env variable value should use the full path
   to your email front-end script to avoid PATH issues.
 - It is recommended that you place the cdn_mail_unix variable in the 
   Allegro env file at your CDS_SITE level.
 - Suggest using Perl to convert the message file to the format your email 
   program requires.
 - Exit your script with 0 if success and 1 if failure.
 - Allegro disables standard output, your script should write any
   errors messages to a file.
 - In this directory, a trivial script is provided that cats the file
   provided by argument 1 to a file cdn_output.txt.
 - You can use Skill's axlEmail API to test your program.


------------------------------------------------------------------------
Mail file format:

To: SMTP:<user1> SMTP:<user2> ...
Cc: SMTP:<user3> SMTP:<user4> ...
Subject: <mail subject line>
<message body, may be multiple lines


Example:
To: SMTP:user1@cadence.com 
Cc: SMTP:user2 SMTP:user3@cadence.com
Subject: hello
This is the body of the message.
And a second line.


