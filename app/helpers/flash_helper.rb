module FlashHelper
  ALERT_TYPES = [:error, :info, :success, :warning]

  def twitterized_type(type)
    case type.to_s
    when 'alert'
      "warning"
    when 'error'
      "danger"
    when 'notice'
      "info"
    when 'success'
      "success"
    else
      type.to_s
    end
  end
end
