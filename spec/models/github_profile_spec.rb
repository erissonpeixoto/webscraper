require "rails_helper"

RSpec.describe GithubProfile, type: :model do
  describe "validations" do
    it "is invalid without github_url" do
      profile = GithubProfile.new(name: "Octo Cat")
      expect(profile).not_to be_valid
      expect(profile.errors[:github_url]).to include("can't be blank")
    end

    it "is invalid without name" do
      profile = GithubProfile.new(github_url: "https://github.com/octocat")
      expect(profile).not_to be_valid
      expect(profile.errors[:name]).to include("can't be blank")
    end

    it "is valid with github_url and name" do
      profile = GithubProfile.new(github_url: "https://github.com/octocat", name: "Octo Cat")
      expect(profile).to be_valid
    end
  end

  describe "callbacks" do
    it "generates github_url_short before saving if blank" do
      profile = GithubProfile.create!(github_url: "https://github.com/octocat", name: "Octo Cat")
      expect(profile.github_url_short).to be_present
      expect(profile.github_url_short.length).to be >= 6
    end

    it "does not overwrite existing github_url_short" do
      existing_short = "custom123"
      profile = GithubProfile.create!(
        github_url: "https://github.com/octocat",
        name: "Octo Cat",
        github_url_short: existing_short
      )
      expect(profile.github_url_short).to eq(existing_short)
    end
  end

  describe "#short_github_url" do
    it "returns the shortened URL using the route helper" do
      profile = GithubProfile.create!(github_url: "https://github.com/octocat", name: "Octo Cat")
      expected_url = Rails.application.routes.url_helpers.short_url(profile.github_url_short, only_path: true)
      expect(profile.short_github_url).to eq(expected_url)
    end
  end
end
