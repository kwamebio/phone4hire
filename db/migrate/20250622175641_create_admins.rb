class CreateAdmins < ActiveRecord::Migration[7.2]
  def change
    create_table :admins do |t|
      t.string :email
      t.string :password_digest
      t.references :dealer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
