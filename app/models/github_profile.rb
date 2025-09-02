class GithubProfile < ApplicationRecord
  validates :github_username, :name, presence: true
end
