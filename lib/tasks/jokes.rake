namespace :jokes do
  desc "Import jokes from a CSV file"
  task import: :environment do
    require 'csv'

    FILE = "t_lightbulbs-cleaned.csv"
    URL = "https://www.kaggle.com/datasets/bfinan/jokes-question-and-answer"

    path = Rails.root.join('lib', FILE)
    csv_text = File.read(path)
    csv = CSV.parse(csv_text, headers: true)
    source = Source.create!(url: URL, filename: FILE)

    csv.each_with_index do |row, index|
      puts "Joke #{index + 1}: #{row['Question']} - #{row['Answer']}"
      source.jokes << Joke.create!(setup: row['Question'], punchline: row['Answer'], joke_type: :light_bulb)
    end

    puts "Import completed!"
  end

  desc "Process jokes to extract entities, nouns and verbs"
  task process: :environment do
    Joke.find_each do |joke|
      ProcessJoke.new(joke).process
    end
  end

  desc "Process jokes to extract entities, nouns and verbs"
  task dedupe: :environment do
    Joke.find_each do |joke|
      ProcessDuplicateJokes.new(joke).call

      break
      sleep 0.5

      # TODO: Add smarts to ignore jokes with no pages because it's a duplicate
    end
  end
end
