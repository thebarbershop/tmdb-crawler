class CreateCreditTv < ActiveRecord::Migration[5.2]
  def change
    create_table :credit_tvs do |t|
      t.string :role
      t.bigint :tv_id, foreign_key: true
      t.bigint :person_id, foreign_key: true
      t.timestamps
    end
  end
end
