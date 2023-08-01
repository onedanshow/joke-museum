class MatchPages
  attr_reader :page

  def initialize(page)
    @page = page
  end

  def call
    # Find related jokes via pg_search
    related_jokes = Joke.clean.search(@page.keywords)

    # Get unique page IDs associated with these jokes, excluding the current page ID
    related_page_ids = related_jokes.flat_map(&:page_ids).uniq.reject { |id| id == @page.id }

    # Limit the page_ids to the first 50
    related_page_ids = related_page_ids.take(50)
    
    Page.where(id: related_page_ids).pluck(:handle).uniq
  end
end
