class CreateQuestionnaires < ActiveRecord::Migration[6.0]
  def change
    create_table :questionnaires do |t|
      t.string :name
      t.string :description
      t.belongs_to :scheme


      t.timestamps
    end
  end
end
