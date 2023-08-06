class ProcessDuplicateJokes
  SIMILARITY_THRESHOLD = 0.75

  def initialize(joke)
    @joke = joke
    @page_service = ProcessPage.new
  end

  def call(threshold: SIMILARITY_THRESHOLD)
    # Iterate over each page that the joke appears on
    @joke.pages.each do |page|
      # Find potential duplicates on the page using the FindDuplicateJokes service class
      duplicate_jokes = FindDuplicateJokes.new(@joke, corpus_joke_ids: page.joke_ids).call(threshold: threshold)
      next if duplicate_jokes.empty?

      # Identify the oldest joke
      oldest_joke = ([@joke] + duplicate_jokes.keys).min_by { |j| j.created_at }

      # Mark all duplicates except for the oldest one
      duplicate_jokes.keys.each do |other_joke|
        next if other_joke == oldest_joke

        # Find the PageJoke record for the duplicate joke and the page
        page_joke = PageJoke.find_by(joke_id: other_joke.id, page_id: page.id)
        next unless page_joke

        # Mark it as a duplicate
        puts "Marking duplicate joke #{other_joke.id} (#{other_joke.setup} #{other_joke.punchline}) as duplicate on page #{page.handle} (#{page.id})"
        page_joke.update!(duplicate: true)
      end

      # Update the page on Shopify
      @page_service.call(page)
    end
  end
end
