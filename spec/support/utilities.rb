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

def fill_autocomplete(field, options = {})
  fill_in field, :with => options[:with]

  page.execute_script %Q{ $('##{field}').trigger("focus") }
  page.execute_script %Q{ $('##{field}').trigger("keydown") }
  selector = "ul.ui-autocomplete a:contains('#{options[:select]}')"

  page.should have_selector selector
  #page.driver.render('./tmp/capybara/auto_complete-' + Time.now.strftime("%Y-%m-%d-%H_%M_%S_%L") + '.png', full: true)

  page.execute_script "$(\"#{selector}\").mouseenter().click()"
end

def setup_profit_split_agreement(prov, subcon)
  prov.subcontractors << subcon
  agreement = Agreement.where("organization_id = ? and counterparty_id = ?", prov.id, subcon.id).first
  FactoryGirl.create(:profit_split, agreement: agreement)
  agreement.status = OrganizationAgreement::STATUS_ACTIVE
  agreement.save!
  agreement
end

def add_bom(name, cost, price, qty)
  click_link 'new-bom-button'
  fill_in 'bom_material_name', with: name
  fill_in 'bom_cost', with: cost
  fill_in 'bom_price', with: price
  fill_in 'bom_quantity', with: qty
  click_button 'add_part'
  click_link 'new-bom-button'
end

#def fill_in field, options
#  super
#  Rails.logger.debug { "In custom fill_in" }
#  page.execute_script "$('#{field}').change();"
#end