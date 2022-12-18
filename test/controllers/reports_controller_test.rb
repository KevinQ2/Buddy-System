require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @non_admin = users(:one)
    @admin = admins(:averageadmin)
  end


  test "report when not logged in" do
    get reports_path
    assert_redirected_to user_login_path
  end

  test "report when logged in and not admin" do
    post user_login_path, params: { session: { username: @non_admin.username,
		password: @non_admin.password_digest} }
    get reports_path
    assert_redirected_to '/reports/new'
  end

  test "report when logged in and admin" do
    post admin_login_path, params: { session: { username: @admin.username,
		password: @admin.password_digest} }
    get reports_path
    assert_response :success
  end

  test "create report" do
    @non_admin2 = users(:two)
    post user_login_path, params: { session: { username: @non_admin.username,
		password: @non_admin.password_digest} }
    assert_difference("Report.count", 1) do
      post reports_path, params: { report: {reporter: @non_admin, reportee: @non_admin2, message: "testuser test report message"}}
    end

  end


  test "delete" do
    post admin_login_path, params: { session: { username: @admin.username,
		password_digest: @admin.password_digest} }
    test_report = reports(:two)
    assert_difference("Report.count", -1) do
      delete report_path(test_report)
    end
    assert_redirected_to reports_path

  end


end
