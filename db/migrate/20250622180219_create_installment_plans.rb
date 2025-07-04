class CreateInstallmentPlans < ActiveRecord::Migration[7.2]
  def change
    create_table :installment_plans do |t|
      t.integer :total_amount
      t.integer :amount_paid
      t.integer :monthly_payment
      t.integer :due_day
      t.date :start_date
      t.date :end_date
      t.string :status, default: "active", null: false
      t.boolean :locked

      t.references :user, null: false, foreign_key: true
      t.references :device, null: false, foreign_key: true
      t.references :dealer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
