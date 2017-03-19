module Modules
  class Recipe < Grape::API
    prefix :api
    format :json

    desc 'Recipes controller'
    resource :recipes do
      get do

      end
    end
  end
end