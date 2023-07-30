class ProcessPage
  def initialize(session)
    @session = session
  end

  def call(page)
    shopify_page = find_shopify_page_by_handle(page) || find_or_initialize_shopify_page(page)

    shopify_page.title = "#{page.jokes.count}+ #{page.keywords.titleize} Jokes"
    shopify_page.handle = page.handle
    shopify_page.body_html = build_html_body(page.jokes)

    if shopify_page.save!
      page.update!(shopify_id: shopify_page.id)
      puts "Created/updated page #{shopify_page.id} for Page (#{page.id}): #{page.keywords}"
    else
      puts "FAILED for Page (#{page.id}): #{page.keywords}"
    end
  rescue ShopifyAPI::Errors::HttpResponseError => e
    puts "Shopify API error for #{page.keywords}: #{e.message}"
  end

  private

  def find_shopify_page_by_handle(page)
    shopify_pages = ShopifyAPI::Page.all(handle: page.handle, session: @session)
    shopify_pages.first
  end

  def find_or_initialize_shopify_page(page)
    if page.shopify_id.present?
      ShopifyAPI::Page.find(id: page.shopify_id, session: @session)
    else
      ShopifyAPI::Page.new(session: @session)
    end
  end

  def build_html_body(jokes)
    jokes.reduce("<ul>") do |html, joke|
      html + "<li><h2>#{joke.setup}</h2><p>#{joke.punchline}</p></li>"
    end + "</ul>"
  end
end
