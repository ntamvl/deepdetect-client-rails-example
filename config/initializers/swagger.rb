class Swagger::Docs::Config
  def self.transform_path(path, api_version)
    # Make a distinction between the APIs and API documentation paths.
    "apidocs/#{path}"
  end

  def self.base_api_controller; Api::V1::ApiController end
end

# Swagger::Docs::Config.base_api_controller = Api::V1::ApiController

Swagger::Docs::Config.register_apis({
  '1.0' => {
    api_extension_type: :json,
    controller_base_path: '',
    api_file_path: 'public/apidocs',
    base_path: 'http://127.0.0.1:3000',
    parent_controller: Api::V1::ApiController,
    clean_directory: true
  }
})
