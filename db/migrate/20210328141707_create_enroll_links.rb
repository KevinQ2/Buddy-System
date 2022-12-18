class CreateEnrollLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :enroll_links do |t|
      t.string :mentee_link
      t.string :mentor_link
      t.timestamps
      t.belongs_to :scheme
    end
  end
end
