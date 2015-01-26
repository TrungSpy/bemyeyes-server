db.users.count({'abuse_reports.0': {$exists: true}})
