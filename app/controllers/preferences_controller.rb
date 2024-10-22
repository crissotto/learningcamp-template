# frozen_string_literal: true

class PreferencesController < ApplicationController
  def index
    @preferences = current_user.preferences.includes(:user)
    @pagy, @records = pagy(@preferences)
  end

  def create # create a function to create a new preference

    @preference = current_user.preferences.new(preference_params) #  create a new preference for the current user

    if @preference.save  # if the preference is saved successfully

      redirect_to preferences_path, notice: 'Preference was successfully created.'  # redirect to the preferences page with a success message

    else
      render :new, status:  :unprocessable_entity  # if the preference is not saved, render the new template with an unprocessable entity status

    end
  end

  private

  def preference_params 
    params.require(:preference).permit(:name, :description, :restriction)  # permit the name, description and restriction fields for the preference

  end
end