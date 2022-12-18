class Answer < ApplicationRecord


    
  validates :questionnaire_id, presence: true, :numericality => true
  validates :user_id, presence: true
  validates :scheme_id, presence: true
  validates :user_answers, presence: true, :length => {:minimum => 1}
  
  belongs_to :user


end
