json.info_attachments @data.info_files.map do |f|
  json.filepath rails_blob_path(f)
  json.content_type f.content_type
  json.filename f.filename
end
