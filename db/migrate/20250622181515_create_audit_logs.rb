class CreateAuditLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :audit_logs do |t|
      t.string :action
      t.references :performed_by, polymorphic: true, null: false
      t.jsonb :details
      t.string :ip_address
      t.string :user_agent

      t.references :dealer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
