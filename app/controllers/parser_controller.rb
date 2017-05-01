class ParserController < ApplicationController

  PAGES = 1000
  PAGE = 24
  def parser
    @main_page = Nokogiri::HTML(open("http://namnamra.com/"))
    @ingredient_category_url = Nokogiri::HTML(open("http://namnamra.com/ingredients"))

    ingredients(links_ci)
    ingredient_save

    recipes(links_cr)
    recipe_save
  end

  def recipe_save
    @all_recipes.each do |category, recipes_hash|
      check_recipe_category = RecipeCategory.find_or_create_by(title: category)

      recipes_hash.each do |recipe_name, href|
        check_recipe = Recipe.find_by_name(recipe_name)
        next unless check_recipe.nil?
        @recipe_url = Nokogiri::HTML(open(href))
        @recipe = create_recipe(check_recipe_category, recipe_name)
        @recipe_ingr = @recipe_url.css('#ingresList > li > a')
        ingnum = 0

        ingr_to_rec(ingnum)
        @recipe.save!(validate: false)
      end
    end
  end

  def ingr_to_rec(ingnum)
    @recipe_ingr.each_with_object({}) do |component, url|
      url[component.text.strip] = component['href']
      name = component.text.strip
      link = component[:href]
      ingr = Ingredient.find_by_href(component[:href])

      if ingr.nil?
        @ingredient_url = Nokogiri::HTML(open(component[:href]))
        iu = @ingredient_url.css('#topContributors > li strong')
        check_category = IngredientCategory.find_or_create_by(title: 'Другие')
        @ingredient = create_other_ingredient(check_category, iu, link, name)
        @recipe.ingredients << @ingredient
      elsif link == ingr.href
        @recipe.ingredients << ingr
      end
      ri = @recipe.recipe_ingredients[ingnum]
      ri.number_of_ingredient = @recipe_url.css('#ingresList > li > span')[ingnum].text.strip
      ri.save!
      ingnum += 1
    end
  end

  def recipes(rc_links)
    @recipes = {}
    @all_recipes = {}

    rc_links.each do |category_name, href|
      @all_recipes[category_name] = []
      (0..PAGES).step(PAGE) do |x|
        @recipes_url = Nokogiri::HTML(open(href+'/page/'+x.to_s))
        rec_url = @recipes_url.css('div.post > h5:nth-child(2) > a:nth-child(1)')

        recipes_hash = rec_url.each_with_object({}) do |recipe_name_tag, value|
          value[recipe_name_tag.text.strip] = recipe_name_tag['href']
        end

        @recipes.merge!(recipes_hash)

        if @all_recipes[category_name].empty?
          @all_recipes[category_name] = recipes_hash
        else
          @all_recipes[category_name].merge!(recipes_hash)
        end
      end
    end
  end

  def links_cr
    @recipes_category_links = @main_page.css('#aside > span > ul:nth-child(3) li a[href]')
    @recipes_category_links.each_with_object({}) do |n, h|
      h[n.text.strip] = n['href']
    end
  end

  def links_ci
    @ingredient_category_links = @ingredient_category_url
                                 .css('div#aside.clearfix div.asideBlock ul.rubricator.lastrub li a[href]')
    @ingredient_category_links.each_with_object({}) do |n, h|
      h[n.text.strip] = n['href']
    end
  end

  def ingredient_save
    @all_ingredients.each do |category, ingredients_hash|
      check_category = IngredientCategory.find_or_create_by(title: category)
      ingredients_hash.each do |name, link|
        @ingredient_url = Nokogiri::HTML(open(link))
        iu = @ingredient_url.css('#topContributors > li strong')
        create_ingredient(check_category, name, iu, link)
      end
    end
  end

  def ingredients(ic_links)
    @ingredients = {}
    @all_ingredients = {}

    ic_links.each do |category_name, href|
      @all_ingredients[category_name] = []
      (0..PAGES).step(PAGE) do |x|
        @ingredients_url = Nokogiri::HTML(open(href+'/page/'+x.to_s))
        ingredients_hash = @ingredients_url.css('div#postsContainer div.post h5 a.arecipe')

        ingr_hash = ingredients_hash.each_with_object({}) do |ingredient_name_tag, value|
          value[ingredient_name_tag.text.strip] = ingredient_name_tag['href']
        end
        @ingredients.merge!(ingr_hash)

        if @all_ingredients[category_name].empty?
          @all_ingredients[category_name] = ingr_hash
        else
          @all_ingredients[category_name].merge!(ingr_hash)
        end
      end
    end
  end

  def create_other_ingredient(check_category, iu, link, name)
    check_category.ingredients.find_or_create_by(
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

  def create_ingredient(check_category, name, iu, link)
    create_other_ingredient(check_category, iu, link, name)
  end
end