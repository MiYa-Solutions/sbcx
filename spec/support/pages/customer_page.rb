class CustomerPage < SbcxPage
  set_url_matcher /\/customers\/\d+/

  element :title, 'div.customer_title'
end