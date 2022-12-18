class Admin < ApplicationRecord
  require 'securerandom'
  require 'bcrypt'

  has_secure_password

  before_validation :before_create_actions, on: [:create]
  before_validation {self.username.downcase!}
  before_validation :remove_nils
  before_validation :check_departments
  before_validation :check_schemes

  VALID_USERNAME_REGEX = /\A[\w+\-]+[.][\w+\-]+@kcl.ac.uk/i
  validates :username, presence: true, format: { with: VALID_USERNAME_REGEX, message: "is not in firstname.lastname@kcl.ac.uk format" }, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true, length: { minimum: 2 , maximum:30}, on: [:self_update]
  validates :last_name, presence: true, length: { minimum: 2 , maximum:30}, on: [:self_update]
  validates :password, presence: true, length: { minimum: 6 , maximum:30}, on: [:change_password]
  validates :admin_access, presence: false
  validates :scheme_access,
    :presence => false,
    :inclusion => {:in => ['no schemes', 'assigned schemes', 'assigned departments', 'assigned departments and schemes', 'all schemes'],
    :message => "%{value} is not a valid input"}
  validates :department_ids, presence: false
  validates :scheme_ids, presence: false

  def before_create_actions()
    begin
      # Identify first and last name from username (email)
      names = self.username.split('@')[0].split('.')
      self.first_name = names[0]
      self.last_name = names[1]
    rescue StandardError => e
    end


    # Generates a random password
    self.password = SecureRandom.hex(6)
  end

  # ensure department ids are valid
  def check_departments()
    valid_departments = []

    begin
      self.department_ids.each do |temp|
        if Department.exists?(temp)
          valid_departments.push(temp)
        end
      end
    rescue StandardError => e
    end

    self.department_ids = valid_departments
  end

  # ensure scheme ids are valid
  def check_schemes()
    valid_schemes = []

    begin
      self.scheme_ids.each do |temp|
        if Scheme.exists?(temp)
          valid_schemes.push(temp)
        end
      end
    rescue StandardError => e
    end

    self.scheme_ids = valid_schemes
  end

  def remove_nils()
    if self.admin_access.nil?
      self.admin_access = []
    end

    if self.scheme_ids.nil?
      self.scheme_ids = []
    end

    if self.department_ids.nil?
      self.department_ids = []
    end
  end

  def Admin.digest(passphrase)
  #From https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(passphrase, cost: cost)
  end

end
