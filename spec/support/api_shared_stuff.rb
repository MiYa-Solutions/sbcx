shared_context 'api' do
  def api_sign_in(user, options = {})
    post 'api/v1/sign_in',
         { user: { email: user.email, password: 'SbcxTest123' }, format: :json },
         { 'Content-Type' => 'application/json',
           'Accept'       => 'application/json' }
  end
end