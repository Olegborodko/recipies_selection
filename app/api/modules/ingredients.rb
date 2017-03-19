module Modules
  class Ingredients < Grape::API
    prefix :api
    format :json

    desc 'Ingredients controller'
    resource :ingredients do
      get do

      end
    end
  end
end