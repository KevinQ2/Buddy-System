class Department < ApplicationRecord
  has_many :scheme, dependent: :destroy

  after_destroy :remove_from_admins

  validates :name, presence: true, :length => {:minimum => 2}, uniqueness: true

  # remove occurences in admins
  def remove_from_admins()
    Admin.all.map { |admin| admin.update(:department_ids => admin.department_ids.delete(self.id))}
  end
end
