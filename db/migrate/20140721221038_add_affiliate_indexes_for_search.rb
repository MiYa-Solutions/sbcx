class AddAffiliateIndexesForSearch < ActiveRecord::Migration
  def up
    execute "CREATE INDEX organization_name ON organizations USING GIN(to_tsvector('english', name))"
    execute "CREATE INDEX organization_company ON organizations USING GIN(to_tsvector('english', company))"
  end

  def down
    execute 'drop index organization_name'
    execute 'drop index organization_company'
  end
end
