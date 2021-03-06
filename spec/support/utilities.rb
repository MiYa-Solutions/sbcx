## constans for page selector

JOB_BTN_START   = 'start_service_call_btn'
JOB_BTN_CANCEL  = 'cancel_service_call_btn'
JOB_BTN_ADD_BOM = 'new-bom-button'

JOB_BTN_UN_CANCEL               = 'un_cancel_service_call_btn'
JOB_BTN_CANCEL_TRANSFER         = 'cancel_transfer_service_call_btn'
JOB_BTN_COMPLETE                = 'complete_service_call_btn'
JOB_BTN_CREATE                  = 'service_call_create_btn'
JOB_BTN_ADD_CUSTOMER            = 'add_customer_btn'
JOB_BTN_TRANSFER                = 'service_call_transfer_btn'
JOB_BTN_DISPATCH                = 'dispatch_service_call_btn'
JOB_BTN_ACCEPT                  = 'accept_service_call_btn'
JOB_BTN_UN_ACCEPT               = 'un_accept_service_call_btn'
JOB_BTN_REJECT                  = 'reject_service_call_btn'
JOB_BTN_INVOICE                 = 'invoice_service_call_btn'
JOB_BTN_PROV_INVOICE            = 'provider_invoiced_service_call_btn'
JOB_BTN_SUBCON_INVOICED         = 'subcon_invoiced_service_call_btn'
JOB_BTN_PAID                    = 'job_paid_btn'
JOB_BTN_CLEAR                   = 'clear_service_call_btn'
JOB_BTN_COLLECT                 = 'collect_service_call_btn'
JOB_BTN_PROV_COLLECT            = 'provider_collected_service_call_btn'
JOB_BTN_DEPOSIT                 = 'deposit_service_call_btn'
JOB_BTN_CONFIRM_DEPOSIT         = 'confirm_deposit_service_call_btn'
JOB_BTN_PROV_CONFIRMED_DEPOSIT  = 'prov_confirmed_deposit_service_call_btn'
JOB_BTN_SETTLE                  = 'settle_service_call_btn'
JOB_BTN_PROV_SETTLE             = 'provider_settle_service_call_btn'
JOB_BTN_PROV_PAYMENT_CLEAR      = 'clear_prov_service_call_btn'
JOB_BTN_SUBCON_PAYMENT_CLEAR    = 'clear_subcon_service_call_btn'
JOB_BTN_CONFIRM_SETTLEMENT      = 'confirm_settled_subcon_service_call_btn'
JOB_BTN_CONFIRM_PROV_SETTLEMENT = 'confirm_settled_prov_service_call_btn'
JOB_BTN_CLOSE                   = 'close_service_call_btn'
JOB_BTN_HISTORY                 = 'job_history_btn'
JOB_BTN_PAYMENT_REJECTED        = 'reject_payment_service_call_btn'
JOB_BTN_PAYMENT_DEPOSITED       = 'deposit_service_call_btn'
JOB_RADIO_I_INVOICED            = 'service_call_billing_status_invoice'
JOB_RADIO_PROV_INVOICED         = 'service_call_billing_status_provider_invoiced'
JOB_RADIO_SUBCON_INVOICED       = 'service_call_billing_status_subcon_invoiced'


JOB_SELECT_SUBCON_PAYMENT   = 'service_call_subcon_payment'
JOB_SELECT_PROVIDER_PAYMENT = 'service_call_provider_payment'
JOB_SELECT_SUBCONTRACTOR    = 'service_call_subcontractor_id'
JOB_SELECT_PROVIDER         = 'service_call_provider_id'
JOB_SELECT_PROVIDER_AGR     = 'service_call_provider_agreement_id'
JOB_SELECT_SUBCON_AGR       = 'service_call_subcon_agreement_id'
JOB_SELECT_COLLECTOR        = 'service_call_collector_id'
JOB_SELECT_PAYMENT          = 'service_call_payment_type'
JOB_SELECT_PAYMENT_BY_PROV  = 'provider_payment_type'
JOB_CBOX_ALLOW_COLLECTION   = 'service_call_allow_collection'
JOB_CBOX_RE_TRANSFER        = 'service_call_re_transfer'
JOB_CBOX_TRANSFERABLE       = 'service_call_transferable'
JOB_INPUT_TAX               = 'service_call_tax'

JOB_STATUS               = 'span#service_call_status'
JOB_SUBCONTRACTOR_STATUS = 'span#service_call_subcontractor_status'
JOB_PROVIDER_STATUS      = 'span#service_call_provider_status'
JOB_WORK_STATUS          = 'span#service_call_work_status'
JOB_BILLING_STATUS       = 'span#service_call_billing_status'

ACC_SELECT            = 'account'
ACC_BTN_GET_ENTRIES   = 'get-entries-btn'
AFF_SPAN_BALANCE      = 'span#balance'
AFF_SPAN_SYNCH_STATUS = 'span#synch_status'

