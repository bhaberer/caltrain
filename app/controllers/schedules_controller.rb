class SchedulesController < ApplicationController
  def trip
    @stations = Station.all.map { |s| [s.name, s.to_param] }
    unless params[:s1].nil? || params[:s2].nil?
      @start = Station.find_by_param(params[:s1])
      @ending = Station.find_by_param(params[:s2])
      travel_dir = @start.order < @ending.order ? :south : :north
      @trains = (@start.trains & @ending.trains)
      @trains.delete_if { |train| train.direction != travel_dir }
    end
  end

  private

  def traveling_direction(start, ending)
    start.order < ending.order ? :south : :north
  end
end
