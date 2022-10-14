class ChangeDataOwnerToStore < ActiveRecord::Migration[7.0]
  def change
    # if Rails.env.development? || Rails.env.test?
    #   change_column :stores, :owner, :integer
    if Rails.env.production?
      # 本番環境はusingオプションを追加
      change_column :stores, :owner, 'integer USING CAST(owner AS integer)'
    end
  end
end
