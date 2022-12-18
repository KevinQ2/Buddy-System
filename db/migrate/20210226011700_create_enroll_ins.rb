class CreateEnrollIns < ActiveRecord::Migration[6.0]
  def change
    create_table :enroll_ins do |t|
      t.string :role
      t.boolean :matched
      t.belongs_to  :user
      t.belongs_to  :scheme
      t.integer :priority_score

      t.timestamps
    end
  end
end
