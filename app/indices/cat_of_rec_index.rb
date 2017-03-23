ThinkingSphinx::Index.define :recipe_category, :with => :active_record do
  # fields
  indexes title, :sortable => true

end
