class ChangeColumnsToNotNullInScheme < ActiveRecord::Migration[6.0]
  def change
    change_column_null :schemes, :description, false
    change_column_null :schemes, :codeOfConduct, false
    change_column_null :schemes, :endDate, false
    change_column_null :schemes, :startDate, false
    change_column_null :schemes, :title, false
  end
end
