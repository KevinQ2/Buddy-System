class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.belongs_to :questionnaire
      t.string :description
      t.string :options, array: true, default: []
      t.boolean :match
      t.boolean :matching_up_to_user
      t.boolean :give_priority
    end
  end
end
