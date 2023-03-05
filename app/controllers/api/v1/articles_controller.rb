module Api::V1
  class ArticlesController < BaseApiController
    # http://localhost:3000/api/v1/articles(.:format)
    def index
      articles = Article.order('created_at desc')
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      article = Article.find(params[:id])
      render json: article, serializer: Api::V1::ArticleSerializer
    end
  end
end
