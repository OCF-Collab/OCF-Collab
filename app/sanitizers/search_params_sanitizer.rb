class SearchParamsSanitizer < InputSanitizer::Sanitizer
  string :container_type

  custom :facets, converter: -> (facets) {
    facets.map do |f|
      {
        key: f["key"],
        optional: ActiveRecord::Type::Boolean.new.deserialize(f["optional"]),
        value: f["value"]
      }
    end
  }

  integer :page
  integer :per_page
end
