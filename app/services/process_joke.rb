class ProcessJoke
  require 'json'

  attr_reader :joke, :output

  def initialize(joke)
    @joke = joke
    @output = nil
  end

  def process
    run_python_nlp
    find_or_create_pages
  end

  def run_python_nlp
    text = [joke.setup, joke.punchline].join(' ').gsub(/["\/]/, '')
    puts "\nProcessing #{joke.id} - #{text}"
    @output = JSON.parse(`python3 lib/tasks/nlp.py "#{text}"`)
    puts "Output: #{@output}"
  end

  def clean_keywords(text)
    # remove non-alphanumeric characters preserving spaces, ampersands, periods inside words and apostrophes
    text = text.gsub(/(?<!\w)[.](?!\w)|[^0-9a-z &'.]/i, '')
    # remove double+ spaces
    text = text.split.join(' ')
    # remove spaces at the beginning and end of the string
    text.strip
  end

  def find_or_create_pages
    @output.each do |key, words|
      next unless key.include?('lemmatized') # process only lemmatized versions

      words.each do |lemmatized_words|
        cleaned_words = clean_keywords(lemmatized_words)
        next if cleaned_words.blank?

        handle = Page.generate_handle(cleaned_words)
        page = Page.find_by(handle: handle)
        page ||= Page.create!(keywords: cleaned_words, handle: handle)
        page.jokes << joke unless page.jokes.include?(joke)
      end
    end
  end
end
