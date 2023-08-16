# frozen_string_literal: true

class CitiesController < ApplicationController
  before_action :set_city, only: %i[show update destroy]

  def index; end

  def show
    render json: @city
  end

  def create
    @city = City.new(city_params)
    if @city.save
      render json: @city, status: :created
    else
      render json: @city.errors, status: :unprocessable_entity
    end
  end

  def update
    if @city.update(city_params)
      render json: @city
    else
      render json: @city.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @city.destroy
    head :no_content
  end

  def search
    @cities = City.search(params[:state], params[:name])
  end

  private

  def set_city
    @city = City.find(params[:id])
  end

  def city_params
    params.require(:city).permit(:name, :state_id)
  end
end
