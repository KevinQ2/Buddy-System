class CreateEnrollInMailings < ActiveRecord::Migration[6.0]
  def change
    create_table :enroll_in_mailings do |t|
      t.string :email
      t.timestamps
    end
  end
end
