class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    enable_extension :citext
    create_table :transactions do |t|
      t.string :credit_card_number
      t.string :credit_card_expiration_date
      t.citext :result

      t.timestamps
    end
  end
end
