class SearchParamsSanitizer < InputSanitizer::Sanitizer
  string :container_id
  string :container_type

  custom :facets, converter: -> (facets) {
    facets.flat_map do |f|
      (f["value"].presence || "").split(' ').map do |value|
        {
          key: f["key"],
          optional: ActiveRecord::Type::Boolean.new.deserialize(f["optional"]),
          value: value
        }
      end
    end
  }

  integer :page
  integer :per_container
  integer :per_page
end
