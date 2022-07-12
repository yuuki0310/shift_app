require 'test_helper'

class UserUnableSchedulesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get user_unable_schedules_new_url
    assert_response :success
  end

end
