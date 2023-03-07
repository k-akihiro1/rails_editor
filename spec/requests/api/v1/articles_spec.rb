require 'rails_helper'
RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET  /api/v1/articles" do
    subject { get(api_v1_articles_path) }
    # 作成日の異なる記事の作成
    let!(:article1) { create(:article, updated_at: 2.days.ago) }
    let!(:article2) { create(:article, updated_at: 1.days.ago) }
    let!(:article3) { create(:article, updated_at: Time.zone.now) }

    it "記事一覧が取得できる" do
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


  describe "GET  /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id)) }
    context "指定した id の記事が存在する場合" do
      let(:article) { create(:article) }
      let(:article_id) { article.id }

      it "記事が取得できる" do
        # 記事の取得
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        # 各記事の項目がAPIで取得した記事と作成した記事が一致するか検証
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"].keys).to eq ["id", "name", "email"]
      end
    end
    context "指定した id の記事が存在しない場合" do
      let(:article_id) { 10000 }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /api/v1/articles/" do
    subject { post(api_v1_articles_path, params: params) }

    context "不適切なパラメーターを送信した時" do
      let(:params) do
        {article: attributes_for(:article)}
      end
        let(:current_user) { create(:user) }

      fit "記事レコードが作成できる" do
        binding.pry
        # 記事の取得
        expect{subject}.to change{Article.count}.by(1)
        res = JSON.parse(response.body)
        # 各記事の項目がAPIで記事と作成した記事が一致するか検証
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(response).to have_http_status(:ok)
      end

    context "不適切なパラメーターを送信した時"
      it "レーコードの作成に失敗する"do
      end
    end
  end

end