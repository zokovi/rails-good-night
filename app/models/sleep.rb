class Sleep < ApplicationRecord
  belongs_to :user
  validates :user, :sleep_start_time, presence: true
end
