class Question < ApplicationRecord
  belongs_to :questionnaire

  validates :questionnaire_id, presence: true, :numericality => true
  validates :description, presence: true, :length => {:minimum => 2}
  validates :options, presence: true, :length => {:minimum => 2}
  validates :match, presence: false

end
