class Tv < ApplicationRecord
    has_many :credit_tvs
    has_many :people, :through => :credit_tvs
end