class NewAffiliatePage < SbcxPage
  set_url '/affiliates/new'
  set_url_matcher /.\/affiliates\/new/

  element :email, 'input#affiliate_email'
  element :name, 'input#affiliate_name'
  element :provider_role, 'input#affiliate_organization_role_ids_1'
  element :subcon_role, 'input#affiliate_organization_role_ids_2'
  element :success_flash, 'div.alert-success'
  element :notice_flash, 'div.alert-notice'
  element :error_flash, 'div.alert-error'
  element :create_btn, 'input#create_affiliate_btn'

  def create_affiliate(options = {})
    the_email = options[:email] || 'test_aff@test.int'
    the_name  = options[:name] || 'Test Affiliate'
    prov_role = options[:provider_role] || '1'
    sub_role  = options[:subcon_role] || '1'

    email.set the_email
    name.set the_name
    provider_role.set prov_role
    subcon_role.set sub_role

    create_btn.click

  end


end