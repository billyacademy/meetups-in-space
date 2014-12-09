class Rsvp < ActiveRecord::Base

  validates :user_id,
  presence: true

  validates :meetup_id,
  presence: true

end
