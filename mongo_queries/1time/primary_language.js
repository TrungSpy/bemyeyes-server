db.users.find().forEach(function(user) {
    if(user.languages){
        var first_language = user.languages[0];
        print(first_language);
        db.users.update({_id:user._id},{$set:{first_language:first_language}});
    }
});


db.users.ensureIndex({'first_language' : 1});

