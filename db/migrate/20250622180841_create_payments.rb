class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.integer :amount
      t.date :payment_date
      t.integer :status
      t.string :method
      t.string :currency
      t.string :trans_reference
      t.string :external_ref

      t.references :installment_plan, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
