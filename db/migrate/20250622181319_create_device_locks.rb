class CreateDeviceLocks < ActiveRecord::Migration[7.2]
  def change
    create_table :device_locks do |t|
      t.string :reason
      t.datetime :locked_at
      t.datetime :unlocked_at
      t.boolean :manually_locked

      t.references :device, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
