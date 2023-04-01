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

      fit "自分の書いた下書きのみが取得できる" do
        binding.pry
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
    context "指定した id の記事が存在して" do
      context "対象の記事が自分が書いた下書きのとき" do
        it "記事の詳細を取得できる" do
        end
      end
      context "対象の記事が他のユーザーが書いた下書きのとき" do
        it "記事が見つからない" do
        end
      end
    end
  end
end
