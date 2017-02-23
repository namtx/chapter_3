class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size
  scope :get_following_feed, -> (following_ids, user_id) do
    where "#{following_ids.size > 0 ? "user_id IN ("<<following_ids.pluck(:followed_id).join(", ")<<") OR " : ""}user_id = #{user_id}"
  end
  private
  def picture_size
    if picture.size > Settings.picture_upload.maximum_size.megabytes
      errors.add :picture, t("home_page.shouldlessthen5mb")
    end
  end
end
