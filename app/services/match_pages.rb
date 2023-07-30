require 'wordnet'

class MatchPages
  def initialize(page)
    @page = page
  end

  def call
    match_pages = []
    Page.where.not(id: @page.id).each do |other_page|
      match_score = calculate_match_score(other_page)
      match_pages << { page: other_page, score: match_score } if match_score > 0
    end
    match_pages.sort_by { |match| match[:score] }.reverse
  end

  private

  def calculate_match_score(other_page)
    lemma_index = WordNet::LemmaIndex.instance
    match_score = 0
    @page.keywords.each do |keyword|
      other_page.keywords.each do |other_keyword|
        keyword_lemma = lemma_index.find(keyword)
        other_keyword_lemma = lemma_index.find(other_keyword)
        match_score += keyword_lemma.distance_to(other_keyword_lemma) if keyword_lemma && other_keyword_lemma
      end
    end
    match_score
  end
end
