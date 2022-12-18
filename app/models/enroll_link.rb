class EnrollLink < ApplicationRecord
    belongs_to :scheme

    validate :scheme_should_exist

    validates :mentee_link, uniqueness: true
    validates :mentor_link, uniqueness: true
    validates :scheme_id, presence: true
    validates :mentee_link, presence: true
    validates :mentor_link, presence: true

    # Generate unique non-guessable link for enroll in
    #before_create do
    #    self.link = self.scheme_id.to_s+SecureRandom.hex(25)
    #end

    # Scheme should exist for the link
    def scheme_should_exist
        if !Scheme.exists?(id: self.scheme_id)
            errors.add(:scheme_id ," should exists")
        end
    end

end
