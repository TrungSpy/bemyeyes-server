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

