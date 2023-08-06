class PageJoke < ApplicationRecord
  belongs_to :joke
  belongs_to :page

  validates :joke_id, uniqueness: { scope: :page_id, message: "should only have one per page" }

  scope :with_duplicates, -> { unscope(where: :duplicate) }
end
