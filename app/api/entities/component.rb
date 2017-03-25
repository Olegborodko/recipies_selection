module Entities
  class Component < Grape::Entity
    root 'components', 'component'

    format_with(:iso_timestamp) { |dt| dt.to_i }

    expose :id
    expose :name
    expose :content
    expose :href
    expose :calories
    expose :protein
    expose :fat
    expose :carbohydrate

    with_options(format_with: :iso_timestamp) do
      expose :created_at
      expose :updated_at
    end
  end
end