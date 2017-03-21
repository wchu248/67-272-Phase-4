class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :school_id
      t.integer :user_id
      t.date :date
      t.float :grand_total
      t.string :payment_receipt

      t.timestamps null: false
    end
  end
end
