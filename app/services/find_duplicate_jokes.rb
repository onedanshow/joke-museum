require 'narray'
require 'tf-idf-similarity'

class FindDuplicateJokes
  attr_reader :jokes, :corpus, :model

  def initialize(jokes)
    @jokes = jokes
    # Preprocess the jokes and create a corpus of documents
    @corpus = jokes.map do |joke|
      text = preprocess(joke.setup + " " + joke.punchline)
      TfIdfSimilarity::Document.new(text)
    end
  end

  # Find duplicates for a given joke
  def find_duplicates(joke, threshold: 0.7)
    joke_document = TfIdfSimilarity::Document.new(preprocess(joke.setup + " " + joke.punchline))
    puts "Creating TfIdfModel..."
    @model = TfIdfSimilarity::TfIdfModel.new(@corpus + [joke_document], library: :narray)
    puts "Calculating Similarity Matrix..."
    @matrix = @model.similarity_matrix
    similarities = {}
    puts "Finding Duplicates..."
    @corpus.each_with_index do |doc, index|
      sim = @matrix[@model.document_index(doc), @model.document_index(joke_document)]
      # Store the similarity if it's above the threshold
      similarities[jokes[index]] = sim if sim > threshold
    end

    similarities
  end

  private

  # Preprocess text by downcasing and removing non-alphanumeric characters, except spaces
  def preprocess(text)
    text.downcase.gsub(/[^0-9a-z ]/i, '')
  end
end

# Example usage
# jokes = [Joke.new("setup1", "punchline1"), Joke.new("setup2", "punchline2"), ...]
# finder = FindDuplicates.new(jokes)
# duplicates = finder.find_duplicates(jokes[0])
# puts duplicates
