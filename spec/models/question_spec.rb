require 'rails_helper'

RSpec.describe Question, type: :model do

  describe  "associations" do
    # it {is_expected.to have_many(:answers)} # аналогичная запись
     it { should have_many(:answers) }
     it { should have_many(:answers).dependent(:destroy) }
  end

  describe "validations" do
    it {should validate_presence_of :title }
    it {should validate_presence_of :body }
  end

end
