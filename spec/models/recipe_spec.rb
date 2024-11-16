# == Schema Information
#
# Table name: recipes
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  ingredients :text
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_recipes_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  let!(:user) { User.create(email: 'test@example.com', password: 'password') } # Assuming you have a User model

  describe "POST /recipes" do
    it "creates a recipe successfully" do
      post recipes_path, params: { recipe: { name: 'Pasta', description: 'Delicious pasta recipe.', ingredients: 'Pasta, Tomato Sauce', user_id: user.id } }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to eq({
        'message' => 'Recipe created successfully',
        'recipe' => {
          'id' => be_present,
          'name' => 'Pasta',
          'description' => 'Delicious pasta recipe.',
          'ingredients' => 'Pasta, Tomato Sauce',
          'user_id' => user.id,
          'created_at' => be_present,
          'updated_at' => be_present
        }
      })
    end

    it "returns unprocessable entity for invalid recipe" do
      post recipes_path, params: { recipe: { name: '', description: '', ingredients: '', user_id: nil } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({
        'message' => 'Error creating recipe',
        'errors' => ["Name can't be blank", "User  must exist"]
      })
    end
  end
end