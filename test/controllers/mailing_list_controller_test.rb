require 'test_helper'

class MailingListControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    get mailing_list_index_path
    assert_response :success
  end

  test "should get import" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    post import_mailing_list_index_path
    assert_redirected_to(mailing_list_index_url)
  end

  test "should delete all data in Mailig list" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    email = MailingList.create(email: "bla.bla@kcl.ac.uk")
    email.save
    email2 = MailingList.create(email: "test@kcl.ac.uk")
    email2.save
    assert (MailingList.count == 2)
    delete destroy_all_mailing_list_index_path
    assert (MailingList.count == 0)
  end

  test "should delete a single email" do
    admin = admins(:superadmin)
    admin_login_as(admin)
    email = MailingList.create(email: "bla.bla@kcl.ac.uk")
    email.save
    email2 = MailingList.create(email: "test@kcl.ac.uk")
    email2.save
    assert (MailingList.count == 2)
    delete mailing_list_path(email.id)
    assert (MailingList.count == 1)
  end


end
