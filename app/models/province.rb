class Province < ApplicationRecord
  has_many :airports, dependent: :destroy

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
end
