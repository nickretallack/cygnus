require 'test_helper'

class MessageCellTest < Cell::TestCase
  test "show" do
    html = cell("message").(:show)
    assert html.match /<p>/
  end


end
