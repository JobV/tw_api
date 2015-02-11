module ApnsHelper

  def send_meetup_notification_to(user)
    pusher = Grocer.pusher(
      certificate: "config/ck.pem",
      passphrase:  "pushmeetup",
      gateway:     "gateway.sandbox.push.apple.com"
    )

    notification = Grocer::Notification.new(
      device_token:      "0fe216f7debd370fef94b032378d0ee938259fb154df1786bfcc7bdd8ca4b079",
      alert:             "#{user.first_name} wants to meet!",
      badge:             1,
      expiry:            Time.now + 60*60    # optional; 0 is default, meaning the message is not stored
    )

    pusher.push(notification)
  end
end
