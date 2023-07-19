namespace :import do
  desc "Import jokes from a CSV file"
  task jokes: :environment do
    require 'csv'

    path = Rails.root.join('lib', 'jokes.csv')
    csv_text = File.read(path)
    csv = CSV.parse(csv_text, headers: true)

    csv.each_with_index do |row, index|
      puts "Joke #{index + 1}: #{row[1]} - #{row[2]}"
      Joke.create!(setup: row[1], punchline: row[2])
    end

    puts "Import completed!"
  end
end
