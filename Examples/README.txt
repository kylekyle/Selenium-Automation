These examples have their own dependencies which are specified in a Gemfile. To install the dependencies, run the following commands in a command prompt from the directory with the Gemfile. 

(You can open a command prompt by holding shift and right clicking in the explorer window you want to open the command prompt in). 

$ gem install bundler 
$ bundle install

To run a file in your bundle context, do the following:

$ bundle exec ruby <name-of-file>.rb