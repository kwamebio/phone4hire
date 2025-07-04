class CreateSessions < ActiveRecord::Migration[7.2]
  def change
    create_table :sessions do |t|
      t.string :token
      t.string :expired_at
      t.string :ip_address
      t.string :user_agent
      t.string :last_active_at
      t.references :owner, polymorphic: true, null: false, index: true
      t.references :dealer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
