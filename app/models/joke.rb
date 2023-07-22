class Joke < ApplicationRecord
  enum joke_type: { general: 0, pun: 1, knock_knock: 2, dad: 3, light_bulb: 4 }

  belongs_to :source, optional: true
  has_and_belongs_to_many :pages
end
