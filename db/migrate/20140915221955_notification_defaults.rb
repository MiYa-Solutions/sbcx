class NotificationDefaults < ActiveRecord::Migration
  def up
    User.all.each do |user|
      user.preferences = { 'sc_received_notification'                   => 'true',
                           'sc_received_notification_email'             => 'true',
                           'sc_accepted_notification'                   => 'true',
                           'sc_cancel_notification'                     => 'true',
                           'sc_cancel_notification_email'               => 'true',
                           'sc_rejected_notification'                   => 'true',
                           'sc_rejected_notification_email'             => 'true',
                           'sc_canceled_notification'                   => 'true',
                           'sc_canceled_notification_email'             => 'true',
                           'sc_completed_notification'                  => 'true',
                           'sc_completed_notification_email'            => 'true',
                           'sc_complete_notification'                   => 'true',
                           'sc_complete_notification_email'             => 'true',
                           'sc_collected_notification'                  => 'true',
                           'sc_deposit_confirmed_notification'          => 'true',
                           'sc_dispatch_notification'                   => 'true',
                           'sc_dispatched_notification'                 => 'true',
                           'sc_dispatched_notification_email'           => 'true',
                           'sc_paid_notification'                       => 'true',
                           'sc_props_updated_notification'              => 'true',
                           'sc_provider_canceled_notification'          => 'true',
                           'sc_provider_canceled_notification_email'    => 'true',
                           'sc_provider_collected_notification'         => 'true',
                           'sc_provider_confirmed_settled_notification' => 'true',
                           'sc_provider_settled_notification'           => 'true',
                           'sc_provider_settled_notification'           => 'true',
                           'sc_provider_settled_notification_email'     => 'true',
                           'sc_start_notification'                      => 'true',
                           'sc_started_notification'                    => 'true',
                           'sc_subcon_cleared_notification'             => 'true',
                           'sc_subcon_confirmed_settled_notification'   => 'true',
                           'sc_subcon_deposited_notification'           => 'true',
                           'sc_subcon_settled_notification'             => 'true'
      }
      user.save!
    end
  end

  def down
  end
end
