BeMyEyes Server
============
##Getting started
gem install bundler
bundle install

install mongodb

start mongo shell
db.addUser( { user: "bemyeyes",
              pwd: "GuideBlind2012",
              roles: [ "readWrite", "dbAdmin" ]
            } )

##Start the server
Copy config.yml to the config folder    
Use the config.temp.yml as a template    
ruby app.rb