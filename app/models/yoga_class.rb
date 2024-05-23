class YogaClass < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :global_search,
  against: [:name, :description, :style, :difficulty],
  associated_against: {
    yoga_studio: [:name, :description, :address],
    teacher: [:name, :description]
  },
  using: {
    tsearch: { prefix: true }
  }

  attr_accessor :teacher
  attr_accessor :yoga_studio

  belongs_to :user
  belongs_to :yoga_studio_teacher

  has_one :yoga_studio, through: :yoga_studio_teacher
  has_one :teacher, through: :yoga_studio_teacher
  has_one_attached :photo

has_many :bookings, dependent: :destroy
  validates :style, inclusion: { in: %w[Hatha Vinyasa Ashtanga Iyengar Hot Kundalini Restorative Yin Power Anusara Prenatal Postnatal Jivamukti Other] }
  validates :difficulty, inclusion: { in: ["Beginner", "Intermediate", "Advanced", "All Levels"] }

  # validation ===================================================>
  validates :name, presence: true, length: { minimum: 3 }
  validates :price, presence: true, numericality: true, format: { with: /\A\d+[.,]{0,1}\d*\z/ }, comparison: { greater_than: 0 }
  validates :description, presence: true, length: { in: 20..800 }
  validates :start_time, presence: true
  validates :end_time, presence: true, comparison: { greater_than: :start_time }
  validates :capacity, presence: true, comparison: { greater_than: 0 }, numericality: true

  # validate :photos_type

  # def photos_type
  #   if photo.attached? == false
  #     errors.add(:photo, ": one photo should be attached!")
  #   end
  # end
  # ================================================================
  def duration_in_minutes
    ((end_time - start_time) / 60).to_i
  end
end
