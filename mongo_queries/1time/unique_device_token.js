db.devices.ensureIndex({'device_token' : 1}, {unique : true, dropDups : true, sparse:true})
