module AgreementsHelper

  def agreement_option(klass)

    [
        klass.name.titleize,
        klass.name.underscore,
        {
            "data-organization" => klass.human_attribute_name(:organization),
            "data-counterparty" => klass.human_attribute_name(:counterparty)
        }
    ]

  end

  def organization_agreement_types
    Rails.logger.debug { "Need to reload all subclasses in dev mode" + SubcontractingAgreement.name + SupplierAgreement.name }
    OrganizationAgreement.subclasses.map { |subclass| agreement_option(subclass) }
  end

  def agreement_events(agreement)
    if  permitted_to? :update, agreement.becomes(Agreement)
      content_tag_for :ul, agreement, class: 'agreement_events unstyled' do
        agreement.status_events.collect do |event|
          case event
            when :submit_for_approval
              concat (content_tag :li, agr_submission_form(agreement))
            when :activate
              concat (content_tag :li, agr_activation_form(agreement))
            when :submit_change
              concat (content_tag :li, agr_change_submission_form(agreement))
            when :accept
              concat (content_tag :li, agr_accept_form(agreement))
            when :reject
              concat (content_tag :li, agr_reject_form(agreement))
            when :cancel
              concat (content_tag :li, agr_cancel_form(agreement))
            else
              concat(content_tag :li, agreement.class.human_status_event_name(event))
          end

        end

      end
    else
      Rails.logger.debug { "User is not permitted to update agreement:
              Agreement organization: #{agreement.organization_id}
              Agreemenet counterparty: #{agreement.counterparty_id}
              Agreement status: #{agreement.human_status_name}
              Agreement creator org: #{agreement.creator.organization_id}
              Agreement creator id: #{agreement.creator_id}
              user's Org users: #{current_user.organization.user_ids}" }
    end


  end


  def agr_submission_form(agreement)
    simple_form_for agreement.becomes(Agreement) do |f|
      concat (f.text_field :change_reason)
      concat (hidden_field_tag 'agreement[status_event]', 'submit_for_approval')
      concat (f.submit agreement.class.human_status_event_name(:submit_for_approval).titleize,
                       id:    'agreement_submission_btn',
                       class: "btn btn-large",
                       title: 'Click to submit the agreement for the approval of your counterparty',
                       rel:   'tooltip'
             )
    end

  end

  def agr_activation_form (agreement)
    simple_form_for agreement.becomes(Agreement) do |f|
      concat (hidden_field_tag 'agreement[status_event]', 'activate')
      concat (f.submit agreement.class.human_status_event_name(:activate).titleize,
                       id:    'agreement_activate_btn',
                       class: "btn btn-large",
                       title: 'Click to activate the agreement',
                       rel:   'tooltip'
             )

    end
  end

  def agr_change_submission_form(agreement)
    simple_form_for agreement.becomes(Agreement) do |f|
      concat (f.text_field :change_reason)
      concat (hidden_field_tag 'agreement[status_event]', 'submit_change')
      concat (f.submit agreement.class.human_status_event_name(:submit_change).titleize,
                       id:    'agreement_submission_btn',
                       class: "btn btn-large",
                       title: 'Click to submit the agreement for the approval of your counterparty',
                       rel:   'tooltip'
             )

    end


  end

  def agr_accept_form(agreement)
    simple_form_for agreement.becomes(Agreement) do |f|
      concat (hidden_field_tag 'agreement[status_event]', 'accept')
      concat (f.submit agreement.class.human_status_event_name(:accept).titleize,
                       id:    'agreement_accept_btn',
                       class: "btn btn-large",
                       title: 'Click to accept the agreement as defined by the other party',
                       rel:   'tooltip'
             )

    end

  end

  def agr_reject_form(agreement)
    simple_form_for agreement.becomes(Agreement) do |f|
      concat (f.text_field :change_reason)
      concat (hidden_field_tag 'agreement[status_event]', 'reject')
      concat (f.submit agreement.class.human_status_event_name(:reject).titleize,
                       id:    'agreement_rejection_btn',
                       class: "btn btn-large",
                       title: 'Click to reject the changes made by the other party',
                       rel:   'tooltip'
             )

    end
  end

  def agr_cancel_form(agreement)
    simple_form_for agreement.becomes(Agreement) do |f|
      concat (f.text_field :change_reason)
      concat (hidden_field_tag 'agreement[status_event]', 'cancel')
      concat (f.submit agreement.class.human_status_event_name(:cancel).titleize,
                       id:      'agreement_rejection_btn',
                       class:   "btn btn-large",
                       title:   'Click to cancel this relationship with the otherparty',
                       confirm: 'Are you sure? This is an irreversible operation, and so this agreement will be permanently terminated ',
                       rel:     'tooltip'
             )

    end

  end


end