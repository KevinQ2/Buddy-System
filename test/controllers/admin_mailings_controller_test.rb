require 'test_helper'

class AdminMailingsControllerTest < ActionDispatch::IntegrationTest
  test "should get communications" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    get communications_path
    assert_response :success
  end

  test "should get mail_list_path" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    get mail_list_path
    assert_response :success
  end

  test "should get mailing_users_path" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    get mail_users_path
    assert_response :success
  end

  test "should get communications email_mailinglist" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    get send_email_mailinglist_path
    # Finish test should be redirected to mail_list_path
    assert_redirected_to(mail_list_path)
  end

  test "should get communications email_mailingusers" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    get send_email_mailingusers_path
    # Finish test should be redirected to mailing_users_path
    assert_redirected_to(mail_users_path)
  end

end
