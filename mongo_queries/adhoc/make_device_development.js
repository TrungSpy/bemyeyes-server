db.devices.update(
   { device_token: "device_token" },
   {
      $set: { development: true },
   }
)


db.users.update(
   { email: "stepen.becket.bbc@gmail.com" },
   {
      $set: { email: "stephen.beckett.bbc@gmail.com" },
   }
)


