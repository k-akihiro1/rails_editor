class CreateArticleLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :article_likes do |t|
      t.references :user, null: false, foreign_key: true
      t.reference :article

      t.timestamps
    end
  end
end