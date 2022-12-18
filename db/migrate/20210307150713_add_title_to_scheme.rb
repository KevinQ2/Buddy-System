class AddTitleToScheme < ActiveRecord::Migration[6.0]
  def change
    add_column :schemes, :title, :string
  end
end
