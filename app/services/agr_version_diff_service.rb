class AgrVersionDiffService < AbstractController::Base
  include AbstractController::Rendering
  include AbstractController::Layouts
  include AbstractController::Helpers
  include AbstractController::Translation
  include AbstractController::AssetPaths
  include Rails.application.routes.url_helpers
  helper ApplicationHelper
  helper AgrVersionDiffHelper
  self.view_paths = "app/views"

  def initialize(v1, v2)
    @v1 = v1 || Agreement.new
    @v2 = v2 || Agreement.new
  end

  def html_description
    render_to_string 'agreements/agreement_diff/_diff_table', v1: @v1, v2: @v2
  end

  def rules_diff
    @rules_diff ||= PaperTrail::Version.where(item_type: 'PostingRule', assoc_id: @v1).
        where('created_at < ? AND created_at > ?', @v1.version.try(:created_at), @v2.version.try(:created_at)).
        all.map(&:reify)
  end

  def different?
    if @v1.name != @v2.name
      return true
    end
    if @v1.payment_terms != @v2.payment_terms
      return true
    end
    if @v1.starts_at != @v2.starts_at
      return true
    end
    if @v1.ends_at != @v2.ends_at
      return true
    end
    rules_diff.size > 0 ? true : false
  end
end