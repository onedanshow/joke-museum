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

  desc "Import jokes from a JSON file"
  task import_json: :environment do
    require 'json'

    FILE = "index.json"
    URL = "https://github.com/15Dkatz/official_joke_api/blob/master/jokes/index.json"

    path = Rails.root.join('lib', FILE)
    json_text = File.read(path)
    jokes = JSON.parse(json_text)
    source = Source.create!(url: URL, filename: FILE)

    jokes.each_with_index do |joke_data, index|
      setup = joke_data['setup'].strip
      punchline = joke_data['punchline'].strip

      puts "Joke #{index + 1}: #{setup} - #{punchline}"

      # Convert the type from string to symbol for ActiveRecord Enum
      joke_type = joke_data['type'].underscore.to_sym

      source.jokes << Joke.create!(setup: setup, punchline: punchline, joke_type: joke_type)
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
  task process_last_source: :environment do
    Source.last.jokes.find_each do |joke|
      ProcessJoke.new(joke).process
    end
  end

  desc "Process jokes to extract entities, nouns and verbs"
  task dedupe: :environment do
    Joke.find_each do |joke|
      ProcessDuplicateJokes.new(joke).call
    end
  end

  desc "Process jokes to extract entities, nouns and verbs"
  task dedupe_last_source: :environment do
    Source.last.jokes.find_each do |joke|
      ProcessDuplicateJokes.new(joke).call
    end
  end
end
