require 'narray'
require 'tf-idf-similarity'

class FindDuplicateJokes
  def initialize(joke, corpus_joke_ids: nil)
    @joke = joke
    @joke_document = TfIdfSimilarity::Document.new(preprocess(@joke.setup + " " + @joke.punchline))
    @corpus_joke_ids = corpus_joke_ids
    @corpus = []
  end

  def call(threshold: 0.75)
    clean_joke_setup = remove_stop_words(@joke.setup)
    clean_joke_punchline = remove_stop_words(@joke.punchline)

    if @corpus_joke_ids.present?
      # Search using ID provided
      jokes = Joke.where.not(id: @joke.id).where(id: @corpus_joke_ids)
    else
      # Search using whole Joke database using stop-work-less setup and punchline
      jokes = Joke.where.not(id: @joke.id).search_any(clean_joke_setup + " " + clean_joke_punchline)
    end

    @corpus = jokes.map{|j| TfIdfSimilarity::Document.new(preprocess(j.setup + " " + j.punchline)) }
    @corpus << @joke_document

    # Create a TfIdf model from the corpus
    model = TfIdfSimilarity::TfIdfModel.new(@corpus, library: :narray)

    # Compute the similarity matrix
    similarity_matrix = model.similarity_matrix

    # Find similar jokes
    similarities = {}
    joke_index = model.document_index(@joke_document) 
    @corpus.each_with_index do |doc, index|
      next if index == joke_index
      
      sim = similarity_matrix[model.document_index(doc), joke_index]
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
