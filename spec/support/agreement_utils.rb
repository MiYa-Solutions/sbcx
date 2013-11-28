AGR_BTN_NEW                 = 'new-agreement-button'
AGR_BTN_CREATE              = 'add-agreement-button'
AGR_BTN_NEW_RULE            = 'new-rule-button'
AGR_BTN_ADD_RULE            = 'add-posting-rule-button'
AGR_BTN_CREATE_RULE         = 'submit_posting_rules'
AGR_BTN_SUBMIT_FOR_APPROVAL = 'agreement_submission_btn'
AGR_BTN_ACCEPT              = 'agreement_accept_btn'

AGR_SELECT_OTHERPARTY_ROLE = 'otherparty_role'
AGR_SELECT_RULE_TYPE       = 'posting_rule_type'

AGR_INPUT_NEW_NAME      = 'new_agreement_name'
AGR_INPUT_RULE_RATE     = 'posting_rule_rate'
AGR_INPUT_CHANGE_REASON = 'agreement_change_reason'

def negotiate_member_pf_agreement(org1_user, org2_user, rate = 50)
  agr_name = "PF - #{Time.now}"
  agr_link = ""
  in_browser(org1_user) do
    sign_in org1_user
    visit affiliate_path(org2_user.organization)
    click_button AGR_BTN_NEW
    select 'Subcontractor', from: AGR_SELECT_OTHERPARTY_ROLE
    fill_in AGR_INPUT_NEW_NAME, with: agr_name
    click_button AGR_BTN_CREATE

    # create the pf rule
    click_link AGR_BTN_NEW_RULE
    select 'Profit Split', from: AGR_SELECT_RULE_TYPE
    click_button AGR_BTN_ADD_RULE
    fill_in AGR_INPUT_RULE_RATE, with: 50
    click_button AGR_BTN_CREATE_RULE

    # submit for approval
    fill_in AGR_INPUT_CHANGE_REASON, with: 'The change reason'
    click_button AGR_BTN_SUBMIT_FOR_APPROVAL
    agr_link = current_path
  end

  in_browser(org2_user) do
    sign_in org2_user
    visit agr_link
    click_button AGR_BTN_ACCEPT
  end

end
