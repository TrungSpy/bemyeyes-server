BeMyEyes Server
====
###This is the server side of Be My Eyes  
Whenever the iOs app makes a request it calls this API.  

[![Code Climate](https://codeclimate.com/github/bemyeyes/bemyeyes-server/badges/gpa.svg)](https://codeclimate.com/github/bemyeyes/bemyeyes-server)
[![Stories in Ready](https://badge.waffle.io/bemyeyes/bemyeyes-server.svg?label=ready&title=Ready)](http://waffle.io/bemyeyes/bemyeyes-server)

Master [![Build Status](https://semaphoreci.com/api/v1/projects/66ae9467-141b-456a-a160-83bc75f423f6/426858/shields_badge.svg)](https://semaphoreci.com/bme/bemyeyes-server)

Dev [![Build Status](https://semaphoreci.com/api/v1/projects/66ae9467-141b-456a-a160-83bc75f423f6/426839/shields_badge.svg)](https://semaphoreci.com/bme/bemyeyes-server)

##Getting started  
You can either use vagrant to run the site - this is the prefered way  
Or you can run the server locally.  

##Configuration
Copy config.yml to the config folder    
Use the config.temp.yml as a template  
When everything is setup and you are ready to run the site for the first time, you should run the rake taske "create_user_levels".
`rake create_user_levels`

##Use vagrant  
Install VirtualBox  
Install Vagrant  
run `vagrant up` in the root directory  

The setup will take some time, since it sets up the entire server.  

When the server is installed log in 'vagrant ssh'  

Set up a user with the username and password configured in config.yml  
start mongo: `mongo bemyeyes`  

```ruby
db.addUser( { user: "bemyeyes",  
              pwd: "myPassword",  
              roles: [ "readWrite", "dbAdmin" ]
            } )
```

Please note to provison the server we have created a script, which can also be used as a template for a server:  
https://github.com/bemyeyes/railsready/blob/master/railsready.sh  
  
##Start the server locally    
ruby -S rackup -w config.ru

##Authentication
All interactions with the server demands HTTP Basic AUTH - the username password can be found in the config file under the "authentication" section.

##Run tests
  
There is two parts to testing, in the root of the project:  
1. `rspec` will simply run unit tests and tests against the db.  
2. `rspec rest-spec` will run tests against the rest api.  

At the moment the tests are hardcoded to test against localhost:9001 which is the website exposed by the vagrant server.  

##Model
![alt text](http://yuml.me/f0847fc8 "Model")

# Collaboration

[![Throughput Graph](https://graphs.waffle.io/bemyeyes/bemyeyes-server/throughput.svg)](https://waffle.io/bemyeyes/bemyeyes-server/metrics)

We are using [Waffle](https://waffle.io/bemyeyes/bemyeyes-server) to manage Github issues. It has two-way sync by adding and removing tags like:
- Ready – Done discussing, do!
- In progress – Someone is working on this one

You can see priorities on [Waffle](https://waffle.io/bemyeyes/bemyeyes-server) – top = first.
Admins of this repo can make the changes. 
