class RecipesController < ApplicationController

  def index
    @recipes = Recipe.all
    @result =
  end
end
