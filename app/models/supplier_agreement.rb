# == Schema Information
#
# Table name: agreements
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  counterparty_id   :integer
#  organization_id   :integer
#  description       :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  status            :integer
#  counterparty_type :string(255)
#  type              :string(255)
#  creator_id        :integer
#  updater_id        :integer
#  starts_at         :datetime
#  ends_at           :datetime
#  payment_terms     :string(255)
#

class SupplierAgreement < OrganizationAgreement
  # To change this template use File | Settings | File Templates.
end
