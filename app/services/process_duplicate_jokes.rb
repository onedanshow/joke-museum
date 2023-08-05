class ProcessDuplicateJokes
  SIMILARITY_THRESHOLD = 0.75

  def initialize(joke)
    @joke = joke
  end

  def call(threshold: SIMILARITY_THRESHOLD)
    # Find potential duplicates using the FindDuplicateJokes service class
    duplicate_jokes = FindDuplicateJokes.new(@joke).call(threshold: threshold)
    return if duplicate_jokes.empty?

    # Identify the oldest joke
    oldest_joke = ([@joke] + duplicate_jokes.keys).min_by { |j| j.created_at }

    # Delete all duplicates except for the oldest one
    duplicate_jokes.keys.each do |other_joke|
      next if other_joke == oldest_joke

      puts "Deleting duplicate joke #{other_joke.id} (#{other_joke.setup} #{other_joke.punchline})"
      # other_joke.destroy!
    end
  end
end
