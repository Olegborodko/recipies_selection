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
      check_existing_category = IngredientCategory.find_or_create_by(title: category)
      # next unless check_existing_category.nil?
      # category_new = IngredientCategory.new(title: category)
      # category_new.save!
      # check_existing_category = IngredientCategory.find_by_title(category)
      # end
      ingredients_hash.each do |ingr_name, link|
        # check_existing_ingredient =
        @ingredient_url = Nokogiri::HTML(open(link))
        iu = @ingredient_url.css('#topContributors > li strong')
        create_ingredient(check_existing_category, ingr_name, iu, link)
        # next unless check_existing_ingredient.nil?
        # @ingredient = check_existing_category.ingredients.create
        # @ingredient.name = ingr_name
        # @ingredient.href = href
        # @ingredient.content = @ingredient_url.css('#stages > p').text.strip
        # @ingredient.calories = iu[0].text.strip
        # @ingredient.protein = iu[1].text.strip
        # @ingredient.fat = iu[2].text.strip
        # @ingredient.carbohydrate = iu[3].text.strip
        # @ingredient.save!
        # end
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
          value[recipe_name_tag.text.strip] = recipe_name_tag['href']
        end

        @recipes.merge!(recipes_hash)

        if @recipes2[category_name].empty?
          @recipes2[category_name] = recipes_hash
        else
          @recipes2[category_name].merge!(recipes_hash)
        end
        page_number += 24
      end
    end

    @recipes2.each do |category, recipes_hash|
      # check_existing_rec_category = RecipeCategory.find_by_title(category)
      check_recipe_category = RecipeCategory.find_or_create_by(title: category)
      # if nil.equal?(check_recipe_category)
      #   rec_category_new = RecipeCategory.new(title: category)
      #   rec_category_new.save!
      #   check_recipe_category = RecipeCategory.find_by_title(category)
      # end

      recipes_hash.each do |recipe_name, href|
        check_existing_recipe = Recipe.find_by_name(recipe_name)
        next unless check_existing_recipe.nil?
        @recipe_url = Nokogiri::HTML(open(href))
        @recipe = create_recipe(check_recipe_category, recipe_name)

        @recipe_ingr = @recipe_url.css('#ingresList > li > a')
        numb_of_ingr = 0
        @recipe_ingr.each_with_object({}) do |ingr_name, link|
          link[ingr_name.text.strip] = ingr_name['href']
          ingr = Ingredient.find_by_href(ingr_name[:href])
          if ingr.nil?
            @ingredient_url = Nokogiri::HTML(open(ingr_name[:href]))
            iu = @ingredient_url.css('#topContributors > li strong')
            # iu = Nokogiri::HTML(open(ingr_name[:href]))
            check_existing_category = IngredientCategory.find_or_create_by(title: 'Другие')
            # category_new = IngredientCategory.new(title: "Другие")
            # category_new.save!
            # IngredientCategory.find_or_create_by(ingredients.find_or_create_by(
            #   name: ingr_name,
            #   href: link,
            #   content: @ingredient_url.css('#stages > p').text.strip,
            #   calories: iu[0].text.strip,
            #   protein: iu[1].text.strip,
            #   fat: iu[2].text.strip,
            #   carbohydrate: iu[3].text.strip
            # ))
            @ingredient = check_existing_category.ingredients.find_or_create_by(
                name: ingr_name.text.strip,
                href: ingr_name[:href],
                content: @ingredient_url.css('#stages > p').text.strip,
                calories: iu[0].text.strip,
                protein: iu[1].text.strip,
                fat: iu[2].text.strip,
                carbohydrate: iu[3].text.strip
            )
            # @ingredient = check_existing_category.ingredients.create
            # @ingredient.ingr_name = ingredient_url.css('#singleFile > h1').text.strip
            # @ingredient.href = ingr_name[:href]
            # @ingredient.content = ingredient_url.css('#stages > p').text.strip
            # @ingredient.calories = ingredient_url.css('#topContributors > li strong')[0].text.strip
            # @ingredient.protein = ingredient_url.css('#topContributors > li strong')[1].text.strip
            # @ingredient.fat = ingredient_url.css('#topContributors > li strong')[2].text.strip
            # @ingredient.carbohydrate = ingredient_url.css('#topContributors > li strong')[3].text.strip
            @recipe.ingredients << @ingredient
            # @ingredient.save!
          elsif ingr_name[:href] == ingr.href
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

  def create_recipe(check_recipe_category, recipe_name)
    check_recipe_category.recipes.find_or_create_by(
        name: recipe_name,
        content: @recipe_url.css('#stages div.instructions').text.strip,
        cooking_time: @recipe_url.css('#stages > p').text.strip,
        calories: @recipe_url.css('#topContributors > li:nth-child(1) > strong').text.strip,
        protein: @recipe_url.css('#topContributors > li:nth-child(2) > strong').text.strip,
        fat: @recipe_url.css('#topContributors > li:nth-child(3) > strong').text.strip,
        carbohydrate: @recipe_url.css('#topContributors > li:nth-child(4) > strong').text.strip)
  end

  def create_ingredient(check_existing_category, ingr_name, iu, link)
    check_existing_category.ingredients.find_or_create_by(
        name: ingr_name,
        href: link,
        content: @ingredient_url.css('#stages > p').text.strip,
        calories: iu[0].text.strip,
        protein: iu[1].text.strip,
        fat: iu[2].text.strip,
        carbohydrate: iu[3].text.strip
    )
  end

    # def create_other_ingredient(check_existing_category, ingr_name.text.strip, iu, ingr_name[:href])
    #   # check_existing_category.ingredients.find_or_create_by(
    #   #   name: ingr_name.text.strip,
    #   #   href: ingr_name[:href],
    #   #   content: @ingredient_url.css('#stages > p').text.strip,
    #   #   calories: iu[0].text.strip,
    #   #   protein: iu[1].text.strip,
    #   #   fat: iu[2].text.strip,
    #   #   carbohydrate: iu[3].text.strip
    #   # )
    # end
end