require 'test_helper'

class EnrollInMailingTest < ActiveSupport::TestCase

  setup do
    @email = enroll_in_mailings(:one)
  end


  test "enroll_in_mailing with valid data" do
    enroll_in_mailing = EnrollInMailing.new(email: @email)
    assert enroll_in_mailing.valid?
  end

  test "enroll_in_mailing with valid data, uniqueness" do
    enroll_in_mailing = EnrollInMailing.create(email: @email)
    enroll_in_mailing2 = EnrollInMailing.new(email: @email)
    assert !enroll_in_mailing2.valid?
  end

  test "enroll_in_mailing with invalid data, no data" do
    enroll_in_mailing = EnrollInMailing.new()
    assert !enroll_in_mailing.valid?
  end

end
