db.users.aggregate([
  {$match: {role: "helper"}},
  {$project: {date: {day: {$dayOfMonth: '$created_at'}, month: {$month: '$created_at'}, year: {$year: '$created_at'}}}},
  {$group: {_id: '$date', count: {$sum:1}}}
])

