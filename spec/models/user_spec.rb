require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:logs).dependent(:destroy) }
  # Validation tests
  # ensure columns title and created_by are present before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
end
