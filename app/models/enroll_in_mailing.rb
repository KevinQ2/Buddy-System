class EnrollInMailing < ApplicationRecord
    require 'csv'
    validates :email, uniqueness: true, presence: true

    # Create and save emails from file in MailingList table, only unique
    def self.import(file)
        CSV.foreach(file.path, headers: true, :header_converters => lambda { |h| h.try(:downcase)}) do |row|
            EnrollInMailing.find_or_create_by row.to_hash
        end
    end

end
