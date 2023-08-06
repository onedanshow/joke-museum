class Page < ApplicationRecord
  has_many :page_jokes, -> { where(duplicate: false) }, dependent: :destroy
  has_many :jokes, through: :page_jokes

  validates :keywords, uniqueness: true, presence: true

  before_create :set_handle
  after_update :update_shopify_page

  scope :published, -> { where(published: true) }

  def jokes_including_duplicates
    page_jokes.unscope(where: :duplicate).joins(:joke).select('jokes.*')
  end

  private

  def set_handle
    self.handle = Page.generate_handle(keywords)
  end

  def update_shopify_page
    # Call background job
    # ProcessPage.new.call(self)
  end

  def self.generate_handle(keywords)
    "#{keywords.parameterize}-jokes"
  end
end
