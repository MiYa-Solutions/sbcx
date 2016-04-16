class JobPage < SbcxPage
  set_url_matcher /\/service_calls\/\d+/

  element :title, 'div.job_title'
  element :status, 'span#service_call_status'
  element :info_tab, '#myJobShowTab > li:nth-child(2) > a'
  element :address1, "span[data-attribute='address1']"
  element :customer_name, 'span#customer-name'
  def show_info
    info_tab.click
  end
end