# spec/services/github_profile_scraper_spec.rb
require "rails_helper"

RSpec.describe GithubProfileScraper do
  let(:github_url) { "https://github.com/octocat" }
  let(:scraper) { described_class.new(github_url) }

  describe "#scrape" do
    context "when the HTTP response is successful" do
      let(:html_body) do
        <<-HTML
          <html>
            <body>
              <span class="p-name">The Octocat</span>
              <img class="avatar-user" src="https://avatars.githubusercontent.com/u/583231?v=4" />
              <a href="/octocat?tab=followers"><span class="text-bold">1,234</span></a>
              <a href="/octocat?tab=following"><span class="text-bold">56</span></a>
              <a href="/octocat?tab=stars"><span class="text-bold">78</span></a>
              <span class="p-org">GitHub</span>
              <span class="p-label">San Francisco</span>
              <h2 class="f4 text-normal mb-2">1,567 contributions in the last year</h2>
            </body>
          </html>
        HTML
      end

      let(:http_response) { instance_double(HTTParty::Response, success?: true, body: html_body) }

      before do
        allow(HTTParty).to receive(:get).with(github_url).and_return(http_response)
      end

      it "returns the extracted data correctly" do
        result = scraper.scrape

        expect(result[:github_username]).to eq("octocat")
        expect(result[:name]).to eq("The Octocat")
        expect(result[:avatar_url]).to eq("https://avatars.githubusercontent.com/u/583231?v=4")
        expect(result[:followers]).to eq(1234)
        expect(result[:following]).to eq(56)
        expect(result[:stars]).to eq(78)
        expect(result[:organization]).to eq("GitHub")
        expect(result[:location]).to eq("San Francisco")
        expect(result[:contributions]).to eq(1567)
      end
    end

    context "when the HTTP response is not successful" do
      let(:http_response) { instance_double(HTTParty::Response, success?: false) }

      before do
        allow(HTTParty).to receive(:get).and_return(http_response)
      end

      it "returns nil" do
        expect(scraper.scrape).to be_nil
      end
    end

    context "when an unexpected error occurs" do
      before do
        allow(HTTParty).to receive(:get).and_raise(StandardError.new("timeout"))
        allow(Rails.logger).to receive(:error)
      end

      it "returns nil and logs the error" do
        expect(scraper.scrape).to be_nil
        expect(Rails.logger).to have_received(:error).with("timeout")
      end
    end
  end
end
