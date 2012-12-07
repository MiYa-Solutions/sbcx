require "spec_helper"

describe NotificationMailer do
  describe "received service call notification " do
    it "should have the notification defined" do
      [:sc_completed_notification,
       :sc_rejected_notification,
       :sc_received_notification,
       :sc_complete_notification,
       :sc_settled_notification,
       :sc_settle_notification,
       :sc_accepted_notification,
       :sc_canceled_notification,
       :sc_cancel_notification,
       :sc_dispatch_notification,
       :sc_dispatched_notification,
       :sc_paid_notification
      ].each do |notification|
        NotificationMailer.should respond_to(notification)
      end
    end
  end
end
