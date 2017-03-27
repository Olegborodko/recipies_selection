ThinkingSphinx::Index.define :recipe, :with => :active_record do
  # fields
  indexes :name, :sortable => true
  indexes :content
  indexes ingredients.name, :sortable => true, :as => :ingredient_name
  indexes ingredients.content, :as => :ingredient_content

end