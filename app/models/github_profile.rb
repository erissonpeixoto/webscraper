class GithubProfile < ApplicationRecord
  validates :github_url, :name, presence: true

  before_save :generate_github_url_short

  def short_github_url
    Rails.application.routes.url_helpers.short_url(github_url_short, only_path: true)
  end

  private

  def generate_github_url_short
    self.github_url_short ||= SecureRandom.urlsafe_base64(6)
  end
end
