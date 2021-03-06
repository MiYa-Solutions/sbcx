namespace :db do
  task populate: :environment do
    require 'faker'
    require 'job_charge'
    create_members
    create_providers
    create_subcontractors
    create_customers
    #create_agreements

  end
end

def create_agreements
  members = Organization.members.all

  prov_ids = []
  (members.length/3).times { prov_ids << Random.rand(0..members.length-1) }
  prov_ids = prov_ids.uniq
  sub_ids  = []
  (members.length/3).times { sub_ids << Random.rand(0..members.length-1) }
  sub_ids = sub_ids.uniq

  members.each_with_index do |mem, index|
    user = mem.org_admins.last
    prov_ids.each do |i|
      unless index == i
        SubcontractingAgreement.find_or_create_by_organization_id_and_counterparty_id(organization_id: members[i].id, counterparty_id: mem.id) do |agr|
          agr.counterparty_type = "Organization"
          agr.creator_id        = user.id
        end
      end
    end

    sub_ids.each do |i|
      unless index == i
        SubcontractingAgreement.find_or_create_by_organization_id_and_counterparty_id(organization_id: mem.id, counterparty_id: members[i].id) do |agr|
          agr.counterparty_type = "Organization"
          agr.creator_id        = user.id
        end
      end
    end

  end


end

def create_members
  prov_role = OrganizationRole.find_by_id(OrganizationRole::PROVIDER_ROLE_ID)
  sub_role  = OrganizationRole.find_by_id(OrganizationRole::SUBCONTRACTOR_ROLE_ID)

  org_admin_role  = Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME)
  dispatcher_role = Role.find_by_name(Role::DISPATCHER_ROLE_NAME)
  technician_role = Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)

  mem = new_member([prov_role, sub_role], { name:  "Test Member1",
                                            email: "testmem1@testmem1.com" })

  mem.save!
  mem.users << new_user([org_admin_role, dispatcher_role, technician_role], { email: "ishay.yaari@gmail.com" })


  mem2 = new_member([prov_role, sub_role], { name:  "Test Member2",
                                             email: "testmem2@testmem2.com" })

  mem2.save!
  mem2.users << new_user([org_admin_role, dispatcher_role, technician_role], { email: "markmilman@gmail.com" })

  #mem.providers << mem2.becomes(Provider)
  #mem.subcontractors << mem2.becomes(Subcontractor)
  #mem2.accounts.create(accountable: mem)
  #
  #
  #agr1 = Agreement.where("organization_id = #{mem2.id} AND counterparty_id =  #{mem.id}").first
  #agr2 = Agreement.where("organization_id = #{mem.id} AND counterparty_id =  #{mem2.id}").first
  #
  #agr1.rules << ProfitSplit.new(agreement: agr1, rate: 50, rate_type: :percentage)
  #agr1.status = Agreement::STATUS_ACTIVE
  #agr1.save!
  #agr2.rules << ProfitSplit.new(agreement: agr1, rate: 50, rate_type: :percentage)
  #agr2.status = Agreement::STATUS_ACTIVE
  #agr2.save!

  # create two members for manual testing
  #2.times do |n = 1|
  #  index = n+1
  #  mem   = new_member([prov_role, sub_role], { name:  "Test Member#{index}",
  #                                              email: "testmem#{index}@testmem#{index}.com" })
  #  mem.save!
  #  mem.users << new_user([org_admin_role, dispatcher_role, technician_role], { email: "mem#{index}@mem#{index}.com" })
  #  # don't create dispatcher and technicians for test mem1 and mem2
  #mem.users << new_user([dispatcher_role], { email: "disp#{index}@mem#{index}.com" })
  #mem.users << new_user([technician_role], { email: "tech#{index}@mem#{index}.com" })

  #2.times do
  #  mem.users << new_user([dispatcher_role], { })
  #end
  #2.times do
  #  mem.users << new_user([technician_role], { })
  #end

  #end
  # create additional members as just test data
  #10.times do
  #  mem = new_member([prov_role, sub_role])
  #  mem.save
  #  mem.users << new_user([org_admin_role])
  #  2.times do
  #    mem.users << new_user([dispatcher_role], { })
  #  end
  #  2.times do
  #    mem.users << new_user([technician_role], { })
  #  end
  #
  #  mem.save
  #end
