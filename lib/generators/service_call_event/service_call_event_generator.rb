class ServiceCallEventGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  class_option :notification, type: :boolean, default: true, desc: "generate a notification class for the event"

  def generate_event
    template 'service_call_event.rb.erb', "app/events/sc_#{name.underscore}_event.rb"
    template 'service_call_notification.rb.erb', "app/notifications/sc_#{name.underscore}_notification.rb" if options.notification?
    template 'service_call_notification.html.erb', "app/views/notification_mailer/sc_#{name.underscore}_notification.html.erb" if options.notification?
  end
end
