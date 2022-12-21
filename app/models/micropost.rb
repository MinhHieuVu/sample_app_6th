class Micropost < ApplicationRecord
  CSV_ATTRIBUTES = %w(content created_at).freeze
  acts_as_votable
  has_many :comments, dependent: :destroy
  has_many :emotes, dependent: :destroy
  has_many :likes
  belongs_to       :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w(image/jpeg image/gif image/png),
                                      message: "must be a valid image format" },
                      size: { less_than: 5.megabytes,
                              message:   "should be less than 5MB" }

  # Returns a resized image for display.
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

  def emotes_size key
    self.emotes.count { |e| e.emoji == key }
  end
end
