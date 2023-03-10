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
    # 【モック】事前にcurennt_userがdeviceを用いて作成されるようモックで定義
    before{allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user)}

    let(:params) {{article: attributes_for(:article)}}
    let(:current_user) { create(:user) }

    it "記事レコードが作成できる" do
      # 記事の取得
      expect{subject}.to change{Article.count}.by(1)
      res = JSON.parse(response.body)
      # 各記事の項目がAPIで記事と作成した記事が一致するか検証
      expect(res["title"]).to eq params[:article][:title]
      expect(res["body"]).to eq params[:article][:body]
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params) }
    # 【モック】事前にcurennt_userがdeviceを用いて作成されるようモックで定義
    before{allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user)}
    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }

    context "自分が所持している記事のレコードを更新しようとするとき" do
      # urennt_userが記事を作成した場合
      let(:article) { create(:article, user: current_user) }

      fit "記事を更新できる" do
        expect { subject }.to change{article.reload.title}.to(params[:article][:title])&
                              change { article.reload.body }.from(article.body).to(params[:article][:body])
        expect(response).to have_http_status(:ok)
      end
    end

    context "自分以外の記事のレコードを更新しようとするとき" do
      # curent_use以外のユーザーを作成した場合
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "更新できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
