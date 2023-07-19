class Joke < ApplicationRecord
  enum joke_type: { general: 0, pun: 1, knock_knock: 2, dad: 3 }
end
