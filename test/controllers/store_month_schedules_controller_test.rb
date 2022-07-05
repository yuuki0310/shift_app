require 'test_helper'

class StoreMonthSchedulesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get store_month_schedules_new_url
    assert_response :success
  end

  test "should get create" do
    get store_month_schedules_create_url
    assert_response :success
  end

end
