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
      it "header情報を取得できる" do
        subject
        expect(response.header["access-token"]).to be_present
        expect(response.header["token-type"]).to be_present
        expect(response.header["client"]).to be_present
        expect(response.header["expiry"]).to be_present
        expect(response.header["uid"]).to be_present
      end
    end
    context "name が存在しないとき" do
      let(:params) {{ registration: attributes_for(:user,name: nil) }}
      it "エラーが起きて登録できない" do
        expect { subject }.to change { User.count }.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]["name"]).to eq ["can't be blank"]
      end
    end
    context "email が存在しないとき" do
      let(:params) {{ registration: attributes_for(:user,email: nil) }}
      it "エラーが起きて登録できない" do
        expect { subject }.to change { User.count }.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]["email"]).to eq ["can't be blank"]
      end
    end
    context "password が存在しないとき" do
      let(:params) {{ registration: attributes_for(:user,password: nil) }}
      it "エラーが起きて登録できない" do
        expect { subject }.to change { User.count }.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]["password"]).to eq ["can't be blank"]
      end
    end
  end
end
