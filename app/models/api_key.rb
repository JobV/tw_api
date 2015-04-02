class ApiKey < ActiveRecord::Base
  before_create :generate_access_token
  before_create :set_expiration
  belongs_to :user

  def expired?
    DateTime.now >= expires_at
  end

  private

  def generate_access_token
    loop do
      self.access_token = SecureRandom.hex
      break unless self.class.exists?(access_token: access_token)
    end
  end

  def set_expiration
    self.expires_at = DateTime.now + 30
  end
end
