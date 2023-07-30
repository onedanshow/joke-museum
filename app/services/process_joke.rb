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

  private

  def run_python_nlp
    text = [joke.setup, joke.punchline].join(' ').gsub(/["\/]/, '')
    puts "\nProcessing #{joke.id} - #{text}"
    @output = JSON.parse(`python3 lib/tasks/nlp.py "#{text}"`)
    puts "Output: #{@output}"
  end

  def find_or_create_pages
    @output.each do |key, words|
      next unless key.include?('lemmatized') # process only lemmatized versions

      words.each do |word|
        next if word.strip.empty? # skip if the word is blank

        page = Page.find_or_create_by!(keywords: word)
        page.jokes << joke
      end
    end
  end
end
