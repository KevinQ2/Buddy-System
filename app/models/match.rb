class Match < ApplicationRecord



  belongs_to :mentor, :class_name=> "User", foreign_key: "mentor_id"
  belongs_to :mentee, :class_name=> "User", foreign_key: "mentee_id"
  belongs_to :scheme


  validates :mentor_id, presence: true, :numericality => true
  validates :mentee_id, presence: true, :numericality => true
  validates :scheme_id, presence: true, :numericality => true




end
