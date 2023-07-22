namespace :jokes do
  desc "Import jokes from a CSV file"
  task import: :environment do
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

  desc "Create Joke pages on Shopify"
  task create_pages: :environment do
    session = ShopifyAPI::Auth::Session.new(shop: 'gossamergeardev.myshopify.com', access_token: ENV['SHOPIFY_ADMIN_API_ACCESS_TOKEN'])
    Page.find_each do |page|
      shopify_page = if page.shopify_id.present?
        ShopifyAPI::Page.find(id: page.shopify_id, session: session) 
      else 
        ShopifyAPI::Page.new(session: session)
      end

      keywords = page.keywords.downcase
      jokes = Joke.where('setup ILIKE ? OR punchline ILIKE ?',"% #{keywords} %","% #{keywords} %")
      next if jokes.empty?

      shopify_page.title = "#{jokes.count}+ #{page.keywords.titleize} Jokes"
      shopify_page.handle = "#{page.keywords.parameterize}-jokes"
      
      html = "<ul>"
      jokes.find_each do |joke|
        html += "<li>#{joke.setup}<br/>#{joke.punchline}</li>"
      end
      html += "</ul>"
      shopify_page.body_html = html
      
      shopify_page.save!
      page.update!(shopify_id: shopify_page.id)

      puts "Created page #{shopify_page.id} for #{page.keywords}"
    end
  end
end
