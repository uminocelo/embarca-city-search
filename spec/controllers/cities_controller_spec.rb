# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a successful response' do
  it 'returns a successful response' do
    expect(response).to have_http_status(:success)
  end
end

RSpec.shared_examples 'a JSON representation of the city' do
  let(:state) { State.create(name: 'Espirito Santo', abbreviation: 'ES') }
  let(:city) { City.create(name: 'Vitoria', state: state) }

  it 'returns the correct JSON response' do
    get :show, params: { id: city.id }
    expected_response = { 'id' => city.id, 'name' => city.name, 'state_id' => state.id }
    parsed_response = JSON.parse(response.body).slice('id', 'name', 'state_id')
    expect(parsed_response).to eq(expected_response)
  end
end

RSpec.shared_examples 'a new city creation' do
  let(:state) { State.create(name: 'Espirito Santo', abbreviation: 'ES') }

  it 'creates a new city' do
    expect { post :create, params: valid_attributes }.to change(City, :count).by(1)
  end

  it 'returns a JSON representation of the created city' do
    post :create, params: valid_attributes
    expect(response).to have_http_status(:created)
    expect_json_response('Vitoria', 'state_id', state.id)
  end
end

RSpec.shared_examples 'an unprocessable entity response' do |invalid_key|
  it 'does not create a new city' do
    expect { post :create, params: invalid_attributes }.not_to change(City, :count)
  end

  it 'returns a JSON representation of errors' do
    post :create, params: invalid_attributes
    expect(response).to have_http_status(:unprocessable_entity)

    json_response = JSON.parse(response.body)
    expect(json_response).to have_key(invalid_key)
  end
end

RSpec.shared_examples 'an updated city' do |new_name|
  it 'updates the city name' do
    state = State.create(name: 'Espirito Santo', abbreviation: 'ES')
    city = City.create(name: 'Vitoria', state: state)

    patch :update, params: { id: city.id, city: { name: new_name, state_id: state.id } }
    city.reload

    expect(city.name).to eq(new_name)
  end

  it_behaves_like 'a successful response'
end

RSpec.shared_examples 'a destroyed city' do
  it 'destroys the city' do
    state = State.create(name: 'Espirito Santo', abbreviation: 'ES')
    city = City.create(name: 'Vitoria', state: state)
    expect { delete :destroy, params: { id: city.id } }.to change(City, :count).by(-1)
    expect(response).to have_http_status(:no_content)
  end
end

RSpec.describe CitiesController, type: :controller do
  before(:each) do
    City.destroy_all
    State.destroy_all
  end

  describe 'GET #show' do
    it_behaves_like 'a successful response'
    it_behaves_like 'a JSON representation of the city'
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_attributes) { { city: { name: 'Vitoria', state_id: state.id } } }

      it_behaves_like 'a new city creation'
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { city: { name: '' } } }

      it_behaves_like 'an unprocessable entity response', 'name'
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it_behaves_like 'an updated city', 'Guarapari'
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { city: { name: '' } } }
      it_behaves_like 'an unprocessable entity response', 'name'
    end
  end

  describe 'DELETE #destroy' do
    it_behaves_like 'a destroyed city'
  end

  def expect_json_response(name, key, value)
    json_response = JSON.parse(response.body)
    expect(json_response['name']).to eq(name)
    expect(json_response[key]).to eq(value)
  end
end
