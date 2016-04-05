class AgreementEventGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  class_option :notification, type: :boolean, default: true, desc: "generate a notification class for the event"
  class_option :event_id, type: :string, desc: "updates the event class with the id"

  def generate_event
    template 'agreement_event.rb.erb', "app/events/agr_#{name.underscore}_event.rb"
    template 'agreement_notification.rb.erb', "app/notifications/agr_#{name.underscore}_notification.rb" if options.notification?
    template 'agreement_notification.html.erb', "app/views/notification_mailer/agr_#{name.underscore}_notification.html.erb" if options.notification?
  end
end
