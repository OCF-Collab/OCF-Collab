class LanguageMapParser
  attr_reader :language_map, :value_objects

  DEFAULT_LANGUAGE = "en".freeze
  ValueObject = Struct.new(:language, :value, keyword_init: true)

  def initialize(language_map)
    @language_map = language_map
    @value_objects = Array.wrap(parse).uniq(&:language)
  end

  def values
    value_objects.map(&:value)
  end

  private

  def parse
    case language_map
    when Array then parse_as_array
    when Hash then parse_as_hash
    else ValueObject.new(language: DEFAULT_LANGUAGE, value: language_map)
    end
  end

  def parse_as_array
    language_map.flat_map { LanguageMapParser.new(_1).value_objects }
  end

  def parse_as_hash
    if language_map.key?("@value")
      return ValueObject.new(
        language: language_map["@language"].presence || DEFAULT_LANGUAGE,
        value: language_map.fetch("@value")
      )
    end

    language_map.map { ValueObject.new(language: _1, value: _2) }
  end
end
