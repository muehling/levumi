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
  json.area test.test_family.competence.area.name
  json.competence test.test_family.competence.name
  json.test_family test.test_family.name
  json.level test.level
  json.version test.version
  json.archive test.archive ? 'Ja' : ''
  json.description test.description
  json.student_test test.student_test
  json.items test.items
  json.has_results test.has_results
end
