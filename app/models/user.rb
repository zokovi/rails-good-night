class User < ApplicationRecord
  has_many :sleeps
  validates :name, presence: true

  has_many :followings, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
  has_many :followers, foreign_key: :following_id, class_name: 'Follow', dependent: :destroy

end