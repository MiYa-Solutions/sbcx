class AddAffPayNotificationsToSettings < ActiveRecord::Migration
  def up
    Organization.where(subcontrax_member: true).each do |org|
      org.org_admins.each do |user|
        res = user.settings.save(params)
        unless res
          Rails.logger.error "Failed to save settings for user (#{user.id}) #{user.email}"
        end
      end
    end
  end

  def down

  end

  def params
    {
        'aff_payment_disputed_notification'        => 'true',
        'aff_payment_disputed_notification_email'  => 'true',
        'aff_payment_confirmed_notification'       => 'true',
        'aff_payment_confirmed_notification_email' => 'true',
        'aff_payment_rejected_notification'        => 'true',
        'aff_payment_rejected_notification_email'  => 'true',
        'aff_payment_deposited_notification'       => 'true',
        'aff_payment_deposited_notification_email' => 'true',
        'aff_payment_cleared_notification'         => 'true',
        'aff_payment_cleared_notification_email'   => 'true'
    }
  end
end
