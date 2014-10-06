class AddNotificationDefaults < ActiveRecord::Migration
  def up
    User.all.each do |user|
      user.preferences = user.preferences.merge( {

          'invite_accepted_notification'               => 'true',
          'invite_accepted_notification_email'         => 'true',
          'invite_declined_notification'               => 'true',
          'invite_declined_notification_email'         => 'true',
          'new_invite_notification'                    => 'true',
          'new_invite_notification_email'              => 'true',
          #agreement notifications
          'agr_new_subcon_notification'                => 'true',
          'agr_new_subcon_notification_email'          => 'true',
          'agr_change_rejected_notification'           => 'true',
          'agr_change_rejected_notification_email'     => 'true',
          'agr_change_submitted_notification'          => 'true',
          'agr_change_submitted_notification_email'    => 'true',
          'agr_subcon_accepted_notification'           => 'true',
          'agr_subcon_accepted_notification_email'     => 'true',
          #adj entry notifications
          'acc_adj_accepted_notification'              => 'true',
          'acc_adj_accepted_notification_email'        => 'true',
          'acc_adj_rejected_notification'              => 'true',
          'acc_adj_rejected_notification_email'        => 'true',
          'acc_adj_canceled_notification'              => 'true',
          'acc_adj_canceled_notification_email'        => 'true',
          'account_adjusted_notification'              => 'true',
          'account_adjusted_notification_email'        => 'true',
          #for 3rd party collection deposit
          'entry_disputed_notification'                => 'true',
          'entry_disputed_notification_email'          => 'true'
      } )
      user.save!
    end

  end

  def down
  end
end
