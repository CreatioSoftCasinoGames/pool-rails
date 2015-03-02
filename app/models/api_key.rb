class ApiKey < ActiveRecord::Base

	before_create :generate_access_token
  
	private
  
  def generate_access_token
  	ApiKey.update_all(active: false)
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
  end

end
