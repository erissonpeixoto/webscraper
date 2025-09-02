class CreateGithubProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :github_profiles do |t|
      t.string :name
      t.string :github_url
      t.string :github_username
      t.integer :followers
      t.integer :following
      t.integer :stars
      t.integer :contributions
      t.string :avatar_url
      t.string :organization
      t.string :location

      t.timestamps
    end
  end
end
