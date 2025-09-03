class RedirectsController < ApplicationController
  def show
    github_profile = GithubProfile.find_by(github_url_short: params[:short_code])
    if github_profile&.github_url.present?
      redirect_to github_profile.github_url, allow_other_host: true
    else
      render plain: "Link inválido", status: :not_found
    end
  end
end
