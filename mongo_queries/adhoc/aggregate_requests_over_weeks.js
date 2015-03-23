var dt = new Date()
dt.setMonth(dt.getMonth()-1)

db.requests.aggregate([
  {$match: {}},
  {$project: {date: {day: {$dayOfMonth: '$created_at'}, month: {$month: '$created_at'}, year: {$year: '$created_at'}}}},
  {$group: {_id: '$date', count: {$sum:1}}}
])

db.requests.aggregate([
  {$match: {helper_id:null, stopped: true}},
  {$project: {date: {day: {$dayOfMonth: '$created_at'}, month: {$month: '$created_at'}, year: {$year: '$created_at'}}}},
  {$group: {_id: '$date', count: {$sum:1}}}
])

db.users.aggregate([
    {$unwind:"$abuse_reports"},
    {$match:{"abuse_reports.created_at":{$gte:dt}}},
  {$project :
    {"day_of_year" :{"$dayOfYear":"$abuse_reports.created_at"},
      "date":
        {"day":
          {"$dayOfMonth": '$created_at'}, "month" : {"$month": '$created_at'}, "year": {"$year": '$created_at'}
      }}},
      {$group : {_id: "$day_of_year", "count": {"$sum" : 1}}},
      {$sort: {"_id":1}},
])
