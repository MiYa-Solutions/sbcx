module PaperTrail
  class Version < ActiveRecord::Base
    attr_accessible :assoc_id
  end
end