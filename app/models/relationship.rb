class Relationship < ApplicationRecord
  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name
  validates :follower, presence: true
  validates :followed, presence: true
  scope :following_ids, -> user_id do
    where follower_id: user_id
  end
end
