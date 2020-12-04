class CompetencyFrameworksSearchParamsSanitizer < InputSanitizer::Sanitizer
  string :query, required: true
  integer :limit
end
