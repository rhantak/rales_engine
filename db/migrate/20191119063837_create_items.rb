class CreateItems < ActiveRecord::Migration[5.2]
  def change
    enable_extension :citext
    create_table :items do |t|
      t.citext :name
      t.citext :description
      t.string :unit_price

      t.timestamps
    end
  end
end
