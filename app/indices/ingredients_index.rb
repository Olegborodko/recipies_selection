ThinkingSphinx::Index.define :ingredient, :with => :active_record do
  # fields
  indexes :name, :sortable => true
  indexes :content

end