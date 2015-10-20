class SchedulesController < ApplicationController
  def trip
    @stations = Station.all.map { |s| [s.name, s.to_param] }
    if params[:s1] == params[:s2]
      render :trip, notice: "Stations can't be the same."
    elsif params[:s1].present? && params[:s2].present?
      @origin = Station.find_by_param(params[:s1])
      @destination = Station.find_by_param(params[:s2])

      @trains = Train.traveling_between(@origin, @destination, params[:type])
      @trains.sort! { |a,b| a.number.to_s[1,2] <=> b.number.to_s[1,2] }
    end
  end

  private

  def traveling_direction(start, ending)
    start.order < ending.order ? :south : :north
  end
end
