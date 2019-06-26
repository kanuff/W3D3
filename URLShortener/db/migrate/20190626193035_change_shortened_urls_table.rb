class ChangeShortenedUrlsTable < ActiveRecord::Migration[5.2]
  def change

    remove_index :shortened_urls, :long_url
    remove_index :shortened_urls, :short_url
    
    change_column :shortened_urls, :short_url, :string, null: false

    add_index :shortened_urls, :short_url, unique: true
    add_index :shortened_urls, :user_id

  end
end
