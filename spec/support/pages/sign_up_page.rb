class SignUpPage < SitePrism::Page
  set_url '/users/sign_up'
  set_url_matcher /.\/users\/sign_up/

  element :email, 'input#user_email'
  element :password, 'input#user_password'
  element :pwd_confirmation, 'input#user_password_confirmation'
  element :first_name, 'input#user_first_name'
  element :last_name, 'input#user_last_name'
  element :user_phone, 'input#user_phone'
  element :user_mobile, 'input#user_mobile_phone'
  element :user_work_phone, 'input#user_work_phone'
  element :org_name, 'input#user_organization_attributes_name'
  element :org_email, 'input#user_organization_attributes_email'
  element :industry_select, 'select#user_organization_attributes_industry'
  element :other_industry, 'input#user_organization_attributes_other_industry'
  element :sign_up_btn, 'input#sign_up_btn'

  element :success_flash, 'div.alert-success'
  element :error_flash, 'div.alert-error'


  def sign_up(options = {})
    user_email    = options[:email] || 'signup_test@test.com'
    user_fname    = options[:first_name] || 'signup_test@test.com'
    user_lname    = options[:last_name] || 'signup_test@test.com'
    user_pwd      = options[:password] || '123456'
    user_pwd_conf = options[:password_conf] || '123456'
    org           = options[:org_name] || 'Sign Up Test Org'
    the_org_email = options[:org_email] || 'signuporg@test.int'
    industry      = options[:industry] || 'Locksmith'

    email.set user_email
    password.set user_pwd
    pwd_confirmation.set user_pwd_conf
    first_name.set user_fname
    last_name.set user_lname
    org_name.set org
    org_email.set the_org_email
    industry_select.select(industry)

    sign_up_btn.click
    # click_on('Sign up')
  end

end