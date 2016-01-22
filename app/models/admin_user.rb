class AdminUser < ActiveRecord::Base
	before_save :encrypt_password
	after_save :clear_password
	attr_accessor :password

	def encrypt_password
	  if password.present?
	    self.salt = BCrypt::Engine.generate_salt
	    self.encrypted_password= BCrypt::Engine.hash_secret(password, salt)
	  end
	end

	def clear_password
		self.password = nil
	end

	def self.authenticate(username, password)
	    user = find_by(username: username)
	    if user && user.encrypted_password == BCrypt::Engine.hash_secret(password, user.salt)
	      user
	    else
	      nil
	    end
  	end
end
