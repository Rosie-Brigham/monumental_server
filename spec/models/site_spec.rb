require 'rails_helper'
RSpec.describe Site, type: :model do
  # spec anything special to do with the site
  
  context 'associations' do
    it { should have_many(:submissions) }
  end 
end
