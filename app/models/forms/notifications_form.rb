class Forms::NotificationsForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  ServiceCallNotification.subclasses.each do |s|
    attr_accessor s.name.underscore.to_sym
  end
end