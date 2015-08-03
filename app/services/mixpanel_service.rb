class MixpanelService
  class << self
    def register_login
      properties = { action: "login", controller: "auth" }
      register_event(properties)
    end

    def register_user_creation
      properties = { action: "create_user", controller: "auth" }
      register_event(properties)
    end

    def register_logout
      properties = { action: "logout", controller: "auth" }
      register_event(properties)
    end

    private

    def register_event(properties)
      tracker = Mixpanel::Tracker.new('6ae05520085a72b10108fbae93cad415')
      tracker.track("user", "api", properties)
    end
  end
end
