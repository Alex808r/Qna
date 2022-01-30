# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples_for 'votable_object' do
  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:author) { create(:user) }

  describe 'Vote' do
    if described_class.to_s == 'Question'
      let(:subject) { create("#{model}_factory".underscore.to_sym, user: author) }
    else
      let(:subject) { create(model.to_s.underscore.to_sym, user: author) }
    end

    it '_up' do
      expect { subject.vote_up(user) }.to change { Vote.count }.from(0).to(1)
    end

    it '_down' do
      expect { subject.vote_down(user) }.to change { Vote.count }.from(0).to(1)
    end

    it '_cancel' do
      subject.vote_up(user)
      expect { subject.vote_cancel(user) }.to change { Vote.count }.from(1).to(0)
    end
  end
end
