require 'rubygems'
require 'nokogiri'
require 'open-uri'

# MAIN_PAGE = Nokogiri::HTML(open("http://namnamra.com/"))
# BASE_INGREDIENT_PAGE = Nokogiri::HTML(open("http://namnamra.com/ingredients/page/"))
# FIRST_PAGE = 0
# LAST_PAGE = 696


class ParserController < ApplicationController

  def index

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
      puts @ingredients2
    end

    @ingredients2.each do |category, ingredients_hash|
      check_existing_category = IngredientCategory.find_by_title(category)
      if nil.equal?(check_existing_category)
        category_new = IngredientCategory.new(title: category)
        category_new.save!
        check_existing_category = IngredientCategory.find_by_title(category)
      end
      ingredients_hash.each do |ingr_name, href|
        check_existing_ingredient = Ingredient.find_by_name(params[:name])
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

    #####################################################################################################
      ##########    RECIPIES            ##############

      @main_page = Nokogiri::HTML(open("http://namnamra.com/"))
      @recipies_category_links = @ingredient_category_url
                                       .css('#aside > span > ul:nth-child(3) a[href]')
                                       .each_with_object({}) do
      |n, h| h[n.text.strip] = n["href"]
      end

    end
  end
end

