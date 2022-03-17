# frozen_string_literal: true

class Link < ApplicationRecord
  # belongs_to :question
  belongs_to :linkable, polymorphic: true, touch: true

  validates :name, :url, presence: true

  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'is invalid' }
  # validates :url, format: { with: URI.regexp(%w[http https]), message: 'is invalid' } # аналогичная запись

  def gist?
    URI(url).host.include?('gist')
  end

  def open_gist
    http_client = Octokit::Client.new
    http_client.gist(URI(url).path.split('/').last).files
  end
end
