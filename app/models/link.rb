# frozen_string_literal: true

class Link < ApplicationRecord
  # belongs_to :question
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true

  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'is invalid' }
  # validates :url, format: { with: URI.regexp(%w[http https]), message: 'is invalid' } # аналогичная запись

  def gist?
    URI(url).host.include?('gist')
  end
end
