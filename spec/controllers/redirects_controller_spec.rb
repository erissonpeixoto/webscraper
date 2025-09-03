require "rails_helper"

RSpec.describe RedirectsController, type: :controller do
  describe "GET #show" do
    let(:github_url) { "https://github.com/octocat" }

    context "when the github_profile exists and has a github_url" do
      let!(:profile) { GithubProfile.create!(github_url: github_url, name: "Octo Cat", github_url_short: "abc123") }

      it "redirects to the github_url" do
        get :show, params: { short_code: profile.github_url_short }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(github_url)
      end
    end

    context "when the github_profile does not exist" do
      it "returns 404 with 'Link inválido'" do
        get :show, params: { short_code: "naoexiste" }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq("Link inválido")
      end
    end

    context "when the github_profile exists but does not have a github_url" do
      let!(:profile) { GithubProfile.create!(github_url: github_url, name: "Octo Cat", github_url_short: "semurl") }

      it "returns 404 with 'Link inválido'" do
        profile.update_column(:github_url, nil)
        get :show, params: { short_code: profile.github_url_short }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq("Link inválido")
      end
    end
  end
end
