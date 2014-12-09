class Rsvp < ActiveRecord::Base

  belongs_to :users
  belongs_to :meetups

  validates :user_id,
  presence: true

  validates :meetup_id,
  presence: true

end
