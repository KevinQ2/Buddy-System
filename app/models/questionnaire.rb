class Questionnaire < ApplicationRecord

  validates :name, presence: true
  validates :description, presence: true

  has_many :questions, dependent: :destroy

  has_many :answers, dependent: :destroy
  belongs_to :scheme, optional: true

  validates :name, presence: true, length: { minimum: 5 , maximum:20}
  validates :description, presence: true, :length => {:minimum => 10}
  validates :scheme_id, presence: true, :numericality => true



end
