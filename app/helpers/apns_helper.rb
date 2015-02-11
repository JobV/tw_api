module ApnsHelper

  def send_meetup_notification_to user
    pusher = Grocer.pusher(
      certificate: "config/ck.pem",
      passphrase:  "pushmeetup",
      gateway:     "gateway.sandbox.push.apple.com"
    )
    
    device = user.devices.last

    notification = Grocer::Notification.new(
      device_token:      device.token,
      alert:             "#{user.first_name} wants to meet!",
      badge:             1,
      expiry:            Time.now + 60*60    # optional; 0 is default, meaning the message is not stored
    )

    pusher.push(notification)
  end
end
