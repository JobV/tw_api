module ApnsHelper

  def pusher
    pusher = Grocer.pusher(
      certificate: "config/ck.pem",
      passphrase:  "pushmeetup",
      gateway:     "gateway.sandbox.push.apple.com"
    )
  end

  def generate_notification_for device, user, message
    Grocer::Notification.new(
      device_token:      device.token,
      alert:             message,
      badge:             1,
      expiry:            Time.now + 60*60    # optional; 0 is default, meaning the message is not stored
    )
  end

  def send_meetup_notification_to user
    device = user.devices.last
    message = "#{user.first_name} wants to meet!"
    notification = generate_notification_for device, user, message
    pusher.push(notification)
  end
end
