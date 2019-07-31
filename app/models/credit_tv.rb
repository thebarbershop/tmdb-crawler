class CreditTv < ApplicationRecord
    belongs_to :person
    belongs_to :tv
end