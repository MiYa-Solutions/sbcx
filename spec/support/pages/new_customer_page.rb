class NewCustomerPage < SitePrism::Page
  set_url '/customers/new'
  set_url_matcher /.\/customers\/new/

  element :name, 'input#customer_name'
  element :company, 'input#customer_company'
  element :address1, 'input#customer_address1'
  element :address2, 'input#customer_address2'
  element :city, 'input#customer_city'
  element :country, 'select#country'
  element :state, 'select#customer_state'
  element :zip, 'input#customer_zip'
  element :phone, 'input#customer_phone'
  element :mobile_phone, 'input#customer_mobile_phone'
  element :work_phone, 'input#customer_work_phone'
  element :email, 'input#customer_email'
  element :tax, 'input#customer_default_tax'

  element :success_flash, 'div.alert-success'
  element :notice_flash, 'div.alert-notice'
  element :error_flash, 'div.alert-error'
  element :create_btn, 'input#create-customer'

  def create_customer(options = {})
    the_email        = options[:email] || 'test_cus@test.int'
    the_name         = options[:name] || 'Test Customer'
    the_company      = options[:company] || 'Test Customer Company'
    the_address1     = options[:address1] || '23 Test Address1'
    the_address2     = options[:address2] || '23 Test Address2'
    the_city         = options[:city] || 'Test City'
    the_state        = options[:state] || 'NJ'
    the_country      = options[:country] || 'United States'
    the_zip          = options[:zip] || '11111'
    the_phone        = options[:phone] || '212-222-2222'
    the_mobile_phone = options[:mobile_phone] || '212-222-2222'
    the_work_phone   = options[:work_phone] || '212-222-2222'
    the_tax          = options[:tax] || '10'

    name.set the_name
    company.set the_company
    address1.set the_address1
    address2.set the_address2
    city.set the_city
    state.set the_state
    country.set the_country
    zip.set the_zip
    phone.set the_phone
    mobile_phone.set the_mobile_phone
    work_phone.set the_work_phone
    tax.set the_tax
    email.set the_email


    create_btn.click
  end


end