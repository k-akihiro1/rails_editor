class Api::V1::ArticleSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
end
