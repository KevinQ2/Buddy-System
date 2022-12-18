class EnrollIn < ApplicationRecord
  belongs_to :scheme
  belongs_to :user


  validate :when_mentor_should_have_mentees_number 
  validate :unique_user_in_scheme
  validate :role_legitimate
  validate :user_should_exist
  validate :schema_should_exist
  validate :schema_should_not_be_ended

  validates :scheme_id, presence: true
  validates :role, presence: true
  validates :matched, value: false


  
  def when_mentor_should_have_mentees_number
    if self.role.downcase == "mentor" && (self.mentees_number == nil || self.mentees_number <= 0)
      errors.add(:mentees_number, "should be present and higher than 0 for mentor")
    end
  end

  def schema_should_not_be_ended
    if Scheme.find(self.scheme_id).endDate < Date.current
      errors.add("Scheme", "should not be ended in order to enroll")
    end
  end

  def unique_user_in_scheme
    if EnrollIn.exists?(user_id: self.user_id, scheme_id: self.scheme_id)
      errors.add("You" ," have already enrolled into this schema")
    end
  end

  def role_legitimate
    if !(self.role == "coordinator" || self.role == "mentor" || self.role == "mentee")
      errors.add(:role ," should be either mentor/mentee or coordinator")
    end
  end

  def user_should_exist
    if !User.exists?(self.user_id)
      errors.add("User" ," who is enrolling should exist")
    end
  end

  def schema_should_exist
    if !Scheme.exists?(self.scheme_id)
      errors.add("Schema" ," should exist to be able to enroll in it")
    end
  end

end
