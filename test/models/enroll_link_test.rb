require 'test_helper'

class EnrollLinkTest < ActiveSupport::TestCase
  def setup
    @test = EnrollLink.new({
      mentee_link: "http://127.0.0.1:3000/mentee/"+schemes(:one).id+"/"+SecureRandom.hex(25),
      mentor_link: "http://127.0.0.1:3000/mentor/"+schemes(:one).id+"/"+SecureRandom.hex(25),
      scheme_id: schemes(:one).id
    })
  end

  # default validation
  test "@test should be valid with all correct fields" do
    assert @test.save.valid?
  end

  test "enroll link should not be valid for non existent scheme" do
    @test.scheme_id = 500
    assert_not @test.save.valid?
  end

  test "enroll link should not be the same for different scheme" do
    @test2 = EnrollLink.new({
      mentee_link: @test.mentee_link,
      mentor_link: @test.mentor_link,
      scheme_id: schemes(:two).id
    })
    assert_not @test2.save.valid?
  end

  test "scheme should not have two records of enroll link" do
    @test2 = EnrollLink.new({
      mentee_link: "http://127.0.0.1:3000/mentee/"+schemes(:one).id+"/"+SecureRandom.hex(25),
      mentor_link: "http://127.0.0.1:3000/mentor/"+schemes(:one).id+"/"+SecureRandom.hex(25),
      scheme_id: schemes(:one).id
    })
    assert_not @test2.save.valid?
  end

end
