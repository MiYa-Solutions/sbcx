class JobImport < RecordsImport


  def save
    if imported_jobs.map(&:valid?).all?
      imported_jobs.each(&:save!)
      true
    else
      imported_jobs.each_with_index do |product, index|
        product.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_jobs
    @imported_jobs ||= load_imported_jobs
  end

  def  import_count
    @import_count ||= 0
  end


  def load_imported_jobs
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      job = ServiceCall.find_by_id(row["id"]) || ServiceCall.new_from_params(@user.organization, PermittedParams.new(ActionController::Parameters.new(service_call: row.to_hash), @user).service_call)
      job.attributes = row.to_hash unless job.new_record?
      job
    end
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end
end