end

def create_providers
  prov_role = OrganizationRole.find_by_id(OrganizationRole::PROVIDER_ROLE_ID)
  members   = Organization.members.all

  members.each do |mem|
    5.times do
      prov = new_provider([prov_role])
      mem.providers << prov
      #agreement         = mem.reverse_agreements.where(organization_id: prov.id).last
      #agreement.creator = mem.org_admins.last
      #agreement.save!
      #prov.subcontracting_agreements.create(counterparty: mem, creator: User.find_by_email('system@subcontrax.com') )
    end
  end
end

def create_subcontractors
  sub_role = OrganizationRole.find_by_id(OrganizationRole::SUBCONTRACTOR_ROLE_ID)
  members  = Organization.members.all

  members.each do |mem|
    5.times do
      subcon = new_subcontractor([sub_role])
      mem.subcontractors << subcon
      #agreement         = mem.agreements.where(counterparty_id: subcon.id).last
      #agreement.creator = mem.org_admins.last
      #agreement.save!
      #mem.subcontracting_agreements.create(counterparty: new_subcontractor([sub_role]), creator: User.find_by_email('system@subcontrax.com') )
    end
  end
end

def create_customers
  members = Organization.members.all

  members.each do |mem|
    50.times { mem.customers << new_customer }
  end

end

def new_customer(params = {})

  params[:email]        ||= Faker::Internet.email
  params[:name]         ||= Faker::Name.name
  params[:phone]        ||= Faker::PhoneNumber.phone_number
  params[:mobile_phone] ||= Faker::PhoneNumber.phone_number
  params[:work_phone]   ||= Faker::PhoneNumber.phone_number
  params[:company]      ||= Faker::Company.name
  params[:address1]     ||= Faker::Address.street_address
  params[:address2]     ||= Faker::Address.street_address(true)
  params[:city]         ||= Faker::Address.city
  params[:state]        ||= Faker::Address.us_state_abbr
  params[:zip]          ||= Faker::Address.zip_code
  params[:country]      ||= "US"

  Customer.new(params)
end

def new_user(roles = [], params = {})
  params[:email]                 ||= Faker::Internet.email
  params[:password]              ||= "123456"
  params[:password_confirmation] ||= "123456"
  params[:first_name]            ||= Faker::Name.first_name
  params[:last_name]             ||= Faker::Name.last_name

  user       = User.new(params)
  user.roles = roles
  user
end

def new_member(roles = [], params = {})

  mem = new_org(roles, params)
  mem.make_sbcx_member
  mem
end

def new_org(roles = [], params = {})

  params                 = set_org_attr(params)
  mem                    = Organization.new(params)
  mem.organization_roles = roles
  mem
end

def new_provider(roles = [], params = {})

  params                 = set_org_attr(params)
  mem                    = Provider.new(params)
  mem.organization_roles = roles
  mem
end

def new_subcontractor(roles = [], params = {})
  params                 = set_org_attr(params)
  mem                    = Subcontractor.new(params)
  mem.organization_roles = roles
  mem

end


def set_org_attr(params)
  params[:email]      = params[:email] || Faker::Internet.email
  params[:industry]   = params[:industry] || Organization.industries.first
  params[:name]       = params[:name] || Faker::Name.name
  params[:phone]      = params[:phone] || Faker::PhoneNumber.phone_number
  params[:mobile]     = params[:mobile] || Faker::PhoneNumber.phone_number
  params[:work_phone] = params[:work_phone] || Faker::PhoneNumber.phone_number
  params[:website]    = params[:website] || Faker::Internet.url
  params[:company]    = params[:company] || Faker::Company.name
  params[:address1]   = params[:address1] || Faker::Address.street_address
  params[:address2]   = params[:address2] || Faker::Address.street_address(true)
  params[:city]       = params[:city] || Faker::Address.city
  params[:state]      = params[:state] || Faker::Address.us_state_abbr
  params[:zip]        = params[:zip] || Faker::Address.zip_code
  params[:country]    = params[:zip] || "US"
  #  status            :integer
  params
end




