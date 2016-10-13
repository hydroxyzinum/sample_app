require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin     = users(:przemek)
    @non_admin = users(:wayne)
  end
  
  test "index including pagination and delete links" do
    post login_path params: { session: { email: @admin.email,
                                         password: 'password'} }
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    post login_path params: { session: { email: @non_admin.email,
                                         password: 'password'} }
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
  
end
