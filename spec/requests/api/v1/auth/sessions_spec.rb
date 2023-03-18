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
      fit "エラーが起きて登録できない" do
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
end
