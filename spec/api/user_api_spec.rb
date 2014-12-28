require 'rails_helper'

RSpec.describe 'get /api/v1/users/:id', type: :request do
  context 'when the user exists' do
    let(:user) { create(:user) }
    before { get "/api/v1/users/#{user.id}" }

    specify { expect(response.code).to eq '200' }

    it 'returns the users properties' do
      expect(json['first_name']).to eq 'John'
    end
  end

  context 'when the user does not exist' do
    before { get "/api/v1/users/3434343434" }
    specify { expect(response.code).to eq '500' }
  end
end

RSpec.describe 'post /api/v1/users', type: :request do
  context 'given all parameters' do
    before do
      post '/api/v1/users',
        first_name: 'Luke',
        last_name: 'Skywalker',
        email: 'luke@theforce.com'
    end

    it 'creates a new user' do
      expect(response.code).to eq '201'
      user = User.last
      expect(user.first_name).to eq 'Luke'
      expect(user.last_name).to eq 'Skywalker'
      expect(user.email).to eq 'luke@theforce.com'
    end
  end

  context 'given missing parameter' do
    it 'returns 500' do
      post '/api/v1/users', first_name: 'Luke'
      expect(response.code).to eq '500'
    end
  end
end

RSpec.describe 'put /api/v1/users/:id', type: :request do
  context 'given all parameters' do
    let(:user) { create(:user) }
    before do
      put "/api/v1/users/#{user.id}",
      first_name: 'Anakin'
    end

    it 'creates updates the user' do
      expect(response.code).to eq '200'
      user = User.last
      expect(user.first_name).to eq 'Anakin'
    end
  end

  context 'given missing parameter' do
    it 'returns 500' do
      post '/api/v1/users', first_name: 'Luke'
      expect(response.code).to eq '500'
    end
  end
end

RSpec.describe 'delete /api/v1/users/1', type: :request do
  context 'given existing user' do
    it 'deletes the user' do
      user = create(:user)
      delete "/api/v1/users/#{user.id}"
      expect(response.code).to eq '200'
    end
  end
end

RSpec.describe 'post /api/v1/users/:id/location', type: :request do
  let(:user) { create(:user) }

  context 'post with all params' do
    before do
      post "/api/v1/users/#{user.id}/location",
      x: '52.440723',
      y: '4.809657',
      z: '0',
      m: '0'
      #id: "#{user.id}"
    end

    it 'returns 201' do
      expect(response.code).to eq '201'
    end

    it 'returns a message' do
      expect(response.message).to eq 'Created'
    end

    it 'creates a new location' do
      expect(user.locations.count).to eq 1
      expect(user.locations.last.longlat.x).to eq 52.440723
      expect(user.locations.last.longlat.y).to eq 4.809657
      expect(user.locations.last.longlat.z).to eq 0
      expect(user.locations.last.longlat.m).to eq 0
    end
  end

  context 'post with too little params' do
    before do
      post "/api/v1/users/#{user.id}/location",
      x: "11"
    end

    it 'returns 500' do
      expect(response.code).to eq '500'
    end

    it 'returns a vague message' do
      expect(response.message).to eq 'Internal Server Error'
    end

    it 'does not create a new location' do
      expect(user.locations.count).to eq 0
    end
  end
end

RSpec.describe 'get /api/v1/users/:id/location', type: :request do
  let(:user) { create(:user) }
  before do
    user.locations.create(
    longlat:"POINT(52.440723 4.809657 0 0)")
    #get '/api/v1/location', id: user.id
    get "/api/v1/users/#{user.id}/location"
  end

  it 'returns 200' do
    expect(response.code).to eq '200'
  end

  it 'returns the location in json' do
    json = JSON.parse(response.body)
    expect(json['x']).to eq 52.440723
    expect(json['y']).to eq 4.809657
  end
end
