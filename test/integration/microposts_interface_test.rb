require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:przemek)
  end
  
  test "micropost interface" do
    post login_url params: { session: { email: "przemek.prokopczuk1@gmail.com",
                                        password: 'password'} }
    get root_path
    assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: ""} }
    end
    assert_select 'div#error_explanation'
    # Valid submission
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: "content" } }
    end
    assert_redirected_to root_url
    follow_redirect!
    # Delete post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
  end
end
