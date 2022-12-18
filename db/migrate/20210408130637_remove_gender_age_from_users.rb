class RemoveGenderAgeFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :gender
    remove_column :users, :age
  end
end
