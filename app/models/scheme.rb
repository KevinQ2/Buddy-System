class Scheme < ApplicationRecord
    belongs_to :department
    has_many :questionnaires, dependent: :delete_all
    has_many :enroll_ins, dependent: :destroy
    has_many :matchs, dependent: :destroy
    has_one :enroll_link, dependent: :destroy
    after_destroy :remove_from_admins


    validate :endDate_should_be_later_than_startDate
    validate :startDate_cannot_be_in_past

    validates :description, presence: true, :length => {:minimum => 5}
    validates :codeOfConduct, presence: true, :length => {:minimum => 5}
    validates :title, presence: true, :length => {:minimum => 4}

    def endDate_should_be_later_than_startDate
        if self.startDate > self.endDate
            errors.add(:endDate, "should be later than start date")
        end
    end

    def startDate_cannot_be_in_past
        if self.startDate < Date.current
            errors.add(:startDate, "should not be in the past")
        end
    end

    # remove occurences in admins
    def remove_from_admins()
      Admin.all.map { |admin| admin.update(:scheme_ids => admin.scheme_ids.delete(self.id))}
    end

end
