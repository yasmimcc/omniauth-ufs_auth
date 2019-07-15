module OpenProject::UfsAuth
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_account_login_auth_provider, :partial => 'hooks/login/ufs_auth'
  end
end
