class ClientBugSerializer < ActiveModel::Serializer
  attributes :id, :exception, :bug_type
end
