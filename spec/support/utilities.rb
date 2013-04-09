## constans for page selector

JOB_BTN_START                  = 'start_service_call_btn'
JOB_BTN_CANCEL                 = 'cancel_service_call_btn'

JOB_BTN_UN_CANCEL              = 'un_cancel_service_call_btn'
JOB_BTN_CANCEL_TRANSFER        = 'cancel_transfer_service_call_btn'
JOB_BTN_COMPLETE               = 'complete_service_call_btn'
JOB_BTN_CREATE                 = 'service_call_create_btn'
JOB_BTN_ADD_CUSTOMER           = 'add_customer_btn'
JOB_BTN_TRANSFER               = 'service_call_transfer_btn'
JOB_BTN_DISPATCH               = 'service_call_dispatch_btn'
JOB_BTN_ACCEPT                 = 'accept_service_call_btn'
JOB_BTN_UN_ACCEPT              = 'un_accept_service_call_btn'
JOB_BTN_REJECT                 = 'reject_service_call_btn'
JOB_BTN_INVOICE                = 'invoice_service_call_btn'
JOB_BTN_PROV_INVOICE           = 'provider_invoiced_service_call_btn'
JOB_BTN_SUBCON_INVOICED        = 'subcon_invoiced_service_call_btn'
JOB_BTN_PAID                   = 'job_paid_btn'
JOB_BTN_CLEAR                  = 'clear_service_call_btn'
JOB_BTN_COLLECT                = 'collect_service_call_btn'
JOB_BTN_PROV_COLLECT           = 'provider_collected_service_call_btn'
JOB_BTN_DEPOSIT                = 'deposit_to_prov_service_call_btn'
JOB_BTN_CONFIRM_DEPOSIT        = 'confirm_deposit_service_call_btn'
JOB_BTN_PROV_CONFIRMED_DEPOSIT = 'prov_confirmed_deposit_service_call_btn'
JOB_BTN_SETTLE                 = 'settle_service_call_btn'
JOB_BTN_PROV_SETTLE            = 'provider_settle_service_call_btn'
JOB_BTN_PROV_PAYMENT_CLEAR     = 'clear_service_call_btn'
JOB_BTN_CONFIRM_SETTLEMENT     = 'confirm_settled_service_call_btn'
JOB_BTN_CLOSE                  = 'close_service_call_btn'
JOB_BTN_HISTORY                = 'job_history_btn'

JOB_SELECT_SUBCON_PAYMENT   = 'service_call_subcon_payment'
JOB_SELECT_PROVIDER_PAYMENT = 'service_call_provider_payment'
JOB_SELECT_SUBCONTRACTOR    = 'service_call_subcontractor_id'
JOB_SELECT_PROVIDER         = 'service_call_provider_id'
JOB_SELECT_PAYMENT          = 'service_call_payment_type'
JOB_CBOX_ALLOW_COLLECTION   = 'service_call_allow_collection'
JOB_CBOX_RE_TRANSFER        = 'service_call_re_transfer'
JOB_CBOX_TRANSFERABLE       = 'service_call_transferable'

JOB_STATUS               = 'span#service_call_status'
JOB_SUBCONTRACTOR_STATUS = 'span#service_call_subcontractor_status'
JOB_PROVIDER_STATUS      = 'span#service_call_provider_status'
JOB_WORK_STATUS          = 'span#service_call_work_status'
JOB_BILLING_STATUS       = 'span#service_call_billing_status'

ACC_SELECT          = 'account'
ACC_BTN_GET_ENTRIES = 'get-entries-btn'
AFF_SPAN_BALANCE    = 'span#balance'

BOM_SELECT_BUYER = 'bom_buyer'

def in_browser(name)
  Capybara.session_name = name
  yield
end

def sign_in(user)
  visit new_user_session_path
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: user.password
  click_button 'Sign in'

  # Sign in when not using Capybara.
  #cookies[:remember_token] = user.remember_token
end

def clean(org)
  org.subcontractors.each do |prov|
    prov.destroy
  end

  org.subcontractors.destroy_all

  org.providers.each do |prov|
    prov.destroy
  end

  org.providers.destroy_all

  org.users.each do |usr|
    usr.destroy
  end
  org.users.destroy_all

  org.customers.each do |cus|
    cus.destroy
  end
  org.customers.destroy_all

  org.agreements.each do |agreement|
    agreement.destroy
  end
  org.agreements.destroy_all
  org.reverse_agreements.each do |agreement|
    agreement.destroy
  end
  org.reverse_agreements.destroy_all


  org.destroy

end

