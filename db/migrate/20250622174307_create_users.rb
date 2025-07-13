class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :phone_number
      t.string :national_id
      t.string :home_address
      t.string :status, default: "active", null: false
      t.boolean :account_verification, default: false, null: false
      t.string :reset_password_token
      t.date :reset_password_sent_at

      t.references :dealer, foreign_key: true, null: false

      t.timestamps
    end
  end
end
