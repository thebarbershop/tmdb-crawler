class AddReferencesToCreditMovie < ActiveRecord::Migration[5.2]
  def change
    add_reference :credit_movies, :movies, foreign_key:true
    add_reference :credit_movies, :people, foreign_key:true
  end
end
