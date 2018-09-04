class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.references :user, null: false
      t.decimal :amount, null: false
      t.string :status, null: false
      t.string :stripe_token

      t.timestamps
    end
  end
end
