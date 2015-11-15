class RecordsImport

  # switch to ActiveModel::Model in Rails 4
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file
  attr_accessor :klass

  def initialize(user, attributes = {})
    @user = user
    attributes.each { |name, value| send("#{name}=", value) }
    @batch_size = 10
    @batch_num
    @batch = []
  end

  def persisted?
    false
  end

  def save

    @spreadsheet = open_file
    calc_num_of_batches

    (1..@batch_num).each do |i|
      records = load_batch(i)
      import_batch(records)
    end

  end

  private

  def open_file
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def load_batch(batch_index)
    header = @spreadsheet.row(1)
    first_row = ((batch_index - 1)*@batch_size + 2)
    last_row = (first_row + @batch_size) > @spreadsheet.last_row ? @spreadsheet.last_row : (first_row + @batch_size)

    (first_row..last_row).map do |i|
      row = Hash[[header, @spreadsheet.row(i)].transpose]
      # todo add permitted params to ensure unauthorized  attributes are being populated
      record = klass.find_by_id(row['id']) || klass.new_from_params(user.organization, row.to_hash)
      record.attributes = row.to_hash unless record.new_record?
      record
    end

  end

  def import_batch(batch)
    klass.import batch
  end


  def calc_num_of_batches
    res = ((@spreadsheet.last_row - 1) / @batch_size)

    if @spreadsheet.last_row.modulo(@batch_size) > 0
     res = res + 1
    end

    @batch_num = res

  end


end