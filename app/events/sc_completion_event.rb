class ScCompletionEvent < ServiceCallEvent

  protected

  def update_payment_status
    service_call.mark_as_fully_paid_payment! if service_call.can_mark_as_fully_paid_payment?
  end


end