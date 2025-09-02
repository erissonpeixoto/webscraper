class GithubProfile < ApplicationRecord
  validates :github_username, :name, presence: true

  before_save :shorten_github_url

  private

  def shorten_github_url
    return if github_url.blank?

    self.github_url_short = github_url.split('/').last
  end
end
