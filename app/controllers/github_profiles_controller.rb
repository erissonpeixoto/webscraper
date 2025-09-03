class GithubProfilesController < ApplicationController
  before_action :set_github_profile, only: %i[show update destroy]

  def index
    if params[:name].present?
      query = "%#{params[:name]}%"
      @github_profiles = GithubProfile.where(
        "name ILIKE :q OR github_username ILIKE :q OR organization ILIKE :q OR location ILIKE :q",
        q: query
      )
    else
      @github_profiles = GithubProfile.all
    end

    render json: @github_profiles.as_json(methods: [ :short_github_url ])
  end

  def show
    render json: @github_profile.as_json(methods: [ :short_github_url ])
  end

  def create
    begin
      merged_params = github_profile_params_with_scraped_data

      @github_profile = GithubProfile.new(merged_params)
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
      merged_params = github_profile_params_with_scraped_data

      if @github_profile.update(merged_params)
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
    p @github_profile
    head :not_found unless @github_profile
  end

  def github_profile_params
    params.require(:github_profile).permit(
      :name,
      :github_url
    )
  end

  def github_profile_params_with_scraped_data
    scraper = GithubProfileScraper.new(github_profile_params[:github_url])
    scraped_data = scraper.scrape
    github_profile_params.merge(scraped_data || {})
  end
end
