# frozen_string_literal: true

class RecipeGeneratorService
  attr_reader :message, :user

  OPENAI_TEMPERATURE = ENV.fetch('OPENAI_TEMPERATURE', 0).to_f
  OPENAI_MODEL = ENV.fetch('OPENAI_MODEL', 'gpt-4')

  def initialize(message, user_id)
    @message = message
    @user = User.find(user_id)
  end

  def call
    check_valid_message_length
    response = message_to_chat_api
    create_recipe(response)
  end

  private

  def check_valid_message_length
    error_msg = I18n.t('api.errors.invalid_message_length')
    raise RecipeGeneratorServiceError, error_msg unless !!(message =~ /\b\w+\b/)
  end

  def message_to_chat_api
    openai_client.chat(parameters: {
                         model: OPENAI_MODEL,
                         messages: request_messages,
                         temperature: OPENAI_TEMPERATURE
                       })
  end

  def request_messages
    system_message + new_message
  end

  def system_message
    [{ role: 'system', content: prompt }]
  end

  def prompt
    <<~CONTENT
      You are a helpful assistant that generates recipes based on user input. 
      The user has the following preferences:
      - Dietary Restrictions: #{user.dietary_restrictions.join(', ')}
      - Preferred Ingredients: #{user.preferred_ingredients.join(', ')}
      - Avoided Ingredients: #{user.avoided_ingredients.join(', ')}

      Create a recipe in JSON format with the following structure:
      {
        "name": "Dish Name",
        "content": "Recipe content including ingredients, instructions, and cooking time."
      }
      Use the ingredients provided by the user to create a delicious recipe while adhering to their preferences.
    CONTENT
  end

  def new_message
    [
      { role: 'user', content: "Ingredients: #{message}" }
    ]
  end

  def openai_client
    @openai_client ||= OpenAI::Client.new
  end

  def create_recipe(response)
    parsed_response = response.is_a?(String) ? JSON.parse(response) : response
  content = JSON.parse(parsed_response.dig('choices', 0, 'message', 'content'))

  # Assuming you have a Recipe model to save the recipe
  recipe = Recipe.create!(name: content['name'], content: content['content'])

  # Return the created recipe as a hash
  {
    name: recipe.name,
    content: recipe.content
  }
  rescue JSON::ParserError => exception
  raise RecipeGeneratorServiceError, exception.message
  rescue ActiveRecord::RecordInvalid => exception
  raise RecipeGeneratorServiceError, exception.message
  end
end
