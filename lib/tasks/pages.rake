# lib/tasks/import_keywords.rake

require 'csv'

namespace :pages do
  desc "Create/Update Joke pages on Shopify"
  task create_update_shopify: :environment do
    session = ShopifyAPI::Auth::Session.new(shop: 'gossamergeardev.myshopify.com', access_token: ENV['SHOPIFY_ADMIN_API_ACCESS_TOKEN'])
    service = ProcessPage.new(session: session)
    count = 1
  
    Page.find_each do |page|
      next if page.jokes.clean.count < 3
  
      begin
        service.call(page)
        count += 1
      rescue Net::ReadTimeout => e
        puts "Encountered a timeout error for page ID ##{page.id}: #{e.message}. Moving on to the next page."
        next
      end
    end
  end

  desc "Create homepage joke cloud"
  task create_homepage_cloud: :environment do
    # First, get the top 500 pages by joke count
    top_pages = Page.published.joins(:page_jokes)
      .where(page_jokes: { duplicate: false })
      .group("pages.id")
      .order("COUNT(page_jokes.joke_id) DESC")
      .limit(500)

    # Then, shuffle them in memory
    random_order = top_pages.to_a.shuffle

    # Finally, print out their information
    html = random_order.reduce("<div class='page-width scroll-trigger animate--slide-in center'>") do |html, page|
      html + "<a class='link link--text' href='/pages/#{page.handle}'>#{page.keywords.titleize} Jokes</a> "
    end + "</div>"

    puts html
  end
end
