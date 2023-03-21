module Api::V1
  class ArticlesController < BaseApiController
    before_action :authenticate_user!, only: [:create, :update, :destroy]
    # http://localhost:3000/api/v1/articles(.:format)
    def index
      articles = Article.order('created_at desc')
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      article = Article.find(params[:id])
      render json: article, serializer: Api::V1::ArticleSerializer
    end

    def create
      binding.pry
      article = current_user.articles.create!(article_params)
      render json: article, serializer: Api::V1::ArticleSerializer
    end

    def update
      article = current_user.articles.find(params[:id])
      article.update!(article_params)
      render json: article, serializer: Api::V1::ArticleSerializer
    end

    def destroy
      article = current_user.articles.find(params[:id])
      article.destroy!
    end

    private  # ストロングパラメーター（予期しない値を変更されてしまう脆弱性を防ぐ機能）
      def article_params
        params.require(:article).permit(:title, :body)  # titleとbodyの変更を許可
      end
  end
end
