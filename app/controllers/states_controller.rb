# frozen_string_literal: true

class StatesController < ApplicationController
  before_action :set_state, only: %i[show update destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]

  def index
    @states = State.all
    render json: @states
  end

  def show
    render json: @state
  end

  def create
    @state = State.new(state_params)
    if @state.save
      render json: @state, status: :created
    else
      render json: @state.errors, status: :unprocessable_entity
    end
  end

  def update
    if @state.update(state_params)
      render json: @state
    else
      render json: @state.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @state.destroy
    head :no_content
  end

  private

  def set_state
    @state = State.find(params[:id])
  end

  def state_params
    params.require(:state).permit(:name, :abbreviation)
  end
end
