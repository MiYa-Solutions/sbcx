class JobPage < SitePrism::Page
  set_url "/service_calls"
  set_url_matcher /service_calls/
  element :job_status, 'span#service_call_status'
end