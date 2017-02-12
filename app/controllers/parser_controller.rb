require 'rubygems'
require 'nokogiri'
require 'open-uri'
MAIN_PAGE = Nokogiri::HTML(open("http://namnamra.com/"))
BASE_INGREDIENT_PAGE = Nokogiri::HTML(open("http://namnamra.com/ingredients/page/0"))
LAST_INGREDIENT_PAGE = 696
class ParserController < ApplicationController

  def index
    @page = BASE_INGREDIENT_PAGE

    @ingredient_title = @page.css('div#wrapper div#main div#postsContainer div.post a.arecipe', 'title').text.scan(/[А-Я][а-я]+/).join(', ')

    # @ingredient = eval(@ingredient_title)
          # doc.css('nav ul.menu li a', 'article h2').each do |link|
      #   puts link.content
  end
end

