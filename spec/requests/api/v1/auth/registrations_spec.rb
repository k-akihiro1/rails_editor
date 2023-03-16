require 'rails_helper'

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /index" do
    subject { post(api_v1_user_registration_path, params: params) }
    context "必要な情報が存在するとき" do
      it "ユーザを新規登録ができる" do
      end
      it "header情報を取得できる" do
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
