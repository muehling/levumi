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
        json.shorthand t.shorthand
        json.short t.description['short']
        json.name t.name
        json.level t.level
        json.items_count t.items.size
        json.items t.items
        json.is_student_test t.student_test
        json.time_limit t.description['time_limit']
        json.usage t.description['usage']
        json.description t.description['full']
        json.test_type_id t.test_type_id
        json.info_attachments t.info_files.map do |f|
          json.filepath rails_blob_path(f)
          json.content_type f.content_type
          json.filename f.filename
        end
      end
    end
  end
end
