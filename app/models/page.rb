class Page < ApplicationRecord
  has_and_belongs_to_many :jokes

  validates :keywords, uniqueness: true, presence: true

  before_create :set_handle

  private

  def set_handle
    self.handle = Page.generate_handle(keywords)
  end

  def self.generate_handle(keywords)
    "#{keywords.parameterize}-jokes"
  end
end
