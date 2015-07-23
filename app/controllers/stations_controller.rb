class StationsController < ApplicationController
  before_action :set_station, only: [:show, :edit, :update, :destroy]

  def index
    @stations = Station.all
  end

  def show
    @south = @station.stops.where(direction: :south)
    @north = @station.stops.where(direction: :north)
  end

  def new
    redirect_to :root, notice: 'Stations are not created this way.'
  end

  def edit
  end

  def create
    redirect_to :root, notice: 'Stations are not created this way.'
  end

  def update
    respond_to do |format|
      if @station.update(station_params)
        format.html { redirect_to @station, notice: 'Station was successfully updated.' }
        format.json { render :show, status: :ok, location: @station }
      else
        format.html { render :edit }
        format.json { render json: @station.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    redirect_to :root, notice: 'Stations are not removed this way.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_station
      @station = Station.find_by_param(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def station_params
      params.require(:station).permit(:name, :order)
    end
end
