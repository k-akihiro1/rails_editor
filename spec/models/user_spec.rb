require 'rails_helper'

RSpec.describe User, type: :model do
  context "必要情報が揃っている" do
    let(:user){build(:user)}
    it "ユーザー登録ができる" do
      expect(user).to be_valid
    end
  end

  context "名前のみ記入" do
    let(:user){build(:user, email: nil, password: nil)}
    it "エラーが発生" do
      expect(user).not_to be_valid
    end
  end

  context "email の記載がない" do
    let(:user){build(:user, email: nil)}
    it "エラーが発生" do
      expect(user).not_to be_valid
    end
  end
  context "password の記載がない" do
    let(:user){build(:user, password: nil)}
    it "エラーが発生" do
      expect(user).not_to be_valid
    end
  end
end
