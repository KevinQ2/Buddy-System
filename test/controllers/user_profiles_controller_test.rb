require 'test_helper'

class UserProfilesControllerTest < ActionDispatch::IntegrationTest
  # Access tests
  # show tests
  test "GET show should work when logged in as user" do
    user = users(:one)
    user_login_as(user)
    get user_profile_path
    assert_response :success
  end

  test "GET show should not work when not logged in as user" do
    get user_profile_path
    assert_redirected_to user_login_path
  end

  # edit tests
  test "GET edit should work when logged in as user" do
    user = users(:one)
    user_login_as(user)
    get user_profile_path
    assert_response :success
  end

  test "GET edit should not work when not logged in as user" do
    get user_profile_path
    assert_redirected_to user_login_path
  end

  # edit_password tests
  test "GET edit_password should work when logged in as user" do
    user = users(:one)
    user_login_as(user)
    get edit_user_profile_path
    assert_response :success
  end

  test "GET edit_password should not work when not logged in as user" do
    get user_profile_change_password_path
    assert_redirected_to user_login_path
  end


  # Data processing tests
  # update_profile tests
  test "PATCH update should work with valid data when logged in as user" do
    user = users(:one)
    user_login_as(user)

    new_first_name = "john"
    new_last_name = "doe"

    assert_no_difference('User.count') do
      patch edit_user_profile_path, params: { user: {
        first_name: new_first_name,
        last_name: new_last_name
      }
    }
    end

    assert_redirected_to user_profile_path

    user.reload
    assert_equal new_first_name, user.first_name
    assert_equal new_last_name, user.last_name
  end

  test "PATCH update should not work with valid data when not logged in as user" do
    user = users(:one)

    old_first_name = user.first_name
    old_last_name = user.last_name
    new_first_name = "john"
    new_last_name = "doe"

    assert_no_difference('User.count') do
      patch edit_user_profile_path, params: { user: {
        first_name: new_first_name,
        last_name: new_last_name
      }
    }
    end

    assert_redirected_to user_login_path

    user.reload
    assert_equal old_first_name, user.first_name
    assert_equal old_last_name, user.last_name
  end

  test "PATCH update should not work with invalid data" do
    user = users(:one)
    user_login_as(user)

    old_first_name = user.first_name
    old_last_name = user.last_name

    new_first_name = "j"
    new_last_name = "d"

    assert_no_difference('User.count') do
      patch edit_user_profile_path, params: { user: {
        first_name: new_first_name,
        last_name: new_last_name
      }
    }
    end

    assert_template :"user_profiles/_error_user"

    user.reload
    assert_equal old_first_name, user.first_name
    assert_equal old_last_name, user.last_name
  end

  test "PATCH update should only update first and last name" do
    user = users(:one)
    user_login_as(user)

    old_username = user.username
    old_password = user.password_digest


    new_username = "new.username@kcl.ac.uk"
    new_first_name = "john"
    new_last_name = "addison"
    new_password = "newpassword123"


    assert_no_difference('User.count') do
      patch edit_user_profile_path, params: { user: {
        username: new_username,
        first_name: new_first_name,
        last_name: new_last_name,
        password: new_password,
        password_confirmation: new_password,
      }
    }
    end

    assert_redirected_to user_profile_path

    user.reload
    assert_equal old_username, user.username
    assert_equal new_first_name, user.first_name
    assert_equal new_last_name, user.last_name
    assert_equal old_password, user.password_digest
  end

  # update_password tests
  test "PATCH update_password should work with valid data when logged in as user" do
    user = users(:one)
    user_login_as(user)

    new_password = "newpassword123"

    assert_no_difference('User.count') do
      patch user_profile_change_password_path, params: { user: {
        password: new_password,
        password_confirmation: new_password
      }
    }
    end

    assert_redirected_to user_profile_path

    user.reload
    assert_equal BCrypt::Password.new(user.password_digest), new_password
  end

  test "PATCH update_password should not work with valid data when not logged in as user" do
    user = users(:one)

    old_password = user.password_digest
    new_password = "newpassword123"

    assert_no_difference('User.count') do
      patch user_profile_change_password_path, params: { user: {
        password: new_password,
        password_confirmation: new_password
      }
    }
    end

    assert_redirected_to user_login_path

    user.reload
    assert_equal user.password_digest, old_password
  end

  test "PATCH update_password should not work with invalid data" do
    user = users(:one)
    user_login_as(user)

    old_password = user.password_digest
    new_password = "a"

    assert_no_difference('User.count') do
      patch user_profile_change_password_path, params: { user: {
        password: new_password,
        password_confirmation: new_password
      }
    }
    end

    assert_template :"user_profiles/_error_user"

    user.reload
    assert_equal user.password_digest, old_password
  end

  test "PATCH update_password should only update password" do
    user = users(:one)
    user_login_as(user)

    old_username = user.username
    old_first_name = user.first_name
    old_last_name = user.last_name


    new_username = "new.username@kcl.ac.uk"
    new_first_name = "john"
    new_last_name = "addison"
    new_password = "newpassword123"

    assert_no_difference('User.count') do
      patch user_profile_change_password_path, params: { user: {
        username: new_username,
        first_name: new_first_name,
        last_name: new_last_name,
        password: new_password,
        password_confirmation: new_password,

      }
    }
    end

    assert_redirected_to user_profile_path

    user.reload
    assert_equal old_username, user.username
    assert_equal old_first_name, user.first_name
    assert_equal old_last_name, user.last_name
    assert_equal BCrypt::Password.new(user.password_digest), new_password

  end

end
