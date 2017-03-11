class Photo
  include Elasticsearch::Model
  include PhotoQuery
  index_name EsIndex.index_name
end
