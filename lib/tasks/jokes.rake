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

  desc "Create Joke pages on Shopify"
  task create_pages: :environment do
    session = ShopifyAPI::Auth::Session.new(shop: 'gossamergeardev.myshopify.com', access_token: ENV['SHOPIFY_ADMIN_API_ACCESS_TOKEN'])
    Page.find_each do |page|
      begin
        shopify_page = if page.shopify_id.present?
          ShopifyAPI::Page.find(id: page.shopify_id, session: session) 
        else 
          ShopifyAPI::Page.new(session: session)
        end
  
        jokes = Joke.search(page.keywords)
        next if jokes.empty?
  
        shopify_page.title = "#{jokes.count}+ #{page.keywords.titleize} Jokes"
        shopify_page.handle = "#{page.keywords.parameterize}-jokes"
        
        html = "<ul>"
        jokes.find_each do |joke|
          html += "<li>#{joke.setup}<br/>#{joke.punchline}</li>"
        end
        html += "</ul>"
        shopify_page.body_html = html
        
        if shopify_page.save
          page.update(shopify_id: shopify_page.id) 
          puts "Created page #{shopify_page.id} for #{page.keywords}"
        else
          puts "FAILED for #{page.keywords}"
        end
      rescue ShopifyAPI::Errors::HttpResponseError => e
        puts "Shopify API error for #{page.keywords}: #{e.message}"
      end
    end
  end
  
end
