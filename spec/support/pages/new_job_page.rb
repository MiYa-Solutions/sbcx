class NewJobPage < SbcxPage
  set_url '/service_calls/new'
  set_url_matcher /.\/service_calls\/new/

  element :email, 'input#service_call_email'
  element :address1, 'input#service_call_address1'
  element :provider_select, 'select#service_call_provider_id'
  element :customer_quick_select, 'input#service_call_customer_name'
  element :customer_list, 'ul#ui-id-1'

  element :create_btn, 'input#service_call_create_btn'

  def create_job(options = {})
    the_email = options[:email] || 'test_aff@test.int'
    the_prov = options[:provider_name] || 'Me'
    cus_search = options[:customer_search] || 'Test Cus'
    the_address1 = options[:address1] || 'Test Address1'
    cus_name = options[:customer_name] || 'Test Cus'

    email.set the_email
    provider_select.select the_prov
    fill_in_autocomplete(customer_quick_select, cus_search, select: cus_name)
    address1.native.double_click
    address1.native.set(the_address1)
    # address1.native.send_keys(*the_address1.chars)

    create_btn.click
  end


end