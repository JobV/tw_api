module ApnsHelper
  def pusher
    Grocer.pusher(
      certificate: "config/ck.pem",
      passphrase:  "pushmeetup",
      gateway:     "gateway.sandbox.push.apple.com"
    )
  end

  def generate_notification_for(device, message)
    Grocer::Notification.new(
      device_token:      device.token,
      alert:             message,
      badge:             1,
      expiry:            Time.now + 60 * 60    # optional; 0 is default, meaning the message is not stored
    )
  end

  def push_notification(device)
    message = "#{user.first_name} wants to meet!"
    notification = generate_notification_for device, message
    pusher.push(notification)
  end

  def send_meetup_notification_to(user)
    device = user.devices.last
    push_notification(device) if device
  end
end
