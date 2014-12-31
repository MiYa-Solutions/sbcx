class ProjectResultFormater
  constractor: ->

  formatResult: (proj_json) ->
    HandlebarsTemplates['projects/project_autocomplete'](proj_json)
  projFormatSelection = (proj_json, container) ->
    proj_json.name

jQuery ->
  formater = new ProjectResultFormater
  $('#project-jobs').dataTable
    dom: "t<'row-fluid'<'span7'i><'span5'p>>"
    pagingType: 'simple'
    iDisplayLength: 5
    aoColumnDefs: [{ 'bSortable': false, 'aTargets': [ 1,2,3,4 ] }]
    order: [[0, 'desc']]
    aLengthMenu: [10, 25, 50]
    sPaginationType: "bootstrap"
    processing: true
    stateSave: true
    serverSide: true
    sAjaxSource: '/service_calls/'

    fnServerData: (sSource, aoData, fnCallback) ->
      aoData.push
        name: "project_id"
        value: $('#project-jobs').data('project-id')
      aoData.push
        name: "table_type"
        value: 'project_jobs'

      $.getJSON sSource, aoData, (json) ->
        fnCallback json


  $('#project_provider_id').on 'change', ->
    $('#project_customer_name').attr("data-ref-id", $(this).val())
    $('#project_customer_name').val('')
    $('#project_customer_id').val('')

  update_agreement_select($('#project_provider_id'), $('#project_provider_agreement_id'))

  $('#project_provider_id').change ->
    $(agr_props).hide(400)
    update_agreement_select($('#project_provider_id'), $('#project_provider_agreement_id'))

  $(".project-autocomplete").select2
    placeholder: "Search for a project"
    minimumInputLength: 2
    allowClear: true
    ajax: # instead of writing the function to execute the request we use Select2's convenient helper
      url: "/projects"
      dataType: "json"
      quietMillis: 250
      data: (term, page) ->
        sSearch: term # search term
        page: page
        iDisplayStart: page || 1

      results: (data, page) -> # parse the results into the format expected by Select2.
        more = (page * 30) < data.iTotalRecords # whether or not there are more results available
        results: data.aaData
        total_count: data.iTotalDisplayRecords
        more: more

      cache: true

    initSelection: (element, callback) ->

      # the input tag has a value attribute preloaded that points to a preselected repository's id
      # this function resolves that id attribute to an object that select2 can render
      # using its formatResult renderer - that way the repository name is shown preselected
      id = $(element).val()
      if id isnt ""
        $.ajax("/projects/" + id,
          dataType: "json"
        ).done (data) ->
          data.text = data.name
          callback data

    formatResult: formater.formatResult
    formatSelection: formater.projFormatSelection
    dropdownCssClass: "bigdrop"

    escapeMarkup: (m) -> # we do not want to escape markup since we are displaying html in results
      m


