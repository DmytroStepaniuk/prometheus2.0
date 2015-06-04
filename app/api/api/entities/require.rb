module API
  module Entities
    class Require < Grape::Entity
      expose :package_id
      expose :name
      expose :version
      expose :release
      expose :epoch
      expose :flags
      expose :created_at
      expose :updated_at
    end
  end
end
