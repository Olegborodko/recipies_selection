require "spec_helper"
require "rails_helper"
require "database_cleaner"
require "email_spec"
require "support/factory_girl"

include SessionHelper
include UserHelpers

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

describe "Favorite recipes" do
  include ActiveJob::TestHelper
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  before(:all) do
    @recipe = create(:recipe)
    @user = create(:user)
    @token = token_encode(@user.rid)

    @favorite_recipe = create(:favorite_recipe, user_id: @user.id)
  end

  after do
    clear_enqueued_jobs
  end

  it "Add favorite recipe" do
    all_params = { recipe_id: @recipe.id, notes: 'my favorite number 1', api_key: @token }
    post '/api/favorite_recipes', params: all_params
    expect(response.status).to eq 201
  end

  it "Add favorite recipe (already exists)" do
    FavoriteRecipe.create(user: @user, recipe: @recipe)
    all_params = { recipe_id: @recipe.id, notes: 'my favorite number 1', api_key: @token }
    post '/api/favorite_recipes', params: all_params
    expect(response.body).to include('already exists')
    expect(response.status).to eq 400
  end

  it "Add favorite recipe (error)" do
    all_params = { recipe_id: 0, notes: 'my favorite number 1', api_key: @token }
    post '/api/favorite_recipes', params: all_params
    expect(response.status).to eq 406
  end

  it "Get favorite recipes" do
    all_params = { api_key: @token }
    get '/api/favorite_recipes', params: all_params
    expect(response.status).to eq 200
  end

  it "Get favorite recipes (error)" do
    @user.unauthorized!
    @user.save
    all_params = { api_key: @token }
    get '/api/favorite_recipes', params: all_params
    expect(response.status).to eq 406
  end

  it "Delete favorite recipe" do
    all_params = { api_key: @token, favorite_recipe_id:  1 }
    delete '/api/favorite_recipes', params: all_params
    expect(response.status).to eq 200
  end

  it "Delete favorite recipe (error)" do
    all_params = { api_key: @token, favorite_recipe_id: 0 }
    delete '/api/favorite_recipes', params: all_params
    expect(response.status).to eq 406
  end


end