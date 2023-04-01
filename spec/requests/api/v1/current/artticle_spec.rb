require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }
    context "自分の記事が複数存在するとき" do
      it "更新順に取得できる" do
      end
    end
  end
end
