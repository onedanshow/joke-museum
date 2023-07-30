# lib/tasks/import_keywords.rake

require 'csv'

namespace :pages do
  desc "Create/Update Joke pages on Shopify"
  task create_update_shopify: :environment do
    session = ShopifyAPI::Auth::Session.new(shop: 'gossamergeardev.myshopify.com', access_token: ENV['SHOPIFY_ADMIN_API_ACCESS_TOKEN'])
    service = ProcessPage.new(session)
    count = 1

    Page.find_each do |page|
      next if page.jokes.count < 3
      puts "#{count}: Processing Page #{page.id}: #{page.keywords}"

      # service.call(page)
      count += 1
    end
  end
end
