# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  image                  :string
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
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
