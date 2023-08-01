class ProcessPage
  def initialize(session)
    @session = session
  end

  def call(page)
    shopify_page = find_or_initialize_shopify_page(page)

    shopify_page.title = "#{page.jokes.count}+ #{page.keywords.titleize} Jokes"
    shopify_page.handle = page.handle
    shopify_page.body_html = build_html_body(page.jokes)

    if shopify_page.save!
      page.update!(shopify_id: shopify_page.id)
      puts "Created/updated Shopify Page (ID: #{shopify_page.id}) from local Page (ID: #{page.id}): #{page.keywords}"
    else
      puts "FAILED for Page (#{page.id}): #{page.keywords}"
    end

    set_related_pages_shopify_metafield(shopify_page, page)
  rescue ShopifyAPI::Errors::HttpResponseError => e
    puts "Shopify API error for #{page.keywords}: #{e.message}"
  end

  private

  def find_or_initialize_shopify_page(page)
    spage = nil
    spage ||= ShopifyAPI::Page.find(id: page.shopify_id, session: @session) if page.shopify_id.present?
    spage ||= begin
      shopify_pages = ShopifyAPI::Page.all(handle: page.handle, session: @session)
      shopify_pages.first
    end if page.handle.present?
    
    spage || ShopifyAPI::Page.new(session: @session)
  end

  # TODO: set_jokes_shopify_metafield to replace this
  def build_html_body(jokes)
    jokes.reduce("<ul>") do |html, joke|
      html + "<li><h2>#{joke.setup}</h2><p>#{joke.punchline}</p></li>"
    end + "</ul>"
  end

  def set_related_pages_shopify_metafield(shopify_page, page)
    metafield = ShopifyAPI::Metafield.new(session: @session)
    metafield.page_id = shopify_page.id
    metafield.namespace = "moj"
    metafield.key = "related_pages"
    metafield.value = MatchPages.new(page).call.join(",")
    metafield.type = "single_line_text_field"
    metafield.save!
  end
end
