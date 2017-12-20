This program will pull grades from a tab-separated file and enters them into the corresponding link in the grade book (graded event title, "Bonus Points", etc.) in AMS. Here's an example of grades.tsv:

Quiz1	Quiz2
10	15
12	13
15	15
...

To run the program:

$ bundle install
$ bundle exec ruby grades.rb grades.csv

The program will open AMS and then ask you to navigate to the Grade Book for the course. Once you're there, the program will continue. 