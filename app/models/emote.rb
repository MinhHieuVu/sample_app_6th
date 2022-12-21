class Emote < ApplicationRecord
  belongs_to :user
  belongs_to :comment
  belongs_to :micropost, optional: true
end