def setup_standard_orgs
  let!(:org_admin_user) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
  let!(:org_admin_user2) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
  let!(:org_admin_user3) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
  let!(:org) { org_admin_user.organization }
  let!(:org2) {
    setup_profit_split_agreement(org_admin_user2.organization, org.becomes(Subcontractor))
    setup_profit_split_agreement(org, org_admin_user2.organization.becomes(Subcontractor)).counterparty
  }
  let!(:org3) do
    setup_profit_split_agreement(org_admin_user3.organization, org_admin_user.organization.becomes(Subcontractor))
    setup_profit_split_agreement(org2, org_admin_user3.organization.becomes(Subcontractor)).counterparty
  end
  let!(:customer) { FactoryGirl.create(:customer, organization: org) }

end

def setup_org
  let!(:org_admin_user) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
  let!(:org) { org_admin_user.organization }
end

def fill_autocomplete(field, options = {})
  fill_in field, :with => options[:with]

  page.execute_script %Q{ $('##{field}').trigger("focus") }
  page.execute_script %Q{ $('##{field}').trigger("keydown") }
  selector = "ul.ui-autocomplete a:contains('#{options[:select].gsub("'", "\\\\'")}')"

  page.should have_selector selector
  #page.driver.render('./tmp/capybara/auto_complete-' + Time.now.strftime("%Y-%m-%d-%H_%M_%S_%L") + '.png', full: true)

  page.execute_script "$(\"#{selector}\").mouseenter().click()"
end

def setup_customer_agreement(org, customer)
  agreement = Agreement.where("organization_id = ? AND counterparty_id = ? AND counterparty_type = 'Customer'", org.id, customer.id).first
  account   = Account.where("organization_id = ? AND accountable_id = ? AND accountable_type = 'Customer'", org.id, customer.id).first
  if agreement.nil?
    CustomerAgreement.create(name: "stam agr", organization: org, counterparty: customer, creator: org.users.first)
  end
  if account.nil?
    account = Account.create(organization: org, accountable: customer)
  end
  Rails.logger.debug { "created account: #{account.inspect}" }
end

def setup_profit_split_agreement(prov, subcon)
  prov.subcontractors << subcon if prov.subcontrax_member?
  subcon.providers << prov if subcon.subcontrax_member?
  agreement = Agreement.where("organization_id = ? AND counterparty_id = ? AND counterparty_type = 'Organization'", prov.id, subcon.id).first
  FactoryGirl.create(:profit_split, agreement: agreement)
  agreement.status = OrganizationAgreement::STATUS_ACTIVE
  agreement.save!
  agreement
end


def add_bom(name, cost, price, qty, buyer = nil)
  click_button 'new-bom-button'
  fill_in 'bom_material_name', with: name
  fill_in 'bom_cost', with: cost
  fill_in 'bom_price', with: price
  fill_in 'bom_quantity', with: qty
  select buyer, from: BOM_SELECT_BUYER if buyer.present?
  click_button 'add_part'
  sleep 1
  page.should have_selector "td", text: name # to ensure bom is added before moving to the next action (click visit etc.)
  click_button 'new-bom-button'
end

def capture_page(name = nil)
  page.driver.render("#{Rails.root}/tmp/capybara/#{name}_#{Time.now}.png", :full => true)
  page.save_page
end

def add_bom_to_ticket(ticket, cost = nil, price = nil, quantity = nil, buyer = nil, material = nil)
  cost     ||= 10
  price    ||= 100
  quantity ||= 1
  buyer    ||= ticket.organization
  material ||= FactoryGirl.create(:material, organization: ticket.organization)

  bom = Bom.new(quantity: quantity, material: material, cost: cost, price: price, ticket: ticket, buyer: buyer)
  ticket.boms << bom
end

def create_my_job(user, customer, browser)
  in_browser(browser) do
    with_user(user) do
      visit new_service_call_path
      fill_autocomplete 'service_call_customer', with: customer.name.chop, select: customer.name
      click_button JOB_BTN_CREATE
    end
  end

  ServiceCall.last
end

def create_transferred_job(user, provider, browser)
  in_browser(browser) do
    with_user(user) do
      visit new_service_call_path
      click_link JOB_BTN_ADD_CUSTOMER
      fill_in 'service_call_new_customer', with: Faker::Name.name
      select provider.name, from: JOB_SELECT_PROVIDER
      check JOB_CBOX_ALLOW_COLLECTION
      check JOB_CBOX_TRANSFERABLE
      click_button JOB_BTN_CREATE
    end
  end

  ServiceCall.last
end