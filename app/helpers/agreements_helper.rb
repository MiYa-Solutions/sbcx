module AgreementsHelper

  def agreement_payment_options
    @agreement.class.payment_options.keys.map {|key| [key, t("agreement.payment_options.#{key}")]}
  end

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
  def role_options_for_agreement(klass)
    [
            [klass.human_attribute_name(:organization), 'organization'],
            [klass.human_attribute_name(:counterparty), 'counterparty']
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
              concat (label_tag 'agr_submission_form', 'Submit Agreement for Approval', class: "title")
              concat (content_tag :li, agr_submission_form(agreement),
                     class: "cancel_agreement")
              concat (label_tag 'agr_submission_form', 'Enter comments, if any, and click the Submit button', class: "subtitle")
            when :activate
              concat (content_tag :li, agr_activation_form(agreement), class: "agreement_fields")
            when :submit_change
              concat (label_tag 'agr_change_submission_form', 'Enter comments, if any, and click the Submit Change button', class: "title")
              concat (content_tag :li, agr_change_submission_form(agreement),
                     class: "cancel_agreement")
            when :accept
              concat (content_tag :li, agr_accept_form(agreement))
            when :reject
              concat (content_tag :li, agr_reject_form(agreement))
            when :cancel
              concat (label_tag 'agr_cancel_form', 'Cancel Agreement', class: "title")
              concat (content_tag :li, agr_cancel_form(agreement),
                     class: "cancel_agreement")
              concat (label_tag 'agr_cancel_form', 'Enter the reason you wish to cancel the agreement, and click the Cancel button', class: "subtitle")
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
                       class: "btn btn-primary",
                       title: 'Click to submit the agreement for the approval',
                       rel:   'tooltip'
             )
    end

  end

  def agr_activation_form (agreement)
    simple_form_for agreement.becomes(Agreement) do |f|
      concat (hidden_field_tag 'agreement[status_event]', 'activate')
      concat (f.submit agreement.class.human_status_event_name(:activate).titleize,
                       id:    'agreement_activate_btn',
                       class: "btn btn-primary",
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
                       class: "btn btn-primary",
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
                       class: "btn btn-primary",
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
                       class: "btn btn-danger",
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
                       class:   "btn btn-danger",
                       title:   'Click to cancel this agreement',
                       confirm: 'Are you sure?' + "\n" + 'Please note that this operation is irreversible, and this agreement will no longer be available',
                       rel:     'tooltip'
             )

    end

  end


end