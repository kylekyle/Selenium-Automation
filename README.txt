What is this? 
=============

These are scripts that use Selenium, a web testing framework, to control a browser and automate tedious tasks (like interacting with AMS). 

Follow the instructions in this README to get set up, then head to the examples directory to see what you can do with it. 

Install a Browser
=================

First, install the Chromium 49 from the dependencies folder. We need this old version of Chromium to be compatible with the out-of-date version of SSL that AMS uses. If you don't care about AMS (or other old Army systems), you can use any version of Chrome you like. 

Install your Certificate
========================

If you will be using your CAC card to authenticate, then you'll want to install the registry in the dependencies folder. Edit the key with the issuer for the certificate you'd like to use. You can get the issuer from the ActiveClient agent in your tray. 

Install Ruby
============

These examples are written in Ruby, but Selenium supports pretty much any language that can make HTTP requests. If you would like to run the examples, install Ruby from the dependencies directory. Make sure to install the full development kit when prompted. 