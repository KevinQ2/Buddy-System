require 'test_helper'

class EnrollInMailingsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @scheme = schemes(:one)

  end

  test "should get index" do
    get enroll_in_mailings_path
    assert_response :success
  end

  test "should get schemes mailing path" do
    get enroll_in_mailings_path(@scheme.id)
    assert_response :success
  end

  test "should be redirected non existent schemes mailing path" do
    get enroll_in_mailings_path(1000)
    assert_response :redirect
  end

  test "should get communications email_mailinglist" do
    get send_email_mailinglist_path
    # Finish test should be redirected to communications_path
    assert_redirected_to(communications_path)
  end

end
