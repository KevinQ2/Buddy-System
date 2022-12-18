require 'test_helper'

class SchemeControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    @scheme = schemes(:one)
    @scheme2 = schemes(:two)
  end

  test "should get index" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    get schemes_path
    assert_response :success
  end

  test "should get show scheme" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    get scheme_path(@scheme)
    assert_response :success
  end

  test "should get scheme's code of conduct" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    get scheme_path(@scheme.id)+"/codeofconduct"
    assert_response :success
  end

  test "should get new scheme" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    get new_scheme_path
    assert_response :success
  end

  test "should create scheme" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    assert_difference("Scheme.count", 1) do
      post schemes_path, params: {scheme: {
        title: "Testastastest", 
        description: "dedesciptdesciptdesciptdesciptdesciptdesciptscipt",
        startDate:"2021-10-10",
        endDate: "2021-10-21",
        codeOfConduct: "Codeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conduct"
        }}
    end
    assert_response :success
    @scheme.destroy
  end

  test "should edit scheme" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    get edit_scheme_path(@scheme2.id)
    assert_response :success
  end
  # If scheme has started, it should not be editable and edit page should not be accessible
  test "should not edit scheme as it started" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    get edit_scheme_path(@scheme.id)
    assert_redirected_to(schemes_path)
  end

  # This test is not working at the moment
  test "should update scheme" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    scheme = schemes(:two)
    patch scheme_path(scheme.id), params: {scheme: {
      title: "New testing title", 
      description: "SHOULD BE new description but it isn't a new description just a random fuller",
      startDate:"2021-10-10",
      endDate: "2021-10-21",
      codeOfConduct: "Codeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conduct"
      }}
    assert_redirected_to(scheme_path(scheme))
    assert_equal "New testing title", scheme.reload.title
    assert_equal "SHOULD BE new description but it isn't a new description just a random fuller", scheme.description
  end

end
