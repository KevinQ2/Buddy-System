class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.belongs_to  :mentor
      t.belongs_to  :mentee
      t.belongs_to  :scheme
      t.timestamps
    end
  end
end
