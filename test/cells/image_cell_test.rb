require 'test_helper'

class ImageCellTest < Cell::TestCase
  test "show" do
    html = cell("image").(:show)
    assert html.match /<p>/
  end


end
