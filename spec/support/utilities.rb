## constans for page selector

JOB_BTN_START             = 'start_service_call_btn'
JOB_BTN_COMPLETE          = 'complete_service_call_btn'
JOB_BTN_CREATE            = 'service_call_create_btn'
JOB_BTN_TRANSFER          = 'service_call_transfer_btn'
JOB_BTN_ACCEPT            = 'accept_service_call_btn'
JOB_SELECT_SUBCONTRACTOR  = 'service_call_subcontractor_id'
JOB_CBOX_ALLOW_COLLECTION = 'service_call_allow_collection'
JOB_CBOX_RE_TRANSFER      = 'service_call_re_transfer'

AFF_SPAN_BALANCE = 'span#affiliate_balance'

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

def fill_autocomplete(field, options = {})
  fill_in field, :with => options[:with]

  page.execute_script %Q{ $('##{field}').trigger("focus") }
  page.execute_script %Q{ $('##{field}').trigger("keydown") }
  selector = "ul.ui-autocomplete a:contains('#{options[:select].gsub("'", "\\\\'")}')"

  page.should have_selector selector
  #page.driver.render('./tmp/capybara/auto_complete-' + Time.now.strftime("%Y-%m-%d-%H_%M_%S_%L") + '.png', full: true)

  page.execute_script "$(\"#{selector}\").mouseenter().click()"
end

def setup_profit_split_agreement(prov, subcon)
  prov.subcontractors << subcon
  agreement = Agreement.where("organization_id = ? AND counterparty_id = ? AND counterparty_type = 'Organization'", prov.id, subcon.id).first
  FactoryGirl.create(:profit_split, agreement: agreement)
  agreement.status = OrganizationAgreement::STATUS_ACTIVE
  agreement.save!
  agreement
end

def add_bom(name, cost, price, qty)
  click_button 'new-bom-button'
  fill_in 'bom_material_name', with: name
  fill_in 'bom_cost', with: cost
  fill_in 'bom_price', with: price
  fill_in 'bom_quantity', with: qty
  click_button 'add_part'
  click_button 'new-bom-button'
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