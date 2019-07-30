class AddReferencesToCreditTv < ActiveRecord::Migration[5.2]
  def change
    add_reference :credit_tvs, :tvs, foreign_key:true
    add_reference :credit_tvs, :people, foreign_key:true
  end
end
