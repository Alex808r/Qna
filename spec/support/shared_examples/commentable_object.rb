# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'commentable_object' do
  it { should have_many(:comments).dependent(:destroy) }
end
