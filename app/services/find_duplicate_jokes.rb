require 'narray'
require 'tf-idf-similarity'

class FindDuplicateJokes
  def initialize(joke)
    @joke = joke
    @joke_document = TfIdfSimilarity::Document.new(preprocess(@joke.setup + " " + @joke.punchline))
    @corpus = []
  end

  def call(threshold: 0.7)
    clean_joke_setup = remove_stop_words(@joke.setup)
    clean_joke_punchline = remove_stop_words(@joke.punchline)

    # Search using clean setup and punchline
    jokes = Joke
      .where.not(id: @joke.id)
      .search_any(clean_joke_setup + " " + clean_joke_punchline)

    @corpus = jokes.map{|j| TfIdfSimilarity::Document.new(preprocess(j.setup + " " + j.punchline)) }
    @corpus << @joke_document

    # Create a TfIdf model from the corpus
    model = TfIdfSimilarity::TfIdfModel.new(@corpus, library: :narray)

    # Compute the similarity matrix
    similarity_matrix = model.similarity_matrix

    # Find similar jokes
    similarities = {}
    @corpus.each_with_index do |doc, index|
      sim = similarity_matrix[model.document_index(doc), model.document_index(@joke_document)]
      # Store the similarity if it's above the threshold
      similarities[jokes[index]] = sim if sim > threshold
    end

    similarities
  end

  private

  def remove_stop_words(text)
    text
      .downcase
      .gsub(/[^a-z0-9\s]/i, '')
      .split(' ')
      .reject { |word| STOP_WORDS.include?(word) }
      .map(&:strip)
      .join(' ')
  end

  # Preprocess text by downcasing and removing non-alphanumeric characters, except spaces
  def preprocess(text)
    text
      .downcase
      .gsub(/[^0-9a-z ]/i, '')
  end
end
