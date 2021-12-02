require 'rails_helper'

RSpec.describe Answer, type: :model do

  describe "associations" do
    it { should belong_to(:question) }
  end

  describe "validations" do
    it {should validate_presence_of :title }
    it {should validate_presence_of :body }
    it {should validate_presence_of :question_id }
  end

  describe "database" do
    it { should have_db_index(:question_id) }
    it { should have_db_column(:question_id).with_options(null: false) }
    it { should have_db_column(:question_id).of_type(:integer) }
  end
end
