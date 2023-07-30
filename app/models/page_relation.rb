class PageRelation < ApplicationRecord
  belongs_to :page
  belongs_to :related_page, class_name: 'Page'
  
  validates :page_id, uniqueness: { scope: :related_page_id }
  
  after_create :create_reciprocal_relation
  after_destroy :destroy_reciprocal_relation

  private

  def create_reciprocal_relation
    self.class.find_or_create_by(page_id: self.related_page_id, related_page_id: self.page_id) unless self.class.exists?(page_id: self.related_page_id, related_page_id: self.page_id)
  end

  def destroy_reciprocal_relation
    self.class.find_by(page_id: self.related_page_id, related_page_id: self.page_id)&.destroy
  end
end
