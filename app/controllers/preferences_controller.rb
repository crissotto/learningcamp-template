# frozen_string_literal: true

class PreferencesController < ApplicationController

  def index
    @preferences = current_user.preferences.includes(:user)
    @pagy, @records = pagy(@preferences)
  end

  def show; end

  def new 
    @preference = Preference.new 
  end
  
  def edit; end


  def create # create a function to create a new preference
    @preference = current_user.preferences.new(preference_params) # create a new preference for the current user

    if @preference.save  # if the preference is saved successfully
      redirect_to preferences_path, notice: 'Preference was successfully created.'  # redirect to the preferences page with a success message
    else
      render :new, status: :unprocessable_entity  # if the preference is not saved, render the new template with an unprocessable entity status
    end
  end

  def update
    @preference = Preference.find(params[:id])  # find the preference with the given id

    if @preference.update(preference_params)
      redirect_to preferences_path, notice: 'Preference was successfully updated.'   # if the preference is updated successfully, redirect to the preferences page with a success message
    else
      render :edit, status: :unprocessable_entity   # if the preference is not updated, render the edit template with an unprocessable entity status

    end
  end

  def destroy # destroy a preference
    @preference = current_user.preferences.find(params[:id]) # find the preference to be destroyed

    if @preference.destroy
      redirect_to preferences_path, notice: 'Preference was successfully destroyed.' # redirect to the preferences page
    else
      redirect_to preferences_path, notice: 'Preference was not destroyed.' #  if the preference is not destroyed, redirect to the preferences page with a failure message

    end
  end

  def show
    @preference = current_user.preferences.find(params[:id])  # find the preference to be shown

  end

  def set_preference
    @preference = Preference.find(params[:id])  # find the preference to be updated
  end

  private

  def preference_params 
    params.require(:preference).permit(:name, :description, :restriction)  # permit the name, description and restriction fields for the preference
  end
end