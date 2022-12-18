require 'test_helper'

class EnrollInTest < ActiveSupport::TestCase

  def setup
    @test = EnrollIn.new({role: "coordinator", user_id: users(:one).id, user_id: schemes(:one).id, matched: false})
  end

  # default validation
  test "@test should be valid with all correct fields" do
    assert @test.save.valid?
  end

  test "enroll in with role not mentee/mentor/coordinator should not be valid" do
    @test.role = "admin"
    assert_not @test.save.valid?
  end

  test "enroll in with non existent user id should not be valid" do
    @test.user_id = 10000
    assert_not @test.save.valid?
  end

  test "enroll in with non existent scheme id should not be valid" do
    @test.scheme_id = 10000
    assert_not @test.save.valid?
  end

  test "when user enroll his matched field should be false" do
    @test.save
    assert_not @test.matched
  end

  test "enroll in with role mentor should have mentees number" do
    @test.role = "mentor"
    @test.mentees_number = 1
    assert @test.save.valid?
  end

  test "enroll in with role mentor should not be valid without mentees number or with <=0" do
    @test.role = "mentor"
    assert_not @test.save.valid?
    @test.mentees_number = 0
    assert_not @test.save.valid?
  end

  test "user should not be able to enroll twice in the same schema" do
    assert @test.save.valid?
    assert_not EnrollIn.create({role: "coordinator", user_id: users(:one).id, user_id: schemes(:one).id, matched: false}).valid?
  end


end
