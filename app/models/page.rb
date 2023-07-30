class Page < ApplicationRecord
  has_and_belongs_to_many :jokes

  validates :keywords, uniqueness: true, presence: true

  after_create :set_handle

  def set_handle
    self.update_column(:handle, "#{self.keywords.parameterize}-jokes")
  end
end
