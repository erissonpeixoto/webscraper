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
    @github_profile = GithubProfile.new(github_profile_params)
    if @github_profile.save
      render json: @github_profile, status: :created
    else
      render json: @github_profile.errors, status: :unprocessable_entity
    end
  end

  def update
    if @github_profile.update(github_profile_params)
      render json: @github_profile
    else
      render json: @github_profile.errors, status: :unprocessable_entity
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
      :github_url,
      :github_username,
      :followers,
      :following,
      :stars,
      :contributions,
      :avatar_url,
      :organization,
      :location
    )
  end
end
