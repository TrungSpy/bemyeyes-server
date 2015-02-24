db.devices.aggregate([
  { $group: {
    _id: { device_token: "$device_token" },
    uniqueIds: { $addToSet: "$_id" },
    count: { $sum: 1 }
  }},
  { $match: {
    count: { $gt: 1 }
  }}
])
