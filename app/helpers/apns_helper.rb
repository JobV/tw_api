module ApnsHelper
  def pusher
    Grocer.pusher(
      certificate: "config/ck.pem",
      passphrase:  "pushmeetup",
      gateway:     "gateway.sandbox.push.apple.com"
    )
  end
  # Identifier Codes
  # 1 - received meetup
  # 2 - meetup accepted
  # 3 - meetup declined
  def generate_notification_for(device, message, friend_id, identifier)
    Grocer::Notification.new(
      device_token:      device.token,
      alert:             message,
      badge:             1,
      category:          "meetup",
      identifier:        identifier,
      custom:            { "friend_id" => friend_id },
      expiry:            1.hour    # optional; 0 is default, meaning the message is not stored
    )
  end

  def push_accepted_notification(device)
    message = "#{device.user.first_name} accepted the notification!"
    notification = generate_notification_for device, message, user.id, 2
    pusher.push(notification)
  end

  def push_request_notification(device)
    message = "#{device.user.first_name} wants to meet!"
    notification = generate_notification_for device, message, user.id, 1
    pusher.push(notification)
  end

  def send_meetup_notification_to(user)
    device = user.devices.last
    push_request_notification(device) if device
  end

  def send_acceptance_notification_to(user)
    device = user.devices.last
    push_accepted_notification(device) if device
  end
  
end
