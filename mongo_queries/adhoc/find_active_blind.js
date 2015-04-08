var active_blinds = db.requests.aggregate([
  {$group:{_id: "$blind_id", count: {"$sum" : 1}}},
  {$match:{count:{"$gt":100}}}
]);
active_blinds.result.forEach(function(blind){
  print(blind._id);
  blind_record = db.users.find(blind._id)[0];
  if(!blind_record.blocked){
    print(blind.email);
  }
})
