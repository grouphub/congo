module ApplicationHelper
  def flashes_json
    flash
      .map { |type, message|
        {
          type: bootstrap_class_for(type),
          message: message
        }
      }
      .to_json
  end

  def bootstrap_class_for flash_type
    case flash_type.to_sym
      when :success
        'success'
      when :error
        'danger'
      when :alert
        'block'
      when :notice
        'info'
      else
        flash_type.to_s
    end
  end
end

