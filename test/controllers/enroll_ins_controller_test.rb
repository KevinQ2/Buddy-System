require 'test_helper'

class EnrollInsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @scheme = schemes(:one)

  end

  test "should get index" do
    get enroll_ins_path
    assert_response :success
  end

  test "should get mentor's registration for existent scheme" do
    get enroll_mentor_path(@scheme.id)
    assert_response :success
  end

  test "should be redirected mentor's registration for non existent scheme" do
    get enroll_mentor_path(1000)
    assert_response :redirect
  end

  test "should get mentee's registration for existent scheme" do
    get enroll_mentee_path(@scheme.id)
    assert_response :success
  end

  test "should be redirected mentee's registration for non existent scheme" do
    get enroll_mentee_path(1000)
    assert_response :redirect
  end

  test "should get who is enrolled in particular scheme" do
    get show_scheme_enrolled_path(@scheme.id)
    assert_response :success
  end

  test "should not get who is enrolled in non existent scheme" do
    get show_scheme_enrolled_path(1000)
    assert_response :redirect
  end

  
end
