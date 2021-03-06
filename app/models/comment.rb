class Comment < ActiveRecord::Base
  include PublicActivity::Model
  mount_uploader :picture_comment, PictureUploader
  belongs_to :user
  belongs_to :status

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate  :picture_size

  default_scope -> {order(created_at: :asc)}

  #acts_as_votable

  def name
    content.split(//).first(30).join
  end

  private
  # Validates the size of an uploaded picture.
  def picture_size
    if picture_comment.size > 5.megabytes
      errors.add(:picture_comment, "should be less than 5MB")
    end
  end
end
