class CreateAdmins < ActiveRecord::Migration[6.0]
  def change
    create_table :admins do |t|
      t.string :username
      t.string :password
      t.string :first_name
      t.string :last_name
      t.string :admin_access, array: true, default: []
      t.string :scheme_access, default: "no schemes"
      t.bigint :department_ids, array: true, default: []
      t.bigint :scheme_ids, array: true, default: []

      t.timestamps
    end
  end
end
