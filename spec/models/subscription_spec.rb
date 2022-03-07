# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:subscription) { create(:subscription) }

  it 'factory should be valid' do
    expect(subscription).to be_valid
  end

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :question }
  end

  describe 'database' do
    it { should have_db_index(:user_id) }
    it { should have_db_index(:question_id) }
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_column(:question_id).of_type(:integer) }
  end
end
