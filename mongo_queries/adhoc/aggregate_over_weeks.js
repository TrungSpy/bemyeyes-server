db.users.aggregate([
  {$match: {role: "helper"}},
  {$project: { week: { '$week': '$created_at' }}},
  {$group: {_id: '$week', count: {$sum:1}}}
])
