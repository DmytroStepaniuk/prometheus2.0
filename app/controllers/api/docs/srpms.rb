module Api
  module Docs
    class Srpms
      # :nocov:
      include Swagger::Blocks

      swagger_path '/srpms/{name}' do
        operation :get do
          key :description, 'Returns srpm info for given name'
          key :tags, ['srpms']
          parameter do
            key :name, :name
            key :in, :path
            key :description, 'Srpm name'
            key :required, true
            key :type, :string
          end
          parameter do
            key :name, :branch_id
            key :in, :query
            key :description, 'Branch id. Default: Sisyphus branch id, not name. E.g. 1.'
            key :type, :integer
            key :format, :int64
          end
          response 200 do
            key :description, 'Response with srpm.'
            schema do
              key :'$ref', :OutputSrpm
            end
          end
          response 404 do
            key :description, 'Srpm and/or Branch not found.'
          end
        end
      end
      # :nocov:
    end
  end
end
