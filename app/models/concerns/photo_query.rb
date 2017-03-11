require 'active_support/concern'
module PhotoQuery
  extend ActiveSupport::Concern

  def self.predict_image(image_url, model)
    DeepdetectRuby::Service.create(name: model)
    dede = DeepdetectRuby::Predict.predict(service: model, image_url: image_url)
    DeepdetectRuby::Service.delete(model)
    return dede
  end

  def self.included(base)
    base.class_eval do
      def self.filter(filter_body = {})
        return {} if !filter_body.present?
        query = Query.build_query(filter_body)
        elastic_options = {
          index: "#{EsIndex.index_name}",
          type:  "photo",
          body: query
        }
        photos = Elasticsearch::Model.client.search(elastic_options)
        data = { photos: [], total: 0, aggs: {} }
        if !photos.nil?
          data = {
            photos: photos["hits"]["hits"].map {|photo| photo["_source"]},
            total: photos["hits"]["total"],
            aggs: photos["aggregations"]
          }
        end
        return data.deep_symbolize_keys
      end
    end
  end
end
