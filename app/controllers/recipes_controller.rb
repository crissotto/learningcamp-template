# frozen_string_literal: true

class RecipesController < ApplicationController

  before_action :set_recipe, only: %i[edit update show destroy] 
  
  
  def index
    @recipes = Recipe.all
    @pagy, @records = pagy(@recipes)
  end

  def show; end

  def new 
    @recipe = Recipe.new
  end

  def edit; end


  def create 
    @recipe = Recipe.new(user_id: current_user.id)


    if @recipe.save 
      render :show, notice: 'Recipe was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @recipe = Recipe.find(params[:id])  # find the recipe with the given id

    if @recipe.update!(preference_params)
      redirect_to recipes_path, notice: 'Recipe was successfully updated.'   # if the preference is updated successfully, redirect to the preferences page with a success message
    else
      render :edit, status: :unprocessable_entity   # if the preference is not updated, render the edit template with an unprocessable entity status
    end
  end

  def edit; end

  def destroy # destroy a preference
    @recipe = current_user.recipes.find(params[:id]) # find the preference to be destroyed

    if @recipe.destroy
      redirect_to recipes_path, notice: 'Recipe was successfully destroyed.' # redirect to the preferences page
    else
      redirect_to recipes_path, notice: 'Recipe was not destroyed.' #  if the preference is not destroyed, redirect to the preferences page with a failure message

    end
  end

  def show
    @recipe = current_user.recipes.find(params[:id])  # find the preference to be shown
  end

    private
    
    def set_recipe
      @recipe = Recipe.find(params[:id])  # find  the recipe with the given id

    end

    def  recipe_params
      params.require(:recipe).permit(:ingredients)
    end
end
