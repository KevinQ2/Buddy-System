class CreateSchemes < ActiveRecord::Migration[6.0]

  def change
    create_table :schemes do |t|
      t.string :description
      t.string :codeOfConduct
      t.boolean :has_questionnaire
      t.date :endDate
      t.date :startDate
      t.belongs_to :department


      t.timestamps
    end
  end
end
