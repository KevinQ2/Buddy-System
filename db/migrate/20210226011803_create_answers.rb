class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.belongs_to :questionnaire
      t.belongs_to :user
      t.belongs_to :scheme


      t.string :user_answers, array: true, default: []

      t.timestamps
    end
  end
end
