require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }
    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }

    context "自分の記事が複数存在するとき" do
      # 作成日の異なる記事の作成
      let!(:article1) { create(:article, :published, user: current_user, updated_at: 2.days.ago) }
      let!(:article2) { create(:article, :published, user: current_user, updated_at: 1.days.ago) }
      let!(:article3) { create(:article, :published, user: current_user, updated_at: Time.zone.now) }

      it "更新順に取得できる" do
        subject
        expect(response).to have_http_status(:ok)

        res = JSON.parse(response.body)
        expect(res.length).to eq 3
        expect(res.map {|d| d["id"] }).to eq [article3.id, article2.id, article1.id]
        expect(res[0]["user"]["id"]).to eq current_user.id
        expect(res[0]["user"]["name"]).to eq current_user.name
        expect(res[0]["user"]["email"]).to eq current_user.email

      end
    end
  end
end
