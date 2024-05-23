class Booking < ApplicationRecord
  belongs_to :yoga_class
  belongs_to :user
end
