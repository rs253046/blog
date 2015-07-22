
class User < ActiveRecord::Base
	validates_uniqueness_of :email
	validates_length_of :email, :within => 5..50
	# validates_format_of :email, :with =>  /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i
	validates_confirmation_of :password

	#one-to-one relationship with profiles table
	has_one :profile
	#on_passwe-to-many relationship with articles table
    has_many :articles, -> { order('published_at DESC') }, :dependent => :nullify
    has_many :replies, :through => :articles, :source => :comments
   
      before_save :encrypt_new_password
  def self.authenticate(email, password)
    user = find_by_email(email)
    return user if user && user.authenticated?(password)
  end
  def authenticated?(password)
    self.hashed_password == encrypt(password)
  end

    protected
    def encrypt_new_password
      return if password.blank?
      self.hashed_password = encrypt(password)
    end
    def password_required?
      hashed_password.blank? || password.present?
    end
    def encrypt(string)
      Digest::SHA1.hexdigest(string)
    end

end