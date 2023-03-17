require 'rails_helper'

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) }
    context "必要な情報が存在するとき" do
      let(:params) {{ registration: attributes_for(:user) }}
      it "ユーザを新規登録ができる" do
        expect { subject }.to change { User.count }.by(1)
        expect(response).to have_http_status(:ok)
        res = JSON.parse(response.body)
      end
      fit "header情報を取得できる" do
        subject
        binding.pry
        expect(response.header["access-token"]).to be_present
        expect(response.header["token-type"]).to be_present
        expect(response.header["client"]).to be_present
        expect(response.header["expiry"]).to be_present
        expect(response.header["uid"]).to be_present
      end
    end
    context "name が存在しないとき" do
      it "エラーが起きて登録できない" do
      end
    end
    context "email が存在しないとき" do
      it "エラーが起きて登録できない" do
      end
    end
    context "passwordが存在しないとき" do
      it "エラーが起きて登録できない" do
      end
    end
  end
end
