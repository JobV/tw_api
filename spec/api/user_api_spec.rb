require 'rails_helper'

RSpec.describe '/api/v1/users/:id', type: :request do
  context 'when the user exists' do
    let(:user) { create(:user) }
    before { get "/api/v1/users/#{user.id}" }

    specify { expect(response.code).to eq '200' }

    it 'returns the users properties' do
      expect(json['first_name']).to eq 'John'
    end
  end
end
