class CreateCreditTv < ActiveRecord::Migration[5.2]
  def change
    create_table :credit_tvs do |t|
      t.string :role
      t.timestamps
    end
  end
end
