require 'test_helper'

class SchemeTest < ActiveSupport::TestCase
  def setup
    @scheme = schemes(:one)
    @test = Scheme.create({
      title: "Testastastest",
      description: "dedesciptdesciptdesciptdesciptdesciptdesciptscipt",
      startDate:"2021-10-10",
      endDate: "2021-10-21",
      codeOfConduct: "Codeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conduct"
      })

      @testData = {
        title: "Testastastest",
        description: "dedesciptdesciptdesciptdesciptdesciptdesciptscipt",
        startDate:"2021-01-10",
        endDate: "2021-10-21",
        codeOfConduct: "Codeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conduct"
      }

      @testData2 = {
        title: "Testastastest",
        description: "dedesciptdesciptdesciptdesciptdesciptdesciptscipt",
        startDate:"2021-10-10",
        endDate: "2021-09-21",
        codeOfConduct: "Codeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conductCodeofconduct codeof conduct"
      }
  end

  test "startDate should not be in the past" do
    assert @test.valid?
    assert_not test2 = Scheme.create(@testData).valid?
  end

  test "endDate should be later than startDate" do
    assert @test.valid?
    assert_not test2 = Scheme.create(@testData2).valid?
  end

  test "title should be at least 4 char" do
    assert @test.valid?
    @test.title = "Tes"
    assert_not @test.valid?
  end

  test "description should be at least 10 char" do
    assert @test.valid?
    @test.description = "Test"
    assert_not @test.valid?
  end

  test "code of conduct should be at least 50 char" do
    assert @test.valid?
    @test.description = "Test"
    assert_not @test.valid?
  end

end
