class Person < ApplicationRecord
    has_many :credit_movies
    has_many :movies, :through => :credit_movies
    has_many :credit_tvs
    has_many :tvs, :through => :credit_tvs
end