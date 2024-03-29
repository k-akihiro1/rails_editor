require 'rails_helper'
RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET  /api/v1/articles" do
    subject { get(api_v1_articles_path) }
    # 作成日の異なる記事の作成
    let!(:article1) { create(:article, :published, updated_at: 2.days.ago) }
    let!(:article2) { create(:article, :published, updated_at: 1.days.ago) }
    let!(:article3) { create(:article, :published, updated_at: Time.zone.now) }
    let!(:article4) { create(:article, :draft, updated_at: Time.zone.now) }

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
      let(:article_id) { article.id }
      context "ステータスが公開中の時" do
        let(:article) { create(:article, :published) }
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

      context "ステータスが下書きの時" do
        let(:article) { create(:article, :draft) }
        it "記事が見つからない" do
          expect { subject }.to raise_error ActiveRecord::RecordNotFound
        end
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
    subject { post(api_v1_articles_path, params: params, headers: headers) }
    # 【モック】事前にcurennt_userがdeviceを用いて作成されるようモックで定義
    # before{allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user)}
    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }

    context"ステータス：公開　の場合" do
      let(:params) { { article: attributes_for(:article, :published) } }
      it "記事のレコードが作成できる" do
        # 記事の取得
        expect{subject}.to change{Article.where(user_id: current_user.id).count}.by(1)
        res = JSON.parse(response.body)
        # 各記事の項目がAPIで記事と作成した記事が一致するか検証
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(res["status"]).to eq "published"
        expect(response).to have_http_status(:ok)
      end
    end

    context"ステータス：下書き　の場合" do
      let(:params) { { article: attributes_for(:article, :draft) } }
      it "記事のレコードが作成できる" do
        # 記事の取得
        expect{subject}.to change{Article.where(user_id: current_user.id).count}.by(1)
        res = JSON.parse(response.body)
        # 各記事の項目がAPIで記事と作成した記事が一致するか検証
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(res["status"]).to eq "draft"
        expect(response).to have_http_status(:ok)

      end
    end
    context"ステータス　が指定されたもの以外の場合" do
      let(:params) { { article: attributes_for(:article, status: :hogehoge) } }
      it "エラーになる" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }
    # 【モック】事前にcurennt_userがdeviceを用いて作成されるようモックで定義
    # before{allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user)}
    let(:headers) { current_user.create_new_auth_token }
    let(:params) { { article: attributes_for(:article ,:published) } }
    let(:current_user) { create(:user) }

    context "自分が所持している記事のレコードを更新しようとするとき" do
      # urennt_userが記事を作成した場合
      let(:article) { create(:article, :draft, user: current_user) }

      it "記事を更新できる" do
        expect { subject }.to change{article.reload.title}.to(params[:article][:title])&
                              change { article.reload.body }.from(article.body).to(params[:article][:body])&
                              change { article.reload.status }.from(article.status).to(params[:article][:status].to_s)
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

  describe "DELETE /articles/:id" do
    subject { delete(api_v1_article_path(article_id), headers: headers) }
    # 【モック】事前にcurennt_userがdeviceを用いて作成されるようモックで定義
    # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }
    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }
    let(:article_id) { article.id }

    context "自分の記事を削除しようとしたとき" do
      let!(:article) { create(:article, user: current_user) }

      it "記事を削除できる" do
        expect { subject }.to change { Article.count }.by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "他人の記事を削除しようとしたとき" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "記事を削除できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) & change { Article.count }.by(0)
      end
    end
  end
end
