class AgrVersionDiffService < AbstractController::Base
  include AbstractController::Rendering
  include AbstractController::Layouts
  include AbstractController::Helpers
  include AbstractController::Translation
  include AbstractController::AssetPaths
  include Rails.application.routes.url_helpers
  helper ApplicationHelper
  self.view_paths = "app/views"

  def initialize(v1, v2)
    @v1 = v1
    @v2 = v2
  end

  def html_description
    render_to_string 'agreements/agreement_diff/_diff_table', v1: @v1, v2: @v2
  end

  def self.get_rules_for_versions(ver1, ver2)
    PaperTrail::Version.where(item_type: 'PostingRule', assoc_id: ver1).
        where('created_at < ? AND created_at > ?', ver1.version.created_at, ver2.version.created_at).
        all.map(&:reify)
  end
end