require 'test_helper'

class JokeTest < ActiveSupport::TestCase
  test "joke.pages does not return pages where the joke is marked as duplicate" do
    # Create two pages
    page1 = Page.create!(keywords: 'test1')
    page2 = Page.create!(keywords: 'test2')

    # Create a joke
    joke = Joke.create!(setup: 'setup', punchline: 'punchline')

    # Create page_jokes records
    PageJoke.create!(page: page1, joke: joke)
    PageJoke.create!(page: page2, joke: joke, duplicate_of_id: Joke.create!(setup: 'another setup', punchline: 'another punchline').id)

    # Assert that joke.pages only includes page1
    assert_equal [page1], joke.pages
  end
end
