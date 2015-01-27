db.users.find({languages:{$in:["es"]}, role: "blind"}).forEach(function(blind){
  if(blind.languages.length > 1){
    return;
  }
  var count = db.requests.count({blind_id:blind._id, helper_id:{$exists:true}})
  if(count > 0){
    print(blind.email);
    db.requests.find({blind_id:blind._id, helper_id:{$exists:true}});

  }
});
