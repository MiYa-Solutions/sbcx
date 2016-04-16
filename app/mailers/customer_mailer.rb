class CustomerMailer < ActionMailer::Base

   def sc_invoice_notification(subject, customer, notifiable)
     @invoice = notifiable
     @subject = subject
     @customer = customer

     mail to: customer.email, subject: subject, from: customer.organization.email, reply_to: customer.organization.email

   end

end
