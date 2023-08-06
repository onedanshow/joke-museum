class Page < ApplicationRecord
  has_many :page_jokes, -> { where(duplicate: false) }, dependent: :destroy
  has_many :jokes, through: :page_jokes

  validates :keywords, uniqueness: true, presence: true

  before_create :set_handle

  def jokes_including_duplicates
    page_jokes.unscope(where: :duplicate).joins(:joke).select('jokes.*')
  end

  private

  def set_handle
    self.handle = Page.generate_handle(keywords)
  end

  def self.generate_handle(keywords)
    "#{keywords.parameterize}-jokes"
  end
end
