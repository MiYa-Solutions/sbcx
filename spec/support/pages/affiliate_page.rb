class AffiliatePage < SitePrism::Page
  set_url_matcher /\/affiliates\/\d+/

  element :title, 'div.affiliate_title'
end