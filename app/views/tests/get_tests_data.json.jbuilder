json.tests @data.map do |a|
  json.id a.id
  json.name a.name
  json.competences a.competences.map do |c|
    json.id c.id
    json.name c.name
    json.test_families c.test_families.map do |tf|
      json.id tf.id
      json.name tf.name
      json.tests tf.tests.where(archive: false).order(:level).map do |t|
        json.id t.id
        json.name t.name
        json.level t.level
        json.items_count t.items.size
        json.items t.items
        json.is_student_test t.student_test
        json.time_limit t.description['time_limit']
        json.usage t.description['usage']
        json.description t.description['full']
      end
    end
  end
end
