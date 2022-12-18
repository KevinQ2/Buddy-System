require 'test_helper'

class MailingListTest < ActiveSupport::TestCase
    
    def setup
        @email = MailingList.new(email: "test@gmail.com")
        @email.save

        @upperCaseEmail = MailingList.new(email: "TEST2@gmail.com")
        @upperCaseEmail.save
    end

    test "email should be unique" do
        notUniqueEmail = @email.dup 
        assert_not notUniqueEmail.valid?
    end

    # Currently does not matter the cases of the emails
   # test "email should be downcase" do
   #     assert @upperCaseEmail.email == @upperCaseEmail.email.downcase
   # end


end
