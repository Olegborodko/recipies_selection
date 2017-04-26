module Helpers

  def set_rec_category
    RecipeCategory.find(params[:recipe_category_id])
  end

  def set_ing_category
    IngredientCategory.find(params[:ingredient_category_id])
  end
end