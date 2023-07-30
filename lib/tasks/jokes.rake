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

  desc "Create Joke pages on Shopify"
  task create_pages: :environment do
    session = ShopifyAPI::Auth::Session.new(shop: 'gossamergeardev.myshopify.com', access_token: ENV['SHOPIFY_ADMIN_API_ACCESS_TOKEN'])
    service = ProcessPage.new(session)

    Page.find_each do |page|
      next if page.jokes.count < 3
      
      service.call(page)
    end
  end
end
