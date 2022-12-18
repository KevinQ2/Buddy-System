require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    # for create
    @before_user = User.new({username: 'george.wellington@kcl.ac.uk'})

    # for update
    @user = User.new({username: 'george.wellington@kcl.ac.uk', first_name: 'george', last_name: 'wellington', password: 'mypassword'})
  end

  # default validation
  test "@before_user should be valid within the 'create' context" do
    assert @before_user.valid?(:create)
  end

  test "@before_user should not be valid within of the 'self_update' context" do
    assert_not @before_user.valid?(:self_update)
  end

  test "@user should be valid within the 'create' context" do
    assert @user.valid?(:create)
  end

  test "@user should be valid within the 'self_update' context" do
    assert @user.valid?(:self_update)
  end

  # before create tests
  test "first name should be autofilled within the 'create' context" do
    @user.save(context: :create)
    assert_equal "george", @user.first_name
  end

  test "last name should be autofilled within the 'create' context" do
    @user.save(context: :create)
    assert_equal "wellington", @user.last_name
  end

  test "password should be random within the 'create' context" do
    # randomisation is in alphanumeric, '!' is non-alphanumeric
    @user.password = "!" * 6
    @user.save(context: :create)
    assert_not_equal "!" * 6, @user.password
  end

  # username tests
  test "username should not be blank" do
    @user.username = ""
    assert_not @user.valid?
  end

  test "username should be in a 'first.last@kcl.ac.uk' format" do
    @user.username = "george.wellington@kcl.ac.u"
    assert_not @user.valid?
  end

  test "username should be unique and non-case sensitive" do
    duplicate_user = @user.dup

    @user.username = "george.wellington@kcl.ac.uk"
    duplicate_user.username = "George.wellington@kcl.ac.uk"

    @user.save
    assert_not duplicate_user.valid?
  end

  # first_name tests
  test "first name should not be blank upon updating" do
    @user.first_name = ""
    assert_not @user.valid?(:self_update)
  end

  test "first name should not be less than 2 characters upon updating" do
    @user.first_name = "a"
    assert_not @user.valid?(:self_update)
  end

  test "first name should not exceed 30 characters upon updating" do
    @user.first_name = "a" * 31
    assert_not @user.valid?(:self_update)
  end

  test "first name of 2 characters should be valid upon updating" do
    @user.first_name = "a" * 2
    assert @user.valid?(:self_update)
  end

  test "first name 30 characters should be valid upon updating" do
    @user.first_name = "a" * 30
    assert @user.valid?(:self_update)
  end

  # last_name tests
  test "last name should not be blank upon updating" do
    @user.last_name = ""
    assert_not @user.valid?(:self_update)
  end

  test "last name should not be less than 2 characters upon updating" do
    @user.last_name = "a"
    assert_not @user.valid?(:self_update)
  end

  test "last name should not exceed 30 characters upon updating" do
    @user.last_name = "a" * 31
    assert_not @user.valid?(:self_update)
  end

  test "last name of 2 characters should be valid upon updating" do
    @user.last_name = "a" * 2
    assert @user.valid?(:self_update)
  end

  test "last name 30 characters should be valid upon updating" do
    @user.last_name = "a" * 30
    assert @user.valid?(:self_update)
  end

  # password tests
  test "password should not be blank" do
    @user.password = @user.password_confirmation = ""
    assert_not @user.valid?(:change_password)
  end

  test "password should not be less than 6 characters" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?(:change_password)
  end

  test "password should not exceed 30 characters" do
    @user.password = @user.password_confirmation = "a" * 31
    assert_not @user.valid?(:change_password)
  end

  test "password of 6 characters should be valid upon changing password" do
    @user.password = @user.password_confirmation = "a" * 6
    assert @user.valid?(:change_password)
  end

  test "password of 30 characters should be valid upon changing password" do
    @user.password = @user.password_confirmation = "a" * 30
    assert @user.valid?(:change_password)
  end

  test "password confirmation should match password upon changing password" do
    @user.password = "differentpassword"
    @user.password_confirmation = "mismatchpassword"
    assert_not @user.valid?(:change_password)
  end
end
