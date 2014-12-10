class Rsvp < ActiveRecord::Base
  validates_uniqueness_of :meetup_id
  belongs_to :user
  belongs_to :meetup

  validates :user_id,
    presence: true

  validates :meetup_id,
    presence: true

end
