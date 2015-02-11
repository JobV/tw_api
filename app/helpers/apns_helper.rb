module ApnsHelper

  def send_notification
    pusher = Grocer.pusher(
      certificate: "config/ck.pem",      # required
      passphrase:  "pushmeetup",                       # optional
      gateway:     "gateway.sandbox.push.apple.com", # optional; See note below.
    )

    feedback = Grocer.feedback(
    certificate: "config/ck.pem",      # required
    passphrase:  "pushmeetup",                       # optional
    gateway:     "feedback.sandbox.push.apple.com", # optional; See note below.
    )


    notification = Grocer::Notification.new(
      device_token:      "0fe216f7debd370fef94b032378d0ee938259fb154df1786bfcc7bdd8ca4b079",
      alert:             "Job wants to meet!",
      expiry:            Time.now + 60*60    # optional; 0 is default, meaning the message is not stored
    )

    pusher.push(notification)

    feedback.each do |attempt|
      puts "Device #{attempt.device_token} failed at #{attempt.timestamp}"
    end

  end
end
