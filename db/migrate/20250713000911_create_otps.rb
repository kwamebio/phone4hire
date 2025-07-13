class CreateOtps < ActiveRecord::Migration[7.2]
  def change
    create_table :otps do |t|
      t.string :otp_code
      t.boolean :verify_status
      t.boolean :delivery_status
      t.datetime :expires_at
      t.references :owner, polymorphic: true, null: false

      t.timestamps
    end
  end
end
