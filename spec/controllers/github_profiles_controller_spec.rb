require "rails_helper"

RSpec.describe GithubProfilesController, type: :controller do
  before do
    allow_any_instance_of(GithubProfilesController).to receive(:require_authentication)
  end

  before(:each) do
    GithubProfile.delete_all
  end

  let!(:profile1) { GithubProfile.create!(github_url: "https://github.com/octocat", name: "Octo Cat") }
  let!(:profile2) { GithubProfile.create!(github_url: "https://github.com/hubber", name: "Hub Ber") }

  describe "GET #index" do
    context "sem filtro" do
      it "return all profiles" do
        get :index
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json.size).to eq(2)
      end
    end

    context "without filter by name" do
      it "returns profiles filtered by name or github_url" do
        get :index, params: { name: "octo" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json.size).to eq(1)
        expect(json.first["github_url"]).to eq("https://github.com/octocat")
      end
    end
  end

  describe "GET #show" do
    it "returns the requested profile" do
      get :show, params: { id: profile1.id }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json["github_url"]).to eq(profile1.github_url)
    end

    it "returns 404 if not found" do
      expect {
        get :show, params: { id: 9999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "POST #create" do
    let(:valid_params) { { github_profile: { name: "New User", github_url: "https://github.com/newuser" } } }

    before do
      scraper_double = double("GithubProfileScraper", scrape: { organization: "Org", location: "Earth" })
      allow(GithubProfileScraper).to receive(:new).and_return(scraper_double)
    end

    it "creates a new profile successfully" do
      expect {
        post :create, params: valid_params
      }.to change(GithubProfile, :count).by(1)
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq("New User")
      expect(json["organization"]).to eq("Org")
    end

    it "retorna erros se inválido" do
      invalid_params = { github_profile: { name: "" } }
      post :create, params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["name"]).to include("can't be blank")
    end
  end

  describe "PATCH #update" do
    let(:update_params) { { id: profile1.id, github_profile: { name: "Updated Name", github_url: "https://github.com/updated" } } }

    before do
      scraper_double = double("GithubProfileScraper", scrape: { organization: "Org2", location: "Mars" })
      allow(GithubProfileScraper).to receive(:new).and_return(scraper_double)
    end

    it "updates the profile successfully" do
      patch :update, params: update_params
      expect(response).to have_http_status(:ok)
      profile1.reload
      expect(profile1.name).to eq("Updated Name")
      expect(profile1.organization).to eq("Org2")
    end

    it "returns errors if invalid" do
      patch :update, params: { id: profile1.id, github_profile: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["name"]).to include("can't be blank")
    end
  end

  describe "DELETE #destroy" do
    it "removes the profile" do
      expect {
        delete :destroy, params: { id: profile1.id }
      }.to change(GithubProfile, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
