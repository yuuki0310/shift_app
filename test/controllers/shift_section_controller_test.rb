require 'test_helper'

class ShiftSectionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get shift_section_index_url
    assert_response :success
  end

  test "should get create" do
    get shift_section_create_url
    assert_response :success
  end

end
