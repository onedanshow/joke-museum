class Page < ApplicationRecord
  has_and_belongs_to_many :jokes
  has_many :page_relations, dependent: :destroy
  has_many :related_pages, through: :page_relations

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
