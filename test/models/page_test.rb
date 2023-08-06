require 'test_helper'

class PageTest < ActiveSupport::TestCase
  test "page.jokes does not return jokes marked as duplicate" do
    # Create a page
    page = Page.create!(keywords: 'test')

    # Create two jokes
    joke1 = Joke.create!(setup: 'setup1', punchline: 'punchline1')
    joke2 = Joke.create!(setup: 'setup2', punchline: 'punchline2')

    # Create page_jokes records
    PageJoke.create!(page: page, joke: joke1)
    PageJoke.create!(page: page, joke: joke2, duplicate_of_id: joke1.id)

    # Assert that page.jokes only includes joke1
    assert_equal [joke1], page.jokes
  end
end
