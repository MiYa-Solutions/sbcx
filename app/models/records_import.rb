class RecordsImport

  # switch to ActiveModel::Model in Rails 4
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file
  attr_accessor :klass

  MAX_RECORD_COUNT = 100

  def initialize(user, attributes = {})
    @user = user
    attributes.each { |name, value| send("#{name}=", value) }
    @batch_size = 50
    @batch_num
    @batch = []
  end

  def persisted?
    false
  end

  def save

    @spreadsheet = open_file
    if @spreadsheet.last_row <= MAX_RECORD_COUNT + 1
      import_spreadsheet
    else
      errors.add :max_records, "Your file contains #{@spreadsheet.last_row - 1} records, however you can't import more than #{MAX_RECORD_COUNT} at once. Please split the CSV file to multiple smaller files and try again."
      false
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


  protected
  def sanitized_batch(records)
    records.select { |r| r.valid? }.collect { |r| r.attributes }
  end

  def static_attributes
    {}
  end

  # subclass is expected to implement this method to ensure only authorized params are allowed
  def authorized_params(hash)
    ActionController::Parameters.new
  end

  private

  def import_spreadsheet
    calc_num_of_batches

    (1..@batch_num).each do |i|
      records = load_batch(i)

      records.each_with_index do |record, index|
        unless record.valid?
          record_index = @batch_size*(i-1) + index
          record.errors.full_messages.each do |message|
            errors.add :base, "Row #{record_index + 2}: #{message}"
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

  def error_import_summary
    record_count = @spreadsheet.last_row - 1
    fail_count   = errors.size

    if errors.messages[:max_records]
       "<h4> Import Summary </h4>
       <ul>
       <li>Records to import: #{record_count}</li>
       <li>Failed records: #{record_count}</li>
       <li>Imported successfully: 0
      </ul>
      <h4> Import Failed! </h4>
      <ul>
        #{errors.messages[:max_records].map { |m| "<li>#{m}</li>" }.join}
      </ul>"
    else
       "<h4> Import Summary </h4>
       <ul>
         <li>Records to import: #{record_count}</li>
         <li>Failed records: #{fail_count}</li>
         <li>Imported successfully: #{record_count - fail_count}
      </ul>
      <h4> Failed Records </h4>
      <ol>
        #{errors.messages[:base].map { |m| "<li>#{m}</li>" }.join}
      </ol>"
    end
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
      record = the_class.find_by_id(row['id']) || the_class.new_from_params(@user.organization, authorized_params(row.to_hash))
      record
    end
    post_batch_load(batch)
    batch

  end

  def import_batch(batch)
    klass.constantize.create batch
  end

  def post_batch_load(batch)
    # can be implemented by the subclass as a hook that runs per batch
  end


  def calc_num_of_batches
    res = ((@spreadsheet.last_row - 1) / @batch_size)

    if @spreadsheet.last_row.modulo(@batch_size) > 0
      res = res + 1
    end

    @batch_num = res

  end


end