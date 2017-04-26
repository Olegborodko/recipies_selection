class ParserController < ApplicationController

  def index

    @main_page = Nokogiri::HTML(open("http://namnamra.com/"))
    @ingredient_category_url = Nokogiri::HTML(open("http://namnamra.com/ingredients"))

    @ingredient_category_links = @ingredient_category_url
                                     .css('div#aside.clearfix div.asideBlock ul.rubricator.lastrub li a[href]')
    ingr_cat_links = @ingredient_category_links.each_with_object({}) do |n, h|
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
      ingredients_hash.each do |name, link|
        @ingredient_url = Nokogiri::HTML(open(link))
        iu = @ingredient_url.css('#topContributors > li strong')
        create_ingredient(check_existing_category, name, iu, link)
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
      check_recipe_category = RecipeCategory.find_or_create_by(title: category)

      recipes_hash.each do |recipe_name, href|
        check_existing_recipe = Recipe.find_by_name(recipe_name)
        next unless check_existing_recipe.nil?
        @recipe_url = Nokogiri::HTML(open(href))
        @recipe = create_recipe(check_recipe_category, recipe_name)
        @recipe_ingr = @recipe_url.css('#ingresList > li > a')
        numb_of_ingr = 0

        @recipe_ingr.each_with_object({}) do |component, url|
          url[component.text.strip] = component['href']
          name = component.text.strip
          link = component[:href]
          ingr = Ingredient.find_by_href(component[:href])

          if ingr.nil?
            @ingredient_url = Nokogiri::HTML(open(component[:href]))
            iu = @ingredient_url.css('#topContributors > li strong')
            check_existing_category = IngredientCategory.find_or_create_by(title: 'Другие')
            @ingredient = create_other_ingredient(check_existing_category, iu, link, name)
            @recipe.ingredients << @ingredient
          elsif link == ingr.href
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

  def create_other_ingredient(check_existing_category, iu, link, name)
    check_existing_category.ingredients.find_or_create_by(
        name: name,
        href: link,
        content: @ingredient_url.css('#stages > p').text.strip,
        calories: iu[0].text.strip,
        protein: iu[1].text.strip,
        fat: iu[2].text.strip,
        carbohydrate: iu[3].text.strip
    )
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

  def create_ingredient(check_existing_category, name, iu, link)
    create_other_ingredient(check_existing_category, iu, link, name)
  end
end