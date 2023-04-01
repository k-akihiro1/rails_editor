require 'rails_helper'
RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  let(:headers) { current_user.create_new_auth_token }
  let(:current_user) { create(:user) }
  describe "GET /api/v1/articles/drafts" do
    context "自分の書いた下書きの記事が存在するとき" do
      it "自分の書いた下書きのみが取得できる" do
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
