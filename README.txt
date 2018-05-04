What is this? 
=============

These are scripts that use Selenium, a web testing framework, to control a browser and automate tedious tasks (like interacting with AMS). 

Follow the instructions in this README to get set up, then head to the examples directory to see what you can do with it. 

Install Smart Card Support for Chrome
=====================================

If your Chrome works with your CAC card, great! You can skip this section. If it doesn't then you should install Google's Smart Card Connector for Chrome. The link is in the installation folder. If you get an error saying that you are not allowed to install extensions, then install the registry key to white list the Smart Card Connector. 

Install your Certificate
========================

If you will be using your CAC card to authenticate, then you'll want to install the registry in the installation folder. Edit the key with the issuer for the certificate you'd like to use. You can get the issuer from the ActiveClient agent in your tray. 

Install Ruby
============

These examples are written in Ruby, but Selenium supports pretty much any language that can make HTTP requests. If you would like to run the examples, install Ruby from the installation folder. Make sure to install the full development kit when prompted. 

Running an Example
==================

These examples use bundler to install their Ruby dependencies. To run them, do the following:

$ gem install bundler
$ cd example_directory
$ bundle install
$ bundle exec ruby example_file.rb input1 input2 ...