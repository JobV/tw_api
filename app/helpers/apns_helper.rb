module ApnsHelper
  def pusher
    Grocer.pusher(
      certificate: "config/ck.pem",
      passphrase:  "pushmeetup",
      gateway:     "gateway.sandbox.push.apple.com"
    )
  end

  def generate_notification_for(device, message, friend_id)
    Grocer::Notification.new(
      device_token:      device.token,
      alert:             message,
      badge:             1,
      category:          "meetup",
      identifier:        1,
      custom:            { "friend_id" => friend_id },
      expiry:            1.hour    # optional; 0 is default, meaning the message is not stored
    )
  end

  def push_notification(device)
    message = "#{user.first_name} wants to meet!"
    notification = generate_notification_for device, message, user.id
    pusher.push(notification)
  end

  def send_meetup_notification_to(user)
    device = user.devices.last
    push_notification(device) if device
  end
end
