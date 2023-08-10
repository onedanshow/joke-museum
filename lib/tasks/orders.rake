namespace :orders do
  desc "Delete orders from Shopify"
  task destroy_all: :environment do
    session = ShopifyAPI::Auth::Session.new(shop: 'gossamergeardev.myshopify.com', access_token: ENV['SHOPIFY_ADMIN_API_ACCESS_TOKEN'])

    # Initially, we haven't started paginating
    since_id = nil

    loop do
      count = ShopifyAPI::Order.count(status: :any, session: session)
      puts "Found #{count.body['count']} orders to delete."
      # Fetch orders in batches using since_id for pagination
      orders = ShopifyAPI::Order.all(status: :any, limit: 250, since_id: since_id, session: session)
      
      break if orders.empty?

      # Process the batch
      orders.each do |order|
        ShopifyAPI::Order.delete(
          session: session,
          id: order.id,
        )
        # Update since_id for the next batch
        since_id = order.id

        puts "Deleted order ##{order.id}"
        sleep 0.5 # to avoid hitting API call limits
      end
    end
  end
end
