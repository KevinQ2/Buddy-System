# require 'test_helper'
#
# class AdminProfilesControllerTest < ActionDispatch::IntegrationTest
#   # Access tests
#   # show tests
#   test "GET show should work when logged in as admin" do
#     admin = admins(:superadmin)
#     admin_login_as(admin)
#     get admin_profile_path
#     assert_response :success
#   end
#
#   test "GET show should not work when not logged in as admin" do
#     get admin_profile_path
#     assert_redirected_to admin_login_path
#   end
#
#   # edit tests
#   test "GET edit should work when logged in as admin" do
#     admin = admins(:superadmin)
#     admin_login_as(admin)
#     get admin_profile_path
#     assert_response :success
#   end
#
#   test "GET edit should not work when not logged in as admin" do
#     get admin_profile_path
#     assert_redirected_to admin_login_path
#   end
#
#   # edit_password tests
#   test "GET edit_password should work when logged in as admin" do
#     admin = admins(:superadmin)
#     admin_login_as(admin)
#     get edit_admin_profile_path
#     assert_response :success
#   end
#
#   test "GET edit_password should not work when not logged in as admin" do
#     get admin_profile_change_password_path
#     assert_redirected_to admin_login_path
#   end
#
#
#   # Data processing tests
#   # update_profile tests
#   test "PATCH update should work with valid data when logged in as admin" do
#     admin = admins(:superadmin)
#     admin_login_as(admin)
#
#     new_first_name = "john"
#     new_last_name = "doe"
#
#     assert_no_difference('Admin.count') do
#       patch edit_admin_profile_path, params: { admin: {
#         first_name: new_first_name,
#         last_name: new_last_name
#       }
#     }
#     end
#
#     assert_redirected_to admin_profile_path
#
#     admin.reload
#     assert_equal new_first_name, admin.first_name
#     assert_equal new_last_name, admin.last_name
#   end
#
#   test "PATCH update should not work with valid data when not logged in as admin" do
#     admin = admins(:superadmin)
#
#     old_first_name = admin.first_name
#     old_last_name = admin.last_name
#     new_first_name = "john"
#     new_last_name = "doe"
#
#     assert_no_difference('Admin.count') do
#       patch edit_admin_profile_path, params: { admin: {
#         first_name: new_first_name,
#         last_name: new_last_name
#       }
#     }
#     end
#
#     assert_redirected_to admin_login_path
#
#     admin.reload
#     assert_equal old_first_name, admin.first_name
#     assert_equal old_last_name, admin.last_name
#   end
#
#   test "PATCH update should not work with invalid data" do
#     admin = admins(:superadmin)
#     admin_login_as(admin)
#
#     old_first_name = admin.first_name
#     old_last_name = admin.last_name
#
#     new_first_name = "j"
#     new_last_name = "d"
#
#     assert_no_difference('Admin.count') do
#       patch edit_admin_profile_path, params: { admin: {
#         first_name: new_first_name,
#         last_name: new_last_name
#       }
#     }
#     end
#
#     assert_template :"admin_profiles/_error_admin"
#
#     admin.reload
#     assert_equal old_first_name, admin.first_name
#     assert_equal old_last_name, admin.last_name
#   end
#
#   test "PATCH update should only update first and last name" do
#     admin = admins(:superadmin)
#     admin_login_as(admin)
#
#     old_username = admin.username
#     old_password = admin.password_digest
#     old_admin_level = admin.admin_level
#
#     new_username = "new.username@kcl.ac.uk"
#     new_first_name = "john"
#     new_last_name = "addison"
#     new_password = "newpassword123"
#     new_admin_level = 2
#
#     assert_no_difference('Admin.count') do
#       patch edit_admin_profile_path, params: { admin: {
#         username: new_username,
#         first_name: new_first_name,
#         last_name: new_last_name,
#         password: new_password,
#         password_confirmation: new_password,
#         admin_level: new_admin_level
#       }
#     }
#     end
#
#     assert_redirected_to admin_profile_path
#
#     admin.reload
#     assert_equal old_username, admin.username
#     assert_equal new_first_name, admin.first_name
#     assert_equal new_last_name, admin.last_name
#     assert_equal old_password, admin.password_digest
#     assert_equal old_admin_level, admin.admin_level
#   end
#
#   # update_password tests
#   test "PATCH update_password should work with valid data when logged in as admin" do
#     admin = admins(:superadmin)
#     admin_login_as(admin)
#
#     new_password = "newpassword123"
#
#     assert_no_difference('Admin.count') do
#       patch admin_profile_change_password_path, params: { admin: {
#         password: new_password,
#         password_confirmation: new_password
#       }
#     }
#     end
#
#     assert_redirected_to admin_profile_path
#
#     admin.reload
#     assert_equal BCrypt::Password.new(admin.password_digest), new_password
#   end
#
#   test "PATCH update_password should not work with valid data when not logged in as admin" do
#     admin = admins(:superadmin)
#
#     old_password = admin.password_digest
#     new_password = "newpassword123"
#
#     assert_no_difference('Admin.count') do
#       patch admin_profile_change_password_path, params: { admin: {
#         password: new_password,
#         password_confirmation: new_password
#       }
#     }
#     end
#
#     assert_redirected_to admin_login_path
#
#     admin.reload
#     assert_equal admin.password_digest, old_password
#   end
#
#   test "PATCH update_password should not work with invalid data" do
#     admin = admins(:superadmin)
#     admin_login_as(admin)
#
#     old_password = admin.password_digest
#     new_password = "a"
#
#     assert_no_difference('Admin.count') do
#       patch admin_profile_change_password_path, params: { admin: {
#         password: new_password,
#         password_confirmation: new_password
#       }
#     }
#     end
#
#     assert_template :"admin_profiles/_error_admin"
#
#     admin.reload
#     assert_equal admin.password_digest, old_password
#   end
#
#   test "PATCH update_password should only update password" do
#     admin = admins(:superadmin)
#     admin_login_as(admin)
#
#     old_username = admin.username
#     old_first_name = admin.first_name
#     old_last_name = admin.last_name
#     old_admin_level = admin.admin_level
#
#     new_username = "new.username@kcl.ac.uk"
#     new_first_name = "john"
#     new_last_name = "addison"
#     new_password = "newpassword123"
#     new_admin_level = 2
#
#     assert_no_difference('Admin.count') do
#       patch admin_profile_change_password_path, params: { admin: {
#         username: new_username,
#         first_name: new_first_name,
#         last_name: new_last_name,
#         password: new_password,
#         password_confirmation: new_password,
#         admin_level: new_admin_level
#       }
#     }
#     end
#
#     assert_redirected_to admin_profile_path
#
#     admin.reload
#     assert_equal old_username, admin.username
#     assert_equal old_first_name, admin.first_name
#     assert_equal old_last_name, admin.last_name
#     assert_equal BCrypt::Password.new(admin.password_digest), new_password
#     assert_equal old_admin_level, admin.admin_level
#   end
#
# end
