module SchedulesHelper
  def return_trip_button(destination, origin, schedule_type)
    params = { s1: destination.to_param, s2: origin.to_param, type: schedule_type }
    button_to 'Show Return Trip',
              '?' + params.map { |param, val| [param, val].join('=') }.join('&'),
              class: 'btn btn-info'
  end
end
