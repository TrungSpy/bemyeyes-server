var dt = new Date()
dt.setMonth(dt.getMonth()-1)

db.event_logs.aggregate([
  {$match:{name:"request_answered", created_at:{$gte:dt}}},
  {$unwind:"$event_log_objects"},
  {$match:{"event_log_objects.name":"request_id"}},
  {$project:{ _id:"$event_log_objects", "day_of_year":{"$dayOfYear":"$created_at"},}},
  { $group: {
    _id: { request_id :"$_id.json_serialized", day_of_year:"$day_of_year"},
    count: { $sum: 1 }
  }},
  { $match: {
    count: { $gt: 1 }
  }},
  { $group: {
    _id: { day_of_year:"$_id.day_of_year"},
    request_count: { $sum: 1 }
  }},
  {$sort:{_id:1}}
])


