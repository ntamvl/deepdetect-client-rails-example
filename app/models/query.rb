class Query
  PRECISION = 0.9
  AVAILABLE_CATEGORIES = ["zappos_boxes", "no_zappos_boxes", "bad_resolution", "poor_lighting",
    "normal_lighting", "no_one", "poorlighting", "footwear", "normal_resolution", "someone",
    "no_footwear", "spam", "no_mirrorshot", "mirrorshot", "no_selfie",
    "selfie", "less_than_one", "more_than_one", "women", "men"]

  def self.build_query(filter_body = {})
    # filter_body = {
    #   "query": {
    #     "hashtags": ["asos", "hype"],
    #     "and": ["someone", "no_selfie"],
    #     "or": ["men", "women"],
    #     "not": ["selfie"],
    #     "include_spam": false
    #   },
    #   "pagination": {
    #     "from": 0,
    #     "size": 20
    #   },
    #   "default_precision": 0.9,
    #   "precision": {
    #     "selfie": 0.8,
    #     "no_selfie": 0.9,
    #     "someone": 0.8
    #   }
    # }

    default_precision = filter_body[:default_precision] || Query::PRECISION
    from = filter_body[:pagination][:from] || 0
    size = filter_body[:pagination][:size] || 10
    hashtags = filter_body[:query][:hashtags] || []
    and_array = filter_body[:query][:and] || []
    or_array = filter_body[:query][:or] || []
    not_array = filter_body[:query][:not] || []
    filter_precision = filter_body[:precision] || {}
    include_spam = filter_body[:query][:include_spam] || false

    must_query = []
    should_query = []
    not_query = []
    must_predict = []
    should_predict = []
    not_predict = []

    hashtags_query = {"terms": {"hashtag_array": hashtags } }
    spam_query = {"match": {"spam": false } }

    # begin prediction query
    and_array.each do |category_name|
      precision_cat = filter_precision[:"#{category_name}"] || default_precision
      q = {"range": {"predictions.#{category_name}": {"gte": precision_cat } } }
      must_predict << q
    end

    or_array.each do |category_name|
      precision_cat = filter_precision[:"#{category_name}"] || default_precision
      q = {"range": {"predictions.#{category_name}": {"gte": precision_cat } } }
      should_predict << q
    end

    not_array.each do |category_name|
      precision_cat = filter_precision[:"#{category_name}"] || default_precision
      q = {"range": {"predictions.#{category_name}": {"gte": precision_cat } } }
      not_predict << q
    end

    # query for prediction
    predict_query = {
      "nested": {
        "path": "predictions",
        "query": {
          "bool": {
            "should": should_predict,
            "must": must_predict,
            "must_not": not_predict
          }
        }
      }
    }
    # end prediction query

    # combine with final query
    must_query << predict_query
    must_query << hashtags_query if hashtags.present?
    must_query << spam_query if !include_spam

    # final querys
    query = {
      "query": {
        "bool": {
          "must": must_query,
          "should": should_query,
          "must_not": not_query
        }
      },
      "sort": [
        {
          "created_at": {
            "order": "desc"
          }
        }
      ],
      "from": from,
      "size": size
    }

    return query
  end
end
