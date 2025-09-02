class AddGithubUrlShortToGithubProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :github_profiles, :github_url_short, :string
  end
end
