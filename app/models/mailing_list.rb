class MailingList < ApplicationRecord
    require 'csv'
    validates :email, uniqueness: true

    # Create and save emails from file in MailingList table, only unique
    def self.import(file)
        CSV.foreach(file.path, headers: true, :header_converters => lambda { |h| h.try(:downcase)}) do |row|
            MailingList.find_or_create_by row.to_hash
        end
    end

end