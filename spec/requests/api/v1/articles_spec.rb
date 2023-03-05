require 'rails_helper'
RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /articles" do
    subject { get(api_v1_articles_path) }
    # 作成日の異なる記事の作成
    let!(:article1) { create(:article, updated_at: 2.days.ago) }
    let!(:article2) { create(:article, updated_at: 1.days.ago) }
    let!(:article3) { create(:article, updated_at: Time.zone.now) }

    fit "記事一覧が取得できる" do
      # 記事の取得
      subject
      res = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      # 配列の要素の数を確認
      expect(res.length).to eq 3
      expect(res.map { |d| d["id"] }).to eq [article3.id, article2.id,article1.id]
      # 記事のKeyが一致しているか確認
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      # ユーザーのKeyが一致しているか確認
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end
end
