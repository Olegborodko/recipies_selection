require 'rubygems'
require 'nokogiri'
require 'open-uri'

# MAIN_PAGE = Nokogiri::HTML(open("http://namnamra.com/"))
# BASE_INGREDIENT_PAGE = Nokogiri::HTML(open("http://namnamra.com/ingredients/page/"))
# FIRST_PAGE = 0
# LAST_PAGE = 696


class ParserController < ApplicationController

  def index

    @main_page = Nokogiri::HTML(open("http://namnamra.com/"))
    @ingredient_category_url = Nokogiri::HTML(open("http://namnamra.com/ingredients"))

    @ingredient_category_links = @ingredient_category_url
                                     .css('div#aside.clearfix div.asideBlock ul.rubricator.lastrub li a[href]')
                                     .each_with_object({}) do
    |n, h| h[n.text.strip] = n["href"]
    end

    @ingredients = Hash.new
    @ingredients2 = Hash.new
    @ingredient_category_links.each do |category_name, href|
      @ingredients_url = Nokogiri::HTML(open(href))
      ingredients_hash = @ingredients_url
                             .css('div#postsContainer div.post h5 a.arecipe')
                             .each_with_object({}) do
      |ingredient_name_tag, value|
        value[ingredient_name_tag.text.strip] = ingredient_name_tag['href']
      end
      @ingredients.merge!(ingredients_hash)
      @ingredients2[category_name]= ingredients_hash
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
          @ingredient.content = @ingredient_url.css('#stages > p').text
          @ingredient.calories = @ingredient_url.css('#topContributors > li strong')[0].text
          @ingredient.protein = @ingredient_url.css('#topContributors > li strong')[1].text
          @ingredient.fat = @ingredient_url.css('#topContributors > li strong')[2].text
          @ingredient.carbohydrate = @ingredient_url.css('#topContributors > li strong')[3].text
          @ingredient.save!
        end
      end
    end

    #####################################################################################################
    ##########    RECIPES            ##############

    @recipes_category_links = @main_page
        .css('#aside > span > ul:nth-child(3) li a[href]')
        .each_with_object({}) do
      |n, h| h[n.text.strip] = n["href"]
    end

    @recipes = Hash.new
    @recipes2 = Hash.new
    @recipes_category_links.each do |category_name, href|
      @recipes_url = Nokogiri::HTML(open(href))
      recipes_hash = @recipes_url
          .css('#postsContainer > div:nth-child(1) > div.alignleft.bigposttxt h5 a.arecipe')
          .each_with_object({}) do
        |recipe_name_tag, value|
        value[recipe_name_tag.text.strip] = recipe_name_tag['href']
      end
      @recipes.merge!(recipes_hash)
      @recipes2[category_name]= recipes_hash
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
          @recipe.content = @recipe_url.css('#stages > div.instructions').text
          @recipe.cooking_time = @recipe_url.css('#stages > p > span > span').text
          @recipe.ccal = @recipe_url.css('#stages > h2').text
          @recipe.ingredients = @recipe_url.css('#stages > h2').text

          @recipe.save!
        end
      end
    end

















      # @cuisine_links = @main_page
      #                .css('#aside > span > ul:nth-child(9) li a[href]')
      #                .each_with_object({}) do
      # |n, h| h[n.text.strip] = n["href"]
      # end
      #
      # @cooking_method_links = @main_page
      #                .css('#aside > span > ul:nth-child(5) li a[href]')
      #                .each_with_object({}) do
      # |n, h| h[n.text.strip] = n["href"]
      # end

  end
end

