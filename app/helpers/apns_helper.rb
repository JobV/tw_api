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
  # 4 - meetup terminated
  def generate_notification_for(device, message, friend, identifier)
    Grocer::Notification.new(
      device_token:      device.token,
      alert:             message,
      badge:             1,
      category:          "meetup",
      custom:            custom_hash_for(friend, identifier),
      expiry:            1.hour    # optional; 0 is default, meaning the message is not stored
    )
  end

  def custom_hash_for(friend, identifier)
    {  "friend_id"       => friend.id,
       "first_name"      => friend.first_name,
       "last_name"       => friend.last_name,
       "phone_nr"        => friend.phone_nr,
       "action"          => identifier }
  end

  def push_declined_notification(user, device)
    message = "#{user.first_name} denied to meetup!"
    notification = generate_notification_for device, message, user, 3
    pusher.push(notification)
  end

  def push_termination_notification(user, device)
    message = "#{user.first_name} terminated the meetup!"
    notification = generate_notification_for device, message, user, 4
    pusher.push(notification)
  end

  def push_accepted_notification(user, device)
    message = "#{user.first_name} accepted to meetup!"
    notification = generate_notification_for device, message, user, 2
    pusher.push(notification)
  end

  def push_request_notification(user, device)
    message = "#{user.first_name} wants to meet!"
    notification = generate_notification_for device, message, user, 1
    pusher.push(notification)
  end

  def send_meetup_notification_to(user, sender)
    user.devices.each do |device|
      push_request_notification(sender, device) if device
    end
  end

  def send_acceptance_notification_to(user, sender)
    user.devices.each do |device|
      push_accepted_notification(sender, device) if device
    end
  end

  def send_refusal_notification_to(user, sender)
    user.devices.each do |device|
      push_declined_notification(sender, device) if device
    end
  end

  def send_termination_notification_to(user, sender)
    user.devices.each do |device|
      push_termination_notification(sender, device) if device
    end
  end
end
