class Statement < ActiveRecord::Base
  validates_presence_of :data, :statementable
  belongs_to :statementable, polymorphic: true

  def save(serializer)
    self.data = serializer.new(statementable).serialize.to_json
    super()
  end

end
