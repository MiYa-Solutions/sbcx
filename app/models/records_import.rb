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

      records.each_with_index do |record, index|
        unless record.valid?
          record.errors.full_messages.each do |message|
            errors.add :base, "Row #{index+2}: #{message}"
          end
        end
      end

      import_batch(sanitized_batch(records))
    end

    if errors.size > 0
      false
    else
      true
    end

  end

  def import_summary
    if @spreadsheet
      if errors.size > 0
        error_import_summary
      else
        no_error_import_summary
      end
    else
      ''
    end
  end

  def sanitized_batch(records)
    records.select { |r| r.valid? }.collect { |r| r.attributes }
  end

  protected

  def static_attributes
    {}
  end

  private

  def error_import_summary
    record_count = @spreadsheet.last_row - 1
    fail_count = errors.size
    "<h4> Import Summary </h4>
     <ul>
     <li># records to import: #{record_count}</li>
     <li># failed records: #{fail_count}</li>
     <li># Imported successfully: #{record_count - fail_count}
    </ul>
    <h4> Failed Records </h4>
    <ul>
      #{errors.messages[:base].map {|m| "<li>#{m}</li>"}.join('\n')}
    </ul>
"



  end

  def no_error_import_summary
    record_count = @spreadsheet.last_row - 1
    "<h4> Import Summary </h4>
     <ul>
     <li> #{record_count} records imported successfully </li>
    </ul>"
  end

  def open_file
    case File.extname(file.original_filename)
      when ".csv" then
        Roo::Csv.new(file.path)
      when ".xls" then
        Roo::Excel.new(file.path)
      when ".xlsx" then
        Roo::Excelx.new(file.path)
      else
        raise "Unknown file type: #{file.original_filename}"
    end
  end

  def load_batch(batch_index)
    header    = @spreadsheet.row(1)
    first_row = ((batch_index - 1)*@batch_size + 2)
    last_row  = (first_row + @batch_size) > @spreadsheet.last_row ? @spreadsheet.last_row : (first_row + @batch_size)
    the_class = klass.constantize

    batch = (first_row..last_row).map do |i|
      row = Hash[[header, @spreadsheet.row(i)].transpose]
      row.merge!(static_attributes)

      # todo add permitted params to ensure unauthorized  attributes are being populated
      record = the_class.find_by_id(row['id']) || the_class.new_from_params(@user.organization, row.to_hash)
      record
    end
    post_batch_load(batch)
    batch

  end

  def import_batch(batch)
    klass.constantize.create batch
  end

  def post_batch_load(batch)

  end


  def calc_num_of_batches
    res = ((@spreadsheet.last_row - 1) / @batch_size)

    if @spreadsheet.last_row.modulo(@batch_size) > 0
      res = res + 1
    end

    @batch_num = res

  end


end