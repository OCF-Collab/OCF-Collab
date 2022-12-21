class SearchParamsSanitizer < InputSanitizer::Sanitizer
  string :competency_query
  string :container_query
  integer :page
  integer :per_page
end
