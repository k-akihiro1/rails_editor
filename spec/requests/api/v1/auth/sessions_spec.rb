require 'rails_helper'

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    context "User情報が存在するとき" do
      # ユーザーの作成
      let(:user){ create(:user)}
      # ユーザーのログイン情報
      let(:params) {attributes_for(:user, email: user.email, password: user.password) }
      it "ユーザでログインができる" do
        subject
        #hearder情報
        header = response.headers

        expect(response).to have_http_status(:ok)
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["uid"]).to be_present
      end
    end

    context "email が一致しないとき" do
      let(:user){ create(:user)}
      let(:params) {attributes_for(:user,email: "hogehoge", paasword: user.password) }
      it "エラーが起きて登録できない" do
        subject
        #body情報
        res = JSON.parse(response.body)
        #hearder情報
        header = response.headers

        #bodyのエラーの確認
        expect(res["errors"]).to include "Invalid login credentials. Please try again."

        #ステータスコードの確認
        expect(response).to have_http_status(401)

        #heardersの情報がないことを確認
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(header["uid"]).to be_blank
      end
    end

    context "password が存在しないとき" do
      let(:user){ create(:user)}
      let(:params) {attributes_for(:user,email: user.email, paasword: "hogehoge") }
      it "エラーが起きて登録できない" do
        subject
        #body情報
        res = JSON.parse(response.body)
        #hearder情報
        header = response.headers

        #bodyのエラーの確認
        expect(res["errors"]).to include "Invalid login credentials. Please try again."

        #ステータスコードの確認
        expect(response).to have_http_status(401)

        #heardersの情報がないことを確認
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(header["uid"]).to be_blank
      end
    end
  end

  describe "DELETE /api/v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }

    context "ログアウトに必要な情報を送信したとき" do
			let(:user) { create(:user) }
      let!(:headers) { user.create_new_auth_token }
      it "ログアウトできる" do
        #header情報
        expect { subject }.to change { user.reload.tokens }.from(be_present).to(be_blank)

        #body情報
        res = JSON.parse(response.body)
        expect(res["success"]).to be_truthy

        #ステータスコードの確認
        expect(response).to have_http_status(:ok)
      end
    end

    context "誤った情報を送信したとき" do
      let(:user) { create(:user) }
      let!(:headers) { { "access-token" => "", "client" => "", "uid" => "" } }
      it "ログアウトできない" do
        subject

        #ステータスコードの確認
        expect(response).to have_http_status(404)

        #body情報
        res = JSON.parse(response.body)
        expect(res["errors"]).to include "User was not found or was not logged in."
      end
    end
  end
end
