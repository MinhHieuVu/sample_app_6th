class Comment < ApplicationRecord
  include ActionView::RecordIdentifier

  acts_as_votable
  belongs_to :user
  belongs_to :micropost
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :comments, foreign_key: "post_parent_id", dependent: :destroy
  has_one_attached :image
  has_many :emotes, dependent: :destroy
  validates :user_id, presence: true
  validates :body, presence: true, allow_blank: false
  validates :image, content_type: { in: %w(image/jpeg image/gif image/png),
                                    message: "must be a valid image format" },
            size: { less_than: 5.megabytes,
                    message: "should be less than 5MB" }
  after_create_commit do
    if parent.present?
      broadcast_append_to [micropost, :comments], target: "#{dom_id(micropost, parent.id)}_comments"
    else
      broadcast_append_to [micropost, :comments], target: "#{dom_id(micropost)}_comments"
    end
  end

  after_destroy_commit do
    broadcast_remove_to self
  end

  after_update_commit do
    broadcast_replace_to self
  end

  def emotes_size(key)
    self.emotes.select { |e| e.emoji == key }.size
  end
end