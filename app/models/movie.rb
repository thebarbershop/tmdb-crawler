class Movie < ApplicationRecord
    has_many :credit_movies
    has_many :people, :through => :credit_movies
end
