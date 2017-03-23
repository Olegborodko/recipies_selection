ThinkingSphinx::Index.define :ingredient_category, :with => :active_record do
  # fields
  indexes title, :sortable => true

end
