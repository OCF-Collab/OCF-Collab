# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


[
  {
    id: "42a83781-8a07-47ae-a169-b699c5c03073",
    name: "Credential Engine Registry",
    description: "Credential Engine competency frameworks based on the CTDL-ASN metamodel.",
    s3_bucket: "test-credential-engine-registry",
  },
  {
    id: "43816605-58cf-4eb9-9aa1-1796000c202a",
    name: "Desire2Learn (D2L) Competency Registry",
    description: "D2L's competency frameworks based on the ASN metamodel.",
    s3_bucket: "test-desire2learn",
  },
].each do |attrs|
  NodeDirectory.find_or_initialize_by(id: attrs[:id]) do |directory|
    directory.update_attributes!(attrs)
  end
end
