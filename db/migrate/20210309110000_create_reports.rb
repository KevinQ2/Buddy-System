class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.integer :reporter_id
      t.integer :reportee_id
      t.text :message
      t.boolean :handled, default: false



      t.timestamps




    end
    add_index :reports, [:reporter_id, :reportee_id], unique: true
  end
end
