class User < ApplicationRecord


  has_many :reported_users, foreign_key: :reporter, class_name: 'Report'
  has_many :reportees, through: :reported_users


  has_many :reporting_users, foreign_key: :reportee, class_name: 'Report'
  has_many :reporters, through: :reporting_users


  has_many :enroll_ins, dependent: :destroy
  has_many :answers, dependent: :destroy

  #has_many :mentors, :class_name =>"Match", foreign_key: "match_mentor_id", dependent: :destroy
  #has_many :mentee, :class_name =>"Match", foreign_key: "match_mentee_id", dependent: :destroy

  require 'bcrypt'

  has_secure_password

  before_validation {self.username.downcase!}

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true, length: { minimum: 2 , maximum:30}, on: [:self_update]
  validates :last_name, presence: true, length: { minimum: 2 , maximum:30}, on: [:self_update]
  validates :password, presence: true, length: { minimum: 6 , maximum:30}, on: [:change_password]

  def User.digest(passphrase)
  #From https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(passphrase, cost: cost)
  end



end
