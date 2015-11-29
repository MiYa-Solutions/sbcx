class Api::V1::Filters::StatusFilter
  attr_accessor :params
  attr_accessor :orig_scope
  attr_accessor :status

  def initialize(scope, req_params)
    @orig_scope = scope
    @params     = req_params
    @status     = params[:filters] ? params[:filters][:status] : nil
  end


  def scope
    if status.present?
      term = status.map { |t| status_map[t] }
      orig_scope.where('status in (?) ', term)
    else
      orig_scope
    end
  end


  private

  def status_map
    {
        'Closed'       => Ticket::STATUS_CLOSED,
        'New'          => Ticket::STATUS_NEW,
        'Received New' => Ticket::STATUS_NEW,
        'Open'         => Ticket::STATUS_OPEN,
        'Transferred'  => Ticket::STATUS_TRANSFERRED,
        'Passed On'    => Ticket::STATUS_TRANSFERRED,
        'Accepted'     => TransferredServiceCall::STATUS_ACCEPTED,
        'Rejected'     => TransferredServiceCall::STATUS_REJECTED,
        'Canceled'     => Ticket::STATUS_CANCELED
    }
  end


end