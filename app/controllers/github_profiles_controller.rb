class GithubProfilesController < ApplicationController
  before_action :set_github_profile, only: %i[show update destroy]

  def index
    @github_profiles = GithubProfile.all
    render json: @github_profiles
  end

  def show
    render json: @github_profile
  end

  def create
    begin
      scraper = GithubProfileScraper.new(github_profile_params[:github_url])
      scraped_data = scraper.scrape

      @github_profile = GithubProfile.new(github_profile_params.merge(scraped_data || {}))
      if @github_profile.save
        render json: @github_profile, status: :created
      else
        render json: @github_profile.errors, status: :unprocessable_entity
      end
    rescue StandardError => e
      Rails.logger.error(e.message)
      render json: { error: 'Failed to create GitHub profile' }, status: :unprocessable_entity
    end
  end

  def update
    begin
      scraper = GithubProfileScraper.new(github_profile_params[:github_url])
      scraped_data = scraper.scrape

      if @github_profile.update(github_profile_params.merge(scraped_data || {}))
        render json: @github_profile
      else
        render json: @github_profile.errors, status: :unprocessable_entity
      end
    rescue StandardError => e
      Rails.logger.error(e.message)
      render json: { error: 'Failed to update GitHub profile' }, status: :unprocessable_entity
    end
  end

  def destroy
    @github_profile.destroy
    head :no_content
  end

  private

  def set_github_profile
    @github_profile = GithubProfile.find(params[:id])
    head :not_found unless @github_profile
  end

  def github_profile_params
    params.require(:github_profile).permit(
      :name,
      :github_url
    )
  end
end
