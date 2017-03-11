module PhotoDoc
  extend ActiveSupport::Concern

  included do
    swagger_controller :photos, "Photos"

    # swagger_api :filter do
    #   summary "Filter images by query"
    #   notes "This lists all images by query"
    #   param :body, :body, :json, :required, 'JSON formatted body. Available categories: [zappos_boxes, no_zappos_boxes, bad_resolution, poor_lighting, normal_lighting, no_one, poorlighting, footwear, normal_resolution, someone, no_footwear, spam, no_mirrorshot, mirrorshot, no_selfie, selfie, less_than_one, more_than_one, women, men]', defaultValue: '{"query": {"and": ["someone", "no_selfie"], "or": ["men", "women"], "not": ["selfie"] }, "pagination": {"from": 0, "size": 20 } }'
    #   # param :body, :photo, :string, :optional, "Body filter"
    # end

    swagger_api :predict do
      summary "Predict a image by Deep Learning"
      notes "Predict a image by Deep Learning"
      param :form, :image_url, :string, :required, "Image URL", defaultValue: "https://scontent.fsgn1-1.fna.fbcdn.net/v/t1.0-9/1239414_10201956642662189_587041755_n.jpg?oh=9e9be2c2b9318abac66abde163a88399&oe=592CF192"
      param :form, :model, :string, :required, "Model for prediction. Available models: [mirrorshot, gender, badres, poorlighting, selfie, footwear, more_than_one, person_yes_no, zappos_boxes]", defaultValue: "person_yes_no"
    end

    # swagger_api :filter_auto_asos do
    #   summary "Auto filter images for ASOS with hashtag asos or asseeonme"
    #   notes "This lists all images by ML filtering, only fetch images must have someone and images are not selfie"
    #   param :form, :from, :integer, :required, "Pagination from", defaultValue: "0"
    #   param :form, :size, :integer, :required, "Pagination size", defaultValue: "20"
    # end
  end
end
