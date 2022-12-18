require 'test_helper'

class MatchTest < ActiveSupport::TestCase

  setup do
    @mentor = users(:two)
    @mentee = users(:one)
    @scheme = schemes(:one)
  end


  test "match with valid data" do
    match = Match.new(mentor_id: @mentor.id, mentee_id: @mentee.id, scheme_id: @scheme.id)
    assert match.valid?
  end

  test "match with invalid data, no mentor" do
    match = Match.new(mentee_id: @mentee.id, scheme_id: @scheme.id)
    assert !match.valid?
  end

  test "match with invalid data, no mentee" do
    match = Match.new(mentor_id: @mentor.id, scheme_id: @scheme.id)
    assert !match.valid?
  end

  test "match with invalid data, no scheme" do
    match = Match.new(mentor_id: @mentor.id, mentee_id: @mentee.id)
    assert !match.valid?
  end


  test "match with invalid data, no data" do
    match = Match.new()
    assert !match.valid?
  end

end
