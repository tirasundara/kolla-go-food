class DateValidator < ActiveModel::Validator
  def validate(record)
    if !record.valid_from.nil? && !record.valid_through.nil?
      if record.valid_through < record.valid_from
        record.errors[:valid_through] << "must be greater than or equal to valid_from"
      end
    end
  end
end
