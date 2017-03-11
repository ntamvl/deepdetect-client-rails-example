module Api::V1
  class PhotosController < ApiController
    include PhotoDoc

    def filter
      data = {}
      filter_body = {}

      # begin get filter body
      begin
        filter_body = JSON.parse(request.body.read).deep_symbolize_keys
        check_filter_body = validate_filter_body(filter_body)
        if !check_filter_body[:is_valid]
          render json: { message: check_filter_body[:message], status: 400 }, status: 400
          return
        end
      rescue Exception => e
        data = { message: e.to_s, status: 400 }
      end
      # end get filter body

      if filter_body.present?
        photos = Photo.filter(filter_body)
        data = {
          status: 200,
          total: photos[:total],
          photos: photos[:photos]
        }
      else
        data = { message: "Bad request", status: 400 }
      end

      render json: data
    end

    def filter_auto_asos
      data = {}
      from = params[:from].present? ? params[:from].to_i : 0
      size = params[:size].present? ? params[:size].to_i : 20
      hashtags = ["asos", "asseeonme"]
      filter_body = {
                      "query": {
                        "hashtags": hashtags,
                        "and": ["someone", "no_selfie"]
                      },
                      "pagination": {
                        "from": from,
                        "size": size
                      },
                      "precision": {
                        "someone": 0.8,
                        "no_selfie": 0.9
                      }
                    }

      photos = Photo.filter(filter_body)
      data = {
        status: 200,
        total: photos[:total],
        photos: photos[:photos]
      }
      render json: data
    end

    def predict
      image_url = params[:image_url]
      model = params[:model]
      begin
        if image_url.present? && model.present?
          dede = PhotoQuery::predict_image(image_url, model)
          predictions = dede[:body][:predictions].first
          if !predictions.nil?
            prediction = {
              "#{predictions[:classes][0][:cat]}": predictions[:classes][0][:prob],
              "#{predictions[:classes][1][:cat]}": predictions[:classes][1][:prob]
            }
            data = { prediction: prediction, image_url: image_url, status: 200 }
            render json: data, status: 200
          end
        else
          render json: { message: "Please input image_url", status: 400 }
        end
      rescue Exception => e
        puts "\n[predict] #{e.to_s} \n"
        render json: { message: "No result. ML is busy, please try again", status: 204 }
      end
    end

    protected
    def validate_filter_body(filter_body)
      is_valid = true
      message = ""

      begin
        from = filter_body[:pagination][:from]
        size = filter_body[:pagination][:size]
        hashtags = filter_body[:query][:hashtags]
        and_array = filter_body[:query][:and]
        or_array = filter_body[:query][:or]
        not_array = filter_body[:query][:not]

        if hashtags.present?
          if !hashtags.kind_of?(Array)
            message = "hashtags field query must be array"
            is_valid = false
          end
        end

        if !and_array.kind_of?(Array)
          message = "and field query must be array"
          is_valid = false
        end

        if !or_array.kind_of?(Array)
          message = "or field query must be array"
          is_valid = false
        end

        if !not_array.kind_of?(Array)
          message = "not field query must be array"
          is_valid = false
        end

        if !from.is_a?(Numeric) || !size.is_a?(Numeric)
          message = "pagination from, size field query must be a numeric and from >=0, 0 <= size <= 1000"
          is_valid = false
        end

        if from.is_a?(Numeric) && size.is_a?(Numeric)
          if from < 0
            message = "pagination from must be greater or equal than 0"
            is_valid = false
          end

          if size < 0 || size > 1000
            message = "pagination size must be greater or equal than 0 and lower or equal than 1000"
            is_valid = false
          end
        end

        if is_valid
          and_array.each do |category_name|
            if !Query::AVAILABLE_CATEGORIES.include?(category_name)
              is_valid = false
              message = "#{category_name} is not supported. Only support from list: #{Query::AVAILABLE_CATEGORIES.join(", ")}"
            end
          end

          or_array.each do |category_name|
            if !Query::AVAILABLE_CATEGORIES.include?(category_name)
              is_valid = false
              message = "#{category_name} is not supported. Only support from list: #{Query::AVAILABLE_CATEGORIES.join(", ")}"
            end
          end

          not_array.each do |category_name|
            if !Query::AVAILABLE_CATEGORIES.include?(category_name)
              is_valid = false
              message = "#{category_name} is not supported. Only support from list: #{Query::AVAILABLE_CATEGORIES.join(", ")}"
            end
          end
        end
      rescue Exception => e
        puts "[validate_filter_body] #{e.to_s}"
        message = e.to_s
        is_valid = false
      end

      return { is_valid: is_valid, message: message }
    end
  end
end
