require 'rails_helper'

RSpec.describe Reporte, type: :model do
  it { should belong_to(:user) }
end
