class ProcessPage
  def initialize(session: nil)
    @session = session || ShopifyAPI::Auth::Session.new(shop: 'gossamergeardev.myshopify.com', access_token: ENV['SHOPIFY_ADMIN_API_ACCESS_TOKEN'])
  end

  def call(page)
    jokes = page.jokes.clean

    shopify_page = find_or_initialize_shopify_page(page)
    puts shopify_page.inspect
    shopify_page.id = page.shopify_id if page.shopify_id.present?
    shopify_page.author = "Museum of Jokes"
    shopify_page.title = "#{jokes.count}+ #{page.keywords.titleize} Jokes"
    shopify_page.handle = page.handle
    shopify_page.body_html = "<p>The Best #{page.keywords.titleize} jokes around about, all #{jokes.count} of them!</p>"
    shopify_page.published = page.published
    shopify_page.metafields = [{
      key: "jokes",
      value: jokes.map{|j| "#{j.setup}||#{j.punchline}"}.to_json,
      type: "json",
      namespace: "moj"
    },{
      key: "related_pages",
      value: MatchPages.new(page).call.join(","),
      type: "single_line_text_field",
      namespace: "moj"
    }]

    if shopify_page.save!
      page.update!(shopify_id: shopify_page.id)
      puts "Created/updated Shopify Page (ID: #{shopify_page.id}) from local Page (ID: #{page.id}): #{page.keywords}"
    else
      puts "FAILED for Page (ID #{page.id}): #{page.keywords}"
    end
  rescue ShopifyAPI::Errors::HttpResponseError => e
    puts "Shopify API error for #{page.keywords} (Shopify ID: #{shopify_page.id}): #{e.message}"
  end

  private

  def find_or_initialize_shopify_page(page)
    shopify_page = nil
    shopify_page = begin
      puts "Had to look up page by handle #{page.handle}"
      shopify_pages = ShopifyAPI::Page.all(handle: page.handle, session: @session)
      shopify_pages.first
    end if page.handle.present? && page.shopify_id.blank?
    
    shopify_page || ShopifyAPI::Page.new(session: @session)
  end
end
