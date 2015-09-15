module TrainsHelper
  def train_class(train)
    case train.schedule_type.to_sym
    when :limited then :warning
    when :bullet then :danger
    when :local then :info
    end
  end
end
