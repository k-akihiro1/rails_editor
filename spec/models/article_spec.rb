# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :string           default("draft")
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Article, type: :model do
  context "必要情報が揃っている" do
    let(:article){build(:article)}
    it "記事ができる" do
      expect(article).to be_valid
    end
  end

  context "タイトルの記入なし" do
    let(:article){build(:article, title: nil)}
    it "エラーが発生" do
      expect(article).not_to be_valid
    end
  end
end
