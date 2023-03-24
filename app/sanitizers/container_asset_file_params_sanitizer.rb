class ContainerAssetFileParamsSanitizer < InputSanitizer::Sanitizer
  string :id, required: true
  string :metamodel
end
