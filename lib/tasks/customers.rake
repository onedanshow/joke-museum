namespace :customers do
  desc "Delete customers from Shopify"
  task destroy_all: :environment do
    session = ShopifyAPI::Auth::Session.new(shop: 'gossamergeardev.myshopify.com', access_token: ENV['SHOPIFY_ADMIN_API_ACCESS_TOKEN'])

    loop do
      count = ShopifyAPI::Customer.count(session: session)
      puts "Found #{count.body['count']} customers to delete."

      # Fetch customers in batches
      customers = ShopifyAPI::Customer.all(limit: 250, session: session)
      
      break if customers.empty?

      # Process the batch
      customers.each do |customer|
        begin
          ShopifyAPI::Customer.delete(
            session: session,
            id: customer.id,
          )
          puts "Deleted customer ##{customer.id}"
          sleep 0.5 # to avoid hitting API call limits
        rescue ShopifyAPI::Errors::HttpResponseError => e
          puts "Failed to delete customer ##{customer.id}. Error: #{e.message}"
        rescue Net::OpenTimeout => e
          puts "Timeout error for customer ##{customer.id}. Error: #{e.message}. Moving on to the next customer."
        end
      end
    end
  end
end
