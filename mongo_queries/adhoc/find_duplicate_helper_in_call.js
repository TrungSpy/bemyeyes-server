var today = new Date();
var tomorrow = new Date(today);
tomorrow.setDate(today.getDate()-1);

db.event_logs.aggregate([
  {$match:
    {
  name:"request_answered",
  created_at:{$gte:tomorrow}, created_at:{$lte:today}}
},
{$unwind:"$event_log_objects"},
{$match:{"event_log_objects.name":"request_id"}},
{$project:{ _id:"$event_log_objects", "hour":{"$hour":"$created_at"},}},
{ $group: {
  _id: { request_id :"$_id.json_serialized", hour:"$hour"},
  count: { $sum: 1 }
}},
{ $match: {
  count: { $gt: 1 }
}},
{ $group: {
  _id: { hour:"$_id.hour"},
  request_count: { $sum: 1 }
}},
{$sort:{_id:1}}
])


