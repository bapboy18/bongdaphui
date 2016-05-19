class User < ActiveRecord::Base
  ratyrate_rater
  attr_accessor :remember_token
  has_many :pitch, dependent: :destroy
  has_many :team, dependent: :destroy
  has_many :groups, through: :user_groups
  has_many :user_groups, dependent: :destroy
  has_one :admin_group, foreign_key: "admin_id"
  has_many :statuses, dependent: :destroy
  has_many :comments
  has_many :microposts, dependent: :destroy
  has_many :orders

  before_save   :downcase_email
  mount_uploader :picture, PictureUploader
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true , length: { maximum: 255 },
                           format: { with: VALID_EMAIL_REGEX },
                           uniqueness: { case_sensitive: false }
  has_secure_password
  validates :phone, length: { minimum: 9, maximum: 12}, numericality: true
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validate  :picture_size

  enum role: [:normal, :admin,:manage_team,:manage_pitch]
 # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

   # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end



 private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

  # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end

