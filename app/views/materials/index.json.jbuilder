json.materials Material.all.map do |material|
  json.id material.id
  json.name material.name
  json.description material.description
end
