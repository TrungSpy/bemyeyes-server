db.requests.update(
  {
  stopped:false,
  // ms * seconds * minutes *hour
  // 1 hour ago
  created_at:{$lt: new Date(ISODate().getTime() - 1000 * 60 * 60 * 1)}},
  {
    $set: { stopped: true },
  },
  {
    multi:true
  }
)
