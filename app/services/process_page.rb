class ProcessPage
  def initialize(session: nil)
    @session = session || ShopifyAPI::Auth::Session.new(shop: 'gossamergeardev.myshopify.com', access_token: ENV['SHOPIFY_ADMIN_API_ACCESS_TOKEN'])
  end

  def call(page)
    jokes = page.jokes.clean

    shopify_page = find_or_initialize_shopify_page(page)
    shopify_page.id = page.shopify_id if page.shopify_id.present?
    shopify_page.author = "Museum of Jokes"
    shopify_page.title = "#{jokes.count}+ #{page.keywords.titleize} Jokes"
    shopify_page.handle = page.handle
    shopify_page.body_html = "<p>Best #{page.keywords.titleize} jokes around. Enjoy all #{jokes.count} of them!</p>"
    shopify_page.published = page.published
    # Warning: Metafields need to be separate API calls below. Despite docs example of page.metafields = [...], this does not work.
    # Reference: https://community.shopify.com/c/shopify-apps/app-data-metafields-do-not-update-in-the-front-end/m-p/2170399/highlight/true#M66562

    if shopify_page.save!
      page.update!(shopify_id: shopify_page.id)
      puts "Created/updated Shopify Page (ID: #{shopify_page.id}) from local Page (ID: #{page.id}): #{page.keywords}"
    else
      puts "FAILED for Page (ID #{page.id}): #{page.keywords}"
    end

    set_jokes_shopify_metafield(shopify_page, page, jokes)
    set_related_pages_shopify_metafield(shopify_page, page)
  rescue ShopifyAPI::Errors::HttpResponseError => e
    puts "Shopify API error for #{page.keywords} (Shopify ID: #{shopify_page.id}): #{e.message}"
  end

  private

  def find_or_initialize_shopify_page(page)
    shopify_page = nil
    shopify_page ||= begin
      puts "Had to look up page by handle #{page.handle}"
      shopify_pages = ShopifyAPI::Page.all(handle: page.handle, session: @session)
      shopify_pages.first
    end if page.handle.present? && page.shopify_id.blank?
    
    shopify_page || ShopifyAPI::Page.new(session: @session)
  end

  def set_jokes_shopify_metafield(shopify_page, page, jokes)
    sleep 0.5
    metafield = ShopifyAPI::Metafield.new(session: @session)
    metafield.page_id = shopify_page.id
    metafield.namespace = "moj"
    metafield.key = "jokes"
    metafield.value = jokes.shuffle.map{|j| "#{j.setup}||#{j.punchline}"}.to_json
    metafield.type = "json"
    metafield.save!
  end

  def set_related_pages_shopify_metafield(shopify_page, page)
    sleep 0.5
    metafield = ShopifyAPI::Metafield.new(session: @session)
    metafield.page_id = shopify_page.id
    metafield.namespace = "moj"
    metafield.key = "related_pages"
    metafield.value = MatchPages.new(page).call.join(",")
    metafield.type = "single_line_text_field"
    metafield.save!
  end
end
