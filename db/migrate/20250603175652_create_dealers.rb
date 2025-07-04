class CreateDealers < ActiveRecord::Migration[7.2]
  def change
    create_table :dealers do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.text :address
      t.string :region
      t.boolean :approved

      t.timestamps
    end
    add_index :dealers, :email, unique: true
  end
end
