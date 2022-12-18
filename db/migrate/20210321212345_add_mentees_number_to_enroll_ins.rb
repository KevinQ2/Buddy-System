class AddMenteesNumberToEnrollIns < ActiveRecord::Migration[6.0]
  def change
    add_column :enroll_ins, :mentees_number, :int
  end
end
