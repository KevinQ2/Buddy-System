class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :gender
      t.string :first_name
      t.string :last_name
      t.integer :age

      t.timestamps
    end
  end
end
