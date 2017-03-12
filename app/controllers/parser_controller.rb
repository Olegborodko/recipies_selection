class ParserController < ApplicationController

  def index

    @main_page = Nokogiri::HTML(open("http://namnamra.com/"))
    @ingredient_category_url = Nokogiri::HTML(open("http://namnamra.com/ingredients"))

    @ingredient_category_links = @ingredient_category_url
                                     .css('div#aside.clearfix div.asideBlock ul.rubricator.lastrub li a[href]')
    ingr_cat_links = @ingredient_category_links.each_with_object({}) do
    |n, h|
      h[n.text.strip] = n['href']
    end

    @ingredients = Hash.new
    @ingredients2 = Hash.new

    ingr_cat_links.each do |category_name, href|
      page_number = 0
      @ingredients2[category_name] = []
      while page_number < 1000
        @ingredients_url = Nokogiri::HTML(open(href+'/page/'+page_number.to_s))  #(open(href+'/page/'+page_number.to_s))
        ingredients_hash = @ingredients_url.css('div#postsContainer div.post h5 a.arecipe')

        ingr_hash = ingredients_hash.each_with_object({}) do |ingredient_name_tag, value|
          value[ingredient_name_tag.text.strip] = ingredient_name_tag['href']
        end
        @ingredients.merge!(ingr_hash)

        if @ingredients2[category_name].empty?
          @ingredients2[category_name] = ingr_hash
        else
          @ingredients2[category_name].merge!(ingr_hash)
        end
        page_number += 24
      end
    end

    @ingredients2.each do |category, ingredients_hash|
      check_existing_category = IngredientCategory.find_by_title(category)
      if nil.equal?(check_existing_category)
        category_new = IngredientCategory.new(title: category)
        category_new.save!
        check_existing_category = IngredientCategory.find_by_title(category)
      end
      ingredients_hash.each do |ingr_name, href|
        check_existing_ingredient = Ingredient.find_by_name(ingr_name)
        if nil.equal?(check_existing_ingredient)
          @ingredient_url = Nokogiri::HTML(open(href))
          @ingredient = check_existing_category.ingredients.create
          @ingredient.name = ingr_name
          @ingredient.href = href
          @ingredient.content = @ingredient_url.css('#stages > p').text
          @ingredient.calories = @ingredient_url.css('#topContributors > li strong')[0].text
          @ingredient.protein = @ingredient_url.css('#topContributors > li strong')[1].text
          @ingredient.fat = @ingredient_url.css('#topContributors > li strong')[2].text
          @ingredient.carbohydrate = @ingredient_url.css('#topContributors > li strong')[3].text
          @ingredient.save!
        end
      end
    end

    ##########    RECIPES     ##############

    @recipes_category_links = @main_page.css('#aside > span > ul:nth-child(3) li a[href]')
    rec_cat_links = @recipes_category_links.each_with_object({}) do |n, h|
      h[n.text.strip] = n['href']
    end

    @recipes = Hash.new
    @recipes2 = Hash.new

    rec_cat_links.each do |category_name, href|
      page_number = 0
      @recipes2[category_name] = []

      while page_number < 1000
        @recipes_url = Nokogiri::HTML(open(href+'/page/'+page_number.to_s))
        rec_url = @recipes_url.css('div.post > h5:nth-child(2) > a:nth-child(1)')

        recipes_hash = rec_url.each_with_object({}) do |recipe_name_tag, value|
          value[recipe_name_tag.text.strip] = recipe_name_tag["href"]
        end

        # unless recipes_hash.empty?
        @recipes.merge!(recipes_hash)

        if @recipes2[category_name].empty?
          @recipes2[category_name] = recipes_hash
        else
          @recipes2[category_name].merge!(recipes_hash)
        end
        page_number += 24
        # end
      end
    end

    @recipes2.each do |category, recipes_hash|
      check_existing_category = RecipeCategory.find_by_title(category)
      if nil.equal?(check_existing_category)
        category_new = RecipeCategory.new(title: category)
        category_new.save!
        check_existing_category = RecipeCategory.find_by_title(category)
      end
      recipes_hash.each do |recipe_name, href|
        check_existing_recipe = Recipe.find_by_name(recipe_name)
        if nil.equal?(check_existing_recipe)
          @recipe_url = Nokogiri::HTML(open(href))
          @recipe = check_existing_category.recipes.create
          @recipe.name = recipe_name
          @recipe.content = @recipe_url.css('#stages div.instructions').text.strip
          @recipe.cooking_time = @recipe_url.css('#stages > p').text.strip
          @recipe.ccal = @recipe_url.css('#stages > h2').text.strip

          # @recipe.ingredients = @recipe_url.css('#ingresList > li:nth-child(1) > a').text
          @recipe_ingr = @recipe_url.css('#ingresList > li > a').each_with_object({}) do |n, h|
            h[n.text.strip] = n['href']

            ingr = Ingredient.find_by_href(n[:href])
            unless n[:href] != ingr.href
              # p '1'
              @recipe.ingredients.to_a << ingr
            end
          @recipe.save!
          #
          end

        end
      end
    end
  end
end

