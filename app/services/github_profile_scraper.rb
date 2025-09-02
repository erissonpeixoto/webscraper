require 'httparty'
require 'nokogiri'

class GithubProfileScraper
  def initialize(github_url)
    @github_url = github_url
  end

  def scrape
    begin
      response = HTTParty.get(@github_url)
      return nil unless response.success?

      doc = Nokogiri::HTML(response.body)

      {
        github_username: @github_url.split('/').last,
        name: doc.at('span.p-name')&.text&.strip,
        avatar_url: doc.at('img.avatar-user')&.[]('src'),
        followers: doc.at('a[href$="?tab=followers"] .text-bold')&.text&.strip&.gsub(',', '')&.to_i,
        following: doc.at('a[href$="?tab=following"] .text-bold')&.text&.strip&.gsub(',', '')&.to_i,
        stars: doc.at('a[href$="?tab=stars"] .text-bold')&.text&.strip&.gsub(',', '')&.to_i,
        organization: doc.at('span.p-org')&.text&.strip,
        location: doc.at('span.p-label')&.text&.strip,
        contributions: extract_contributions(doc)
      }
    rescue StandardError => e
      Rails.logger.error(e.message)
      nil
    end
  end

  private

  def extract_contributions(doc)
    text = doc.at('h2.f4.text-normal.mb-2')&.text
    return nil unless text
    match = text.match(/(\d[\d,]*) contributions/)
    match ? match[1].gsub(',', '').to_i : nil
  end
end
