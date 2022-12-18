class AdminTest < ActiveSupport::TestCase
  require 'test_helper'

  def setup
    # for create
    @before_admin = Admin.new({username: 'george.wellington@kcl.ac.uk', admin_access: ["admins"]})

    # for update
    @admin = Admin.new({username: 'george.wellington@kcl.ac.uk', first_name: 'george', last_name: 'wellington', password: 'mypassword', admin_access: ["admins"]})
  end

  # default validation
  test "@before_admin should be valid within the 'create' context" do
    assert @before_admin.valid?(:create)
  end

  test "@before_admin should not be valid within of the 'self_update' context" do
    assert_not @before_admin.valid?(:self_update)
  end

  test "@admin should be valid within the 'create' context" do
    assert @admin.valid?(:create)
  end

  test "@admin should be valid within the 'self_update' context" do
    assert @admin.valid?(:self_update)
  end

  # before create tests
  test "first name should be autofilled within the 'create' context" do
    @admin.save(context: :create)
    assert_equal "george", @admin.first_name
  end

  test "last name should be autofilled within the 'create' context" do
    @admin.save(context: :create)
    assert_equal "wellington", @admin.last_name
  end

  test "password should be random within the 'create' context" do
    # randomisation is in alphanumeric, '!' is non-alphanumeric
    @admin.password = "!" * 6
    @admin.save(context: :create)
    assert_not_equal "!" * 6, @admin.password
  end

  # username tests
  test "username should not be blank" do
    @admin.username = ""
    assert_not @admin.valid?
  end

  test "username should be in a 'first.last@kcl.ac.uk' format" do
    @admin.username = "george.wellington@kcl.ac.u"
    assert_not @admin.valid?
  end

  test "username should be unique and non-case sensitive" do
    duplicate_admin = @admin.dup

    @admin.username = "george.wellington@kcl.ac.uk"
    duplicate_admin.username = "George.wellington@kcl.ac.uk"

    @admin.save
    assert_not duplicate_admin.valid?
  end

  # first_name tests
  test "first name should not be blank upon updating" do
    @admin.first_name = ""
    assert_not @admin.valid?(:self_update)
  end

  test "first name should not be less than 2 characters upon updating" do
    @admin.first_name = "a"
    assert_not @admin.valid?(:self_update)
  end

  test "first name should not exceed 30 characters upon updating" do
    @admin.first_name = "a" * 31
    assert_not @admin.valid?(:self_update)
  end

  test "first name of 2 characters should be valid upon updating" do
    @admin.first_name = "a" * 2
    assert @admin.valid?(:self_update)
  end

  test "first name 30 characters should be valid upon updating" do
    @admin.first_name = "a" * 30
    assert @admin.valid?(:self_update)
  end

  # last_name tests
  test "last name should not be blank upon updating" do
    @admin.last_name = ""
    assert_not @admin.valid?(:self_update)
  end

  test "last name should not be less than 2 characters upon updating" do
    @admin.last_name = "a"
    assert_not @admin.valid?(:self_update)
  end

  test "last name should not exceed 30 characters upon updating" do
    @admin.last_name = "a" * 31
    assert_not @admin.valid?(:self_update)
  end

  test "last name of 2 characters should be valid upon updating" do
    @admin.last_name = "a" * 2
    assert @admin.valid?(:self_update)
  end

  test "last name 30 characters should be valid upon updating" do
    @admin.last_name = "a" * 30
    assert @admin.valid?(:self_update)
  end

  # password tests
  test "password should not be blank" do
    @admin.password = @admin.password_confirmation = ""
    assert_not @admin.valid?(:change_password)
  end

  test "password should not be less than 6 characters" do
    @admin.password = @admin.password_confirmation = "a" * 5
    assert_not @admin.valid?(:change_password)
  end

  test "password should not exceed 30 characters" do
    @admin.password = @admin.password_confirmation = "a" * 31
    assert_not @admin.valid?(:change_password)
  end

  test "password of 6 characters should be valid upon changing password" do
    @admin.password = @admin.password_confirmation = "a" * 6
    assert @admin.valid?(:change_password)
  end

  test "password of 30 characters should be valid upon changing password" do
    @admin.password = @admin.password_confirmation = "a" * 30
    assert @admin.valid?(:change_password)
  end

  test "password confirmation should match password upon changing password" do
    @admin.password = "differentpassword"
    @admin.password_confirmation = "mismatchpassword"
    assert_not @admin.valid?(:change_password)
  end

  # admin_access tests
  test "admin access should not be blank" do
    @admin.admin_access = ""
    assert_not @admin.valid?
  end

  test "admin access should be an array" do
    @admin.admin_access = "a"
    assert_not @admin.valid?
  end

  # scheme_access tests
  test "scheme access should be of a certain value" do
    @admin.admin_access = "no schemes"
    assert @admin.valid?
    @admin.admin_access = "assigned schemes"
    assert @admin.valid?
    @admin.admin_access = "assigned departments"
    assert @admin.valid?
    @admin.admin_access = "assigned departments and schemes"
    assert @admin.valid?
    @admin.admin_access = "all schemes"
    assert @admin.valid?
  end

  #scheme_ids test
  test "scheme ids should be an array of integers" do
    @admin.scheme_access = [1, 2, 3]
    assert @admin.valid?
    @admin.scheme_access = ["a"]
    assert_not @admin.valid?
    @admin.scheme_access = "a"
    assert_not @admin.valid?
  end

  #department_ids test
  test "department ids should be an array of integers" do
    @admin.scheme_access = [1, 2, 3]
    assert @admin.valid?
    @admin.scheme_access = ["a"]
    assert_not @admin.valid?
    @admin.scheme_access = "a"
    assert_not @admin.valid?
  end

end
