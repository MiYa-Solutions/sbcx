class SbcxPage < SitePrism::Page
  element :success_flash, 'div.alert-success'
  element :notice_flash, 'div.alert-notice'
  element :error_flash, 'div.alert-error'
  elements :autocomplete_results, 'ul.ui-autocomplete li.ui-menu-item a'

  def fill_in_autocomplete(element, query, select: nil)
    element.native.send_keys(*query.chars)
    wait_for_autocomplete_results

    selector = %Q{ul.ui-autocomplete li.ui-menu-item a:contains("#{select}")}
    page.execute_script %Q{ $('#{selector}').trigger('mouseenter').click() }
  end

end