BOM_SELECT_BUYER = 'bom_buyer_id'

def in_browser(name)
  Capybara.session_name = name
  yield
end

def with_user (user, &block)
  prev_user = User.stamper
  User.stamper = user
  Authorization::Maintenance.with_user(user, &block)
  User.stamper = prev_user
end

def sign_in(user)
  # visit new_user_session_path
  # fill_in 'user_email', with: user.email
  # fill_in 'user_password', with: user.password
  # click_button 'Sign in'
  login_as(user, :scope => :user)

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
  let(:org) { FactoryGirl.create(:member_org) }
  let(:org_admin_user) { org.users.first }
  let(:org2) { FactoryGirl.create(:member_org) }
  let(:org_admin_user2) { org2.users.first }
  let(:org3) { FactoryGirl.create(:member_org) }
  let(:org_admin_user3) { org3.users.first }
  let(:customer) { FactoryGirl.create(:customer, organization: org) }

  before do
    setup_profit_split_agreement(org2, org.becomes(Subcontractor))
    setup_profit_split_agreement(org, org2.becomes(Subcontractor))
    setup_profit_split_agreement(org3, org.becomes(Subcontractor))
    setup_profit_split_agreement(org2, org3.becomes(Subcontractor))
    customer
  end

  # let!(:org_admin_user) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
  # let!(:org_admin_user2) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
  # let!(:org_admin_user3) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
  # let!(:org) { org_admin_user.organization }
  # let!(:org2) {
  #   setup_profit_split_agreement(org_admin_user2.organization, org.becomes(Subcontractor))
  #   setup_profit_split_agreement(org, org_admin_user2.organization.becomes(Subcontractor)).counterparty
  # }
  # let!(:org3) do
  #   setup_profit_split_agreement(org_admin_user3.organization, org_admin_user.organization.becomes(Subcontractor))
  #   setup_profit_split_agreement(org2, org_admin_user3.organization.becomes(Subcontractor)).counterparty
  # end
  # let!(:customer) { FactoryGirl.create(:customer, organization: org) }

end

def setup_org
  let!(:org_admin_user) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
  let!(:org) { org_admin_user.organization }
end


def fill_autocomplete(field, options = {})
  fill_in field, with: options[:with]

  page.execute_script %Q{ $('##{field}').trigger('focus') }
  page.execute_script %Q{ $('##{field}').trigger('keydown') }
  selector = %Q{ul.ui-autocomplete li.ui-menu-item a:contains("#{options[:select]}")}

  page.should have_selector('ul.ui-autocomplete li.ui-menu-item a')
  page.execute_script %Q{ $('#{selector}').trigger('mouseenter').click() }
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

def setup_flat_fee_agreement(prov, subcon, payment_rules = {})
  agreement = SubcontractingAgreement.create(organization:  prov,
                                             counterparty:  subcon,
                                             name:          "#{prov.name} (P), #{subcon.name} (S) FlatFee",
                                             creator:       User.find_by_email(User::SYSTEM_USER_EMAIL),
                                             payment_terms: :net_10)

  payment_rules[:cash_rate]        ||= 0.0
  payment_rules[:cheque_rate]      ||= 0.0
  payment_rules[:credit_rate]      ||= 0.0
  payment_rules[:amex_rate]        ||= 0.0
  payment_rules[:cash_rate_type]   ||= :percentage
  payment_rules[:cheque_rate_type] ||= :percentage
  payment_rules[:amex_rate_type]   ||= :percentage
  payment_rules[:credit_rate_type] ||= :percentage

  FactoryGirl.create(:flat_fee, agreement: agreement,
                     cheque_rate:          payment_rules[:cheque_rate],
                     cash_rate:            payment_rules[:cash_rate],
                     credit_rate:          payment_rules[:credit_rate],
                     amex_rate:            payment_rules[:amex_rate],
                     cheque_rate_type:     payment_rules[:cheque_rate_type],
                     cash_rate_type:       payment_rules[:cash_rate_type],
                     credit_rate_type:     payment_rules[:credit_rate_type],
                     amex_rate_type:       payment_rules[:amex_rate_type]
  )

  agreement.status = OrganizationAgreement::STATUS_ACTIVE
  agreement.save!
  prov.affiliates << subcon if prov.subcontrax_member?
  subcon.affiliates << prov if subcon.subcontrax_member?
  agreement
end

