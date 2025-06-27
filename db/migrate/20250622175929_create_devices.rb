class CreateDevices < ActiveRecord::Migration[7.2]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :imei
      t.string :serial_number
      t.string :model
      t.integer :purchasing_price
      t.string :status, default: "available", null: false

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
