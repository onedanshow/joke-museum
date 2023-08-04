class Joke < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search, 
    against: %i[setup punchline],
    using: { tsearch: { dictionary: 'english' } }

  # TODO: Move joke type to a model and train a classifier as a joke can have multiple types (i.e. knock knock and math)
  enum joke_type: { general: 0, pun: 1, knock_knock: 2, dad: 3, light_bulb: 4, math: 5 } 
  enum classification: { unclassified: 0, training_clean: 1, training_offensive: 2, ai_clean: 3, ai_offensive: 4 }
  scope :clean, -> { where(classification: %i[unclassified training_clean ai_clean]) }

  belongs_to :source, optional: true
  has_and_belongs_to_many :pages
end
