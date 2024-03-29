require 'rails_helper'
RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  let(:headers) { current_user.create_new_auth_token }
  let(:current_user) { create(:user) }

  describe "GET /api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }
    context "自分の書いた下書きの記事が存在するとき" do
      # ログインユーザーの記事
      let!(:article1) { create(:article, :draft, user: current_user) }
      # それ以外の記事
      let!(:article2) { create(:article, :draft) }

      it "自分の書いた下書きのみが取得できる" do
        subject
        res = JSON.parse(response.body)
        # 配列の要素の数を確認
        expect(res.length).to eq 1
        expect(res[0]["id"]).to eq article1.id
        # 記事のKeyが一致しているか確認
        expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
        # ユーザーのKeyが一致しているか確認
        expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      end
    end
  end

  describe "GET /articles/drafts/:id" do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) }
    context "指定した id の記事が存在して" do
      let(:article_id) { article.id }
      context "対象の記事が自分が書いた下書きのとき" do
        let(:article) { create(:article, :draft, user: current_user) }
        it "記事の詳細を取得できる" do
          subject
          res = JSON.parse(response.body)
          expect(res["id"]).to eq article.id
          expect(res["title"]).to eq article.title
          expect(res["body"]).to eq article.body
          expect(res["status"]).to eq article.status
          expect(res["updated_at"]).to be_present
          expect(res["user"]["id"]).to eq article.user.id
          expect(res["user"].keys).to eq ["id", "name", "email"]
        end
      end
      context "対象の記事が他のユーザーが書いた下書きのとき" do
        let(:article) { create(:article, :draft) }
        it "記事が見つからない" do
          expect { subject }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
