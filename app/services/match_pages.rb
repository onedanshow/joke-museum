class MatchPages
  attr_reader :page

  def initialize(page)
    @page = page
  end

  def call
    # Find related jokes via pg_search
    related_jokes = Joke.search(@page.keywords)

    # Get unique page IDs associated with these jokes, excluding the current page ID
    related_page_ids = related_jokes.flat_map(&:page_ids).uniq.reject { |id| id == @page.id }

    # Limit the page_ids to the first 50
    related_page_ids = related_page_ids.take(50)

    # Find or create related pages and attach them to the current page
    # related_page_ids.each do |related_page_id|
    #   related_page = Page.find_by(id: related_page_id)

    #   page.related_pages << related_page unless page.related_pages.include?(related_page)
    # end
    
    Page.where(id: related_page_ids).pluck(:handle).uniq
  end
end
