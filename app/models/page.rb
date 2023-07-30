class Page < ApplicationRecord
  has_and_belongs_to_many :jokes

  validates :keywords, uniqueness: true
end
