class DogHousesController < ApplicationController

  def show
    dog_house = DogHouse.find_by(id: params[:id])
    if dog_house
      render json: dog_house, include: :reviews
    else
      render json: { error: "Dog house not found" }, status: :not_found
    end
  end

end
