class CreateCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :charges do |t|
      #t.jsonb :data
      t.text :data
      t.string :status
      t.references :user, foreign_key: true
      t.references :payment, foreign_key: true

      t.timestamps
    end
  end
end
