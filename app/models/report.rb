class Report < ApplicationRecord
  belongs_to :reporter, class_name: 'User'
  belongs_to :reportee, class_name: 'User'
  validates :reporter, presence: true
  validates :reportee, presence: true
  validates :message, presence: true, length: { minimum: 10, message: " - Your message is too short, must be 10 characters or more." }
  validates :reportee, uniqueness: { scope: :reporter, message: " - You already have a pending report for this user." }
end
