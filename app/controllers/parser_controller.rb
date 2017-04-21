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
        @ingredients_url = Nokogiri::HTML(open(href+'/page/'+page_number.to_s))
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
          @ingredient.content = @ingredient_url.css('#stages > p').text.strip
          @ingredient.calories = @ingredient_url.css('#topContributors > li strong')[0].text.strip
          @ingredient.protein = @ingredient_url.css('#topContributors > li strong')[1].text.strip
          @ingredient.fat = @ingredient_url.css('#topContributors > li strong')[2].text.strip
          @ingredient.carbohydrate = @ingredient_url.css('#topContributors > li strong')[3].text.strip
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
      check_existing_rec_category = RecipeCategory.find_by_title(category)
      if nil.equal?(check_existing_rec_category)
        rec_category_new = RecipeCategory.new(title: category)
        rec_category_new.save!
        check_existing_rec_category = RecipeCategory.find_by_title(category)
      end

      recipes_hash.each do |recipe_name, href|
        check_existing_recipe = Recipe.find_by_name(recipe_name)
        if nil.equal?(check_existing_recipe)
          populate_recipe(check_existing_rec_category, href, recipe_name)
          numb_of_ingr = 0
          @recipe_ingr.each_with_object({}) do |name, link|
            link[name.text.strip] = name['href']
            ingr = Ingredient.find_by_href(name[:href])
            if nil.equal?(ingr)
              populate_other_ingredient(name)
            elsif name[:href] == ingr.href
              @recipe.ingredients << ingr
            end
            ri = @recipe.recipe_ingredients[numb_of_ingr]
            ri.number_of_ingredient = @recipe_url.css('#ingresList > li > span')[numb_of_ingr].text.strip
            ri.save!
            numb_of_ingr += 1
          end
          @recipe.save!
        end
      end
    end
  end

  def populate_other_ingredient(name)
    ingredient_url = Nokogiri::HTML(open(name[:href]))
    category_new = IngredientCategory.new(title: "Другие")
    category_new.save!
    check_existing_category = IngredientCategory.find_by_title("Другие")
    @ingredient = check_existing_category.ingredients.create
    @ingredient.name = ingredient_url.css('#singleFile > h1').text.strip
    @ingredient.href = name[:href]
    @ingredient.content = ingredient_url.css('#stages > p').text.strip
    @ingredient.calories = ingredient_url.css('#topContributors > li strong')[0].text.strip
    @ingredient.protein = ingredient_url.css('#topContributors > li strong')[1].text.strip
    @ingredient.fat = ingredient_url.css('#topContributors > li strong')[2].text.strip
    @ingredient.carbohydrate = ingredient_url.css('#topContributors > li strong')[3].text.strip
    @recipe.ingredients << @ingredient

    @ingredient.save!
  end

  def populate_recipe(check_existing_rec_category, href, recipe_name)
    @recipe_url = Nokogiri::HTML(open(href))
    @recipe = check_existing_rec_category.recipes.create
    @recipe.name = recipe_name
    @recipe.content = @recipe_url.css('#stages div.instructions').text.strip
    @recipe.cooking_time = @recipe_url.css('#stages > p').text.strip
    @recipe.calories = @recipe_url.css('#topContributors > li:nth-child(1) > strong').text.strip
    @recipe.protein = @recipe_url.css('#topContributors > li:nth-child(2) > strong').text.strip
    @recipe.fat = @recipe_url.css('#topContributors > li:nth-child(3) > strong').text.strip
    @recipe.carbohydrate = @recipe_url.css('#topContributors > li:nth-child(4) > strong').text.strip

    @recipe_ingr = @recipe_url.css('#ingresList > li > a')
  end
end


