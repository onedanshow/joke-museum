require 'test_helper'

class ProcessJokeTest < ActiveSupport::TestCase
  def setup
    @joke = Joke.create!(setup: 'Setup text', punchline: 'Punchline text')
    @service = ProcessJoke.new(@joke)
  end
=begin
  test 'removes non-alphanumeric characters excluding ampersands and spaces' do
    dirty_text = "Spe&cial  Ch@racters% and $$Extra  Spac   es "
    expected_output = "Spe&cial Ch@racters and Extra Spac es"

    assert_equal expected_output, @service.clean_keywords(dirty_text)
  end
=end
  test 'removes extra spaces' do
    dirty_text = "Multiple    spaces   between words"
    expected_output = "Multiple spaces between words"

    assert_equal expected_output, @service.clean_keywords(dirty_text)
  end

  test 'trims spaces at the beginning and end of the string' do
    dirty_text = "  Leading and trailing spaces  "
    expected_output = "Leading and trailing spaces"

    assert_equal expected_output, @service.clean_keywords(dirty_text)
  end

  test "clean_keywords method" do
    pj = ProcessJoke.new(nil)
    
    assert_equal "E.T.", pj.send(:clean_keywords, "E.T.")
    assert_equal "P.S.", pj.send(:clean_keywords, "P.S.")
    assert_equal "O'Shea", pj.send(:clean_keywords, "O'Shea")
    assert_equal "L'Hospital", pj.send(:clean_keywords, "L'Hospital")
    assert_equal "A & B", pj.send(:clean_keywords, "A & B")
    assert_equal "word", pj.send(:clean_keywords, "word!@#")
    assert_equal "double spaced word", pj.send(:clean_keywords, " double  spaced  word ")
  end
end
