module BomsHelper
  def buyer_options(ticket)
    [ticket.provider,
     ticket.subcontractor,
     ticket.technician].compact.map { |obj| [obj.name, obj.id, { "data-type" => obj.class.name }] }
  end
end
