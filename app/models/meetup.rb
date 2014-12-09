class Meetup < ActiveRecord::Base
  has_many :rsvps

  validates :name,
  presence: true

  validates :description,
  presence: true

  validates :location,
  presence: true

end
