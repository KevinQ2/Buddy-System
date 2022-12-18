require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  # permission depends on if the controller name is included in the admin table's admin_access field
  # Access tests
  # index tests
  test "GET index should work if logged in as an admin with permission" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    get admins_path
    assert_response :success
  end

  test "GET index should not work if not logged in as an admin with permission" do
    get admins_path
    assert_redirected_to login_path

    admin = admins(:averageadmin)
    admin_login_as(admin)
    get admins_path
    assert_redirected_to admin_profile_path
  end

  # show tests
  test "GET show should work if logged in as an admin with permission" do
    admin = admins(:superadmin)
    admin_login_as(admin)

    get admin_path(admin.id)
    assert_response :success
  end

  test "GET show should not work if not logged in as an admin with permission" do
    admin = admins(:averageadmin)

    get admin_path(admin.id)
    assert_redirected_to login_path

    admin_login_as(admin)
    get admin_path(admin.id)
    assert_redirected_to admin_profile_path
  end

  # new tests
  test "GET new should work if logged in as an admin with permission" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    get new_admin_path
    assert_response :success
  end

  test "GET new should not work if not logged in as an admin with permission" do
    get new_admin_path
    assert_redirected_to login_path

    admin = admins(:averageadmin)
    admin_login_as(admin)
    get new_admin_path
    assert_redirected_to admin_profile_path
  end

  # edit tests
  test "GET edit should work if logged in as an admin with permission" do
    admin = admins(:superadmin)
    admin_login_as(admin)

    get edit_admin_path(admin.id)
    assert_response :success
  end

  test "GET edit should not work if not logged in as an admin with permission" do
    admin = admins(:averageadmin)
    get edit_admin_path(admin.id)
    assert_redirected_to login_path

    admin_login_as(admin)
    get edit_admin_path(admin.id)
    assert_redirected_to admin_profile_path
  end

  # delete tests
  test "GET delete should work if logged in as an admin with permission" do
    admin = admins(:superadmin)
    admin_login_as(admin)

    get delete_admin_path(admin.id)
    assert_response :success
  end

  test "GET delete should not work if not logged in as an admin with permission" do
    admin = admins(:averageadmin)
    get delete_admin_path(admin.id)
    assert_redirected_to login_path

    admin_login_as(admin)
    get delete_admin_path(admin.id)
    assert_redirected_to admin_profile_path
  end


  # Data processing tests
  # create tests
  test "POST create should work with valid data if logged in as an admin with permission" do
    admin = admins(:superadmin)
    admin_login_as(admin)

    assert_difference('Admin.count', 1) do
      post new_admin_path, params: { admin: {
        username: "curious.george@kcl.ac.uk"
        }
      }
    end

    assert_redirected_to admins_path
  end

  test "POST create should not work with valid data if not logged in as an admin with permission" do
    assert_no_difference('Admin.count') do
      post new_admin_path, params: { admin: {
        username: "curious.george@kcl.ac.uk",
        admin_access: ["admins"]
        }
      }
    end

    assert_redirected_to login_path


    admin = admins(:averageadmin)
    admin_login_as(admin)

    assert_no_difference('Admin.count') do
      post new_admin_path, params: { admin: {
        username: "curious.george@kcl.ac.uk",
        admin_access: ["admins"]
        }
      }
    end

    assert_redirected_to admin_profile_path
  end

  test "POST create should not work with invalid data" do
    admin = admins(:superadmin)
    admin_login_as(admin)

    assert_no_difference('Admin.count') do
      post new_admin_path, params: { admin: {
        username: "curious",
        admin_access: ["admins"]
        }
      }
    end

    assert_template :"admins/_error_admin"
  end

  # update tests
  test "PATCH update should work with valid data if logged in as an admin with permission" do
    admin = admins(:superadmin)
    admin_login_as(admin)

    new_admin_access = ["admins"]

    assert_no_difference('Admin.count') do
      patch edit_admin_path(admin), params: { admin: {
        admin_access: new_admin_access
      }
    }
    end
    flash.alert = admin.errors

    assert_redirected_to admin_path(admin)

    admin.reload
    assert_equal new_admin_access, admin.admin_access

  end

  test "PATCH update should not work with valid data if not logged in as an admin with permission" do
    admin = admins(:averageadmin)

    old_admin_access = admin.admin_access
    new_admin_access = ["admins"]

    assert_no_difference('Admin.count') do
      patch edit_admin_path(admin), params: { admin: {
        admin_access: new_admin_access
      }
    }
    end

    assert_redirected_to login_path

    admin.reload
    assert_equal old_admin_access, admin.admin_access


    admin_login_as(admin)

    assert_no_difference('Admin.count') do
      patch edit_admin_path(admin), params: { admin: {
        admin_access: new_admin_access
      }
    }
    end

    assert_redirected_to admin_profile_path

    admin.reload
    assert_equal old_admin_access, admin.admin_access
  end

  test "PATCH update should not work with invalid data" do
    admin = admins(:superadmin)
    admin_login_as(admin)

    old_admin_access = admin.admin_access
    new_admin_access = 1

    assert_no_difference('Admin.count') do
      patch edit_admin_path(admin), params: { admin: {
        admin_access: new_admin_access
      }
    }
    end

    assert_template :"admins/_error_admin"

    admin.reload
    assert_equal old_admin_access, admin.admin_access
  end

  test "PATCH update should only update admin access" do
    admin = admins(:superadmin)
    admin_login_as(admin)

    old_username = admin.username
    old_first_name = admin.first_name
    old_last_name = admin.last_name
    old_password = admin.password_digest

    new_username = "new.username@kcl.ac.uk"
    new_first_name = "john"
    new_last_name = "addison"
    new_password = "newpassword123"
    new_admin_access = ["admins"]

    assert_no_difference('Admin.count') do
      patch edit_admin_path(admin), params: { admin: {
        username: new_username,
        first_name: new_first_name,
        last_name: new_last_name,
        password: new_password,
        password_confirmation: new_password,
        admin_access: new_admin_access
      }
    }
    end

    assert_redirected_to admin_path(admin)

    admin.reload
    assert_equal old_username, admin.username
    assert_equal old_first_name, admin.first_name
    assert_equal old_last_name, admin.last_name
    assert_equal old_password, admin.password_digest
    assert_equal new_admin_access, admin.admin_access
  end

  # destroy tests
  test "DELETE destroy should remove admin if logged in as an admin with permission" do
    admin = admins(:superadmin)
    admin_login_as(admin)

    assert_difference('Admin.count', -1) do
      delete delete_admin_path(admin)
    end

    assert_redirected_to admins_path
  end

  test "DELETE destroy should not remove admin if not logged in as an admin with permission" do
    admin = admins(:averageadmin)

    assert_no_difference('Admin.count') do
      delete delete_admin_path(admin)
    end

    assert_redirected_to login_path


    admin_login_as(admin)

    assert_no_difference('Admin.count') do
      delete delete_admin_path(admin)
    end

    assert_redirected_to admin_profile_path
  end

end