def setup_profit_split_agreement(prov, subcon, rate = 50.0, payment_rules = {})
  agreement = SubcontractingAgreement.create(organization:  prov,
                                             counterparty:  subcon,
                                             name:          "#{prov.name} (P), #{subcon.name} (S) FlatFee",
                                             creator:       User.find_by_email(User::SYSTEM_USER_EMAIL),
                                             payment_terms: :net_10)

  payment_rules[:cash_rate]        ||= 1.0
  payment_rules[:cheque_rate]      ||= 2.5
  payment_rules[:credit_rate]      ||= 2.9
  payment_rules[:amex_rate]        ||= 3.0
  payment_rules[:cash_rate_type]   ||= :percentage
  payment_rules[:cheque_rate_type] ||= :percentage
  payment_rules[:amex_rate_type]   ||= :percentage
  payment_rules[:credit_rate_type] ||= :percentage

  FactoryGirl.create(:profit_split, agreement: agreement, rate: rate,
                     cheque_rate:              payment_rules[:cheque_rate],
                     cash_rate:                payment_rules[:cash_rate],
                     credit_rate:              payment_rules[:credit_rate],
                     amex_rate:                payment_rules[:amex_rate],
                     cheque_rate_type:         payment_rules[:cheque_rate_type],
                     cash_rate_type:           payment_rules[:cash_rate_type],
                     credit_rate_type:         payment_rules[:credit_rate_type],
                     amex_rate_type:           payment_rules[:amex_rate_type]
  )

  agreement.status = OrganizationAgreement::STATUS_ACTIVE
  agreement.save!
  prov.affiliates << subcon if prov.subcontrax_member?
  subcon.affiliates << prov if subcon.subcontrax_member?
  agreement
end

def create_profit_split_agreement(org, affiliate, payment_rules = {})
  payment_rules[:cash_rate]        ||= 1.0
  payment_rules[:cheque_rate]      ||= 2.5
  payment_rules[:credit_rate]      ||= 2.9
  payment_rules[:amex_rate]        ||= 3.0
  payment_rules[:cash_rate_type]   ||= :percentage
  payment_rules[:cheque_rate_type] ||= :percentage
  payment_rules[:amex_rate_type]   ||= :percentage
  payment_rules[:credit_rate_type] ||= :percentage
  payment_rules[:rate]             ||= 50

  setup_profit_split_agreement(org, affiliate, payment_rules[:rate])

end


def add_bom(name, cost, price, qty, buyer = nil)
  click_link 'Job Billing'
  click_button JOB_BTN_ADD_BOM
  fill_in 'bom_material_name', with: name
  fill_in 'bom_cost', with: cost
  fill_in 'bom_price', with: price
  fill_in 'bom_quantity', with: qty
  select buyer, from: BOM_SELECT_BUYER if buyer.present?
  click_button 'add_part'
  #sleep 1
  page.has_selector? "td", text: name # to ensure bom is added before moving to the next action (click visit etc.)
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
      fill_autocomplete 'service_call_customer_name', with: customer.name.chop, select: customer.name
      click_button JOB_BTN_CREATE
    end
  end

  ServiceCall.last
end

def create_transferred_job(user, provider, browser)
  agr = Agreement.my_agreements(provider.id).cparty_agreements(user.organization.id).with_status(:active).first
  in_browser(browser) do
    with_user(user) do
      visit new_service_call_path
      fill_in 'service_call_customer_name', with: Faker::Name.name
      select provider.name, from: JOB_SELECT_PROVIDER
      select agr.name, from: JOB_SELECT_PROVIDER_AGR
      #check JOB_CBOX_ALLOW_COLLECTION
      #check JOB_CBOX_TRANSFERABLE
      click_button JOB_BTN_CREATE
    end
  end

  ServiceCall.last
end

def pay_with_cheque(collector = nil)
  select Cheque.model_name.human, from: JOB_SELECT_PAYMENT
  select collector, from: JOB_SELECT_COLLECTOR if collector.present?
  click_button JOB_BTN_COLLECT
end

def transfer_job(job, subcon, agreement = nil, props = {})

  agreement ||= Agreement.my_agreements(job.organization.id).cparty_agreements(subcon.id).with_status(:active).first

  visit service_call_path(job)
  click_link 'transfer_btn'
  sleep 0.5
  select subcon.name, from: JOB_SELECT_SUBCONTRACTOR
  select agreement.name, from: JOB_SELECT_SUBCON_AGR
  check JOB_CBOX_RE_TRANSFER
  check JOB_CBOX_ALLOW_COLLECTION
  yield if block_given? # used to fill additional agreement specific fields or any other action
  click_button JOB_BTN_TRANSFER

end

def complete_job(job, boms = nil)
  boms ||= [
      { name: 'Part1', cost: 10, price: 100, quantity: 1 },
      { name: 'Part1', cost: 20, price: 200, quantity: 1 }
  ]

  visit service_call_path(job)
  click_button JOB_BTN_ACCEPT
  click_button JOB_BTN_START

  boms.each do |bom|
    add_bom bom[:name], bom[:cost], bom[:price], bom[:quantity]
  end

  click_button JOB_BTN_COMPLETE
end

def select2_select(text, options)
  page.find("#s2id_#{options[:from]} a").click
  page.all("ul.select2-results li").each do |e|
    if e.text == text
      e.click
      return
    end
  end
end