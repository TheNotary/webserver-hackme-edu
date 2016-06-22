require 'test_helper'

class TextCorrectionsControllerTest < ActionController::TestCase
  test "should get correct" do
    post :correct, {text: 'sample.  text'}
    assert_response :success
  end

end
