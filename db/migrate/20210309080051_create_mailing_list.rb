class CreateMailingList < ActiveRecord::Migration[6.0]
  def change
    create_table :mailing_lists do |t|
      t.string :email
    end
  end
end
