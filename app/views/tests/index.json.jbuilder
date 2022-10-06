json.tests Test
             .all
             .sort_by { |t|
               [
                 t.test_family.competence.area.id,
                 t.test_family.competence.id,
                 t.test_family.id,
                 t.shorthand,
                 t.version
               ]
             }
             .map do |test|
  json.id test.id
  json.shorthand test.shorthand
  json.area Area.find(test.test_family.competence.area.id).name
  json.competence Competence.find(test.test_family.competence.id).name
  json.test_family TestFamily.find(test.test_family.id).name
  json.level test.level
  json.version test.version
  json.archive test.archive ? 'Ja' : ''
  json.description test.description
  json.student_test test.student_test
  json.items test.items
end
