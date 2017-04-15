module Modules
  class FavoriteRecipes < Grape::API
    prefix 'api'
    format :json

    helpers do
      include SessionHelper
      include UserHelpers
    end

    resource :favorite_recipes do

      ###POST /api/favorite_recipes
      desc 'Add favorite recipe', {
      is_array: true,
      success: { message: 'success' },
      failure: [{ code: 406, message: 'Invalid users token or recipe id' },
                { code: 400, message: 'This recipe already exists' }]
      }
      params do
        requires :user_token, type: String, desc: 'users token'
        requires :recipe_id, type: String, desc: 'id recipe'
        optional :notes, type: String, desc: 'notes'
      end
      post do
        all_params = declared(params, include_missing: false).to_hash
        user = get_user_from_token(all_params['user_token'])
        recipe = Recipe.find_by id: all_params['recipe_id']

        if user && recipe
          fr = FavoriteRecipe.find_by user: user, recipe: recipe
          if fr
            status 400
            return { message: 'This recipe already exists' }
          end

          f = FavoriteRecipe.new
          f.user = user
          f.recipe = recipe
          f.note = all_params['notes']
          return { message: 'success' } if f.save
        end
        status 406
        { error: 'Invalid users token or recipe id' }
      end

      ###GET /api/favorite_recipes/:user_token
      desc 'Get favorite recipes', {
      is_array: true,
      success: { message: 'success' },
      failure: [{ code: 406, message: 'Invalid users token' }]
      }
      params do
        requires :user_token, type: String, desc: 'users token'
      end
      get ':user_token' do
        all_params = declared(params, include_missing: false).to_hash
        user = get_user_from_token(all_params['user_token'])
        if user
          #FavoriteRecipe.where(user: user).find_each do |recipe|
          #  present recipe, with: Entities::FavoriteRecipeEntities
          #end
          #present FavoriteRecipe.find_by user:user, with: Entities::FavoriteRecipeEntities
          m = FavoriteRecipe.where(user: user)
          #m = FavoriteRecipe.find_by user:user
          present m, with: Entities::FavoriteRecipeEntities
        else
          status 406
          { error: 'Invalid users token' }
        end
      end

      ###DELETE /api/favorite_recipes/id
      desc 'Delete favorite recipe', {
      is_array: true,
      success: { message: 'success' },
      failure: [{ code: 406, message: 'Invalid users token or recipe id' }]
      }
      params do
        requires :user_token, type: String, desc: 'users token'
        requires :favorite_recipe_id, type: String, desc: 'favorite recipe id'
      end
      delete ':favorite_recipe_id' do
        all_params = declared(params, include_missing: false).to_hash
        user = get_user_from_token(all_params['user_token'])
        if user
          fr = FavoriteRecipe.find_by user: user, recipe_id: all_params['favorite_recipe_id'].to_i
          if fr
            FavoriteRecipe.destroy(fr)
            { message: 'success' }
          end
        end
        status 406
        { error: 'Invalid users token or recipe id' }
      end

    end
  end
end