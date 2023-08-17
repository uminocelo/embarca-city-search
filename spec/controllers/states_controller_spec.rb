# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_context 'with states data' do
  let!(:state1) { State.create(name: 'Espirito Santo', abbreviation: 'ES') }
  let!(:state2) { State.create(name: 'Amazonas', abbreviation: 'AM') }

  let(:states_data) do
    [
      { 'id' => state1.id, 'name' => 'Espirito Santo', 'abbreviation' => 'ES' },
      { 'id' => state2.id, 'name' => 'Amazonas', 'abbreviation' => 'AM' }
    ]
  end
end

RSpec.shared_examples 'a JSON representation of states' do
  it 'returns JSON representation of all states' do
    get :index
    expected_response = states_data
    parsed_response = JSON.parse(response.body).map { |item| item.slice('id', 'abbreviation', 'name') }
    expect(parsed_response).to eq(expected_response)
  end
end

RSpec.shared_examples 'a JSON representation of a state for show action' do
  it 'returns the correct state JSON' do
    get :show, params: { id: state1.id }
    expected_response = { 'id' => state1.id, 'name' => state1.name, 'abbreviation' => state1.abbreviation }
    parsed_response = JSON.parse(response.body).slice('id', 'name', 'abbreviation')
    expect(parsed_response).to eq(expected_response)
  end
end

RSpec.shared_examples 'a new state creation' do
  it 'creates a new state' do
    expect { post :create, params: valid_attributes }.to change(State, :count).by(1)
  end

  it 'returns a JSON representation of the created state' do
    post :create, params: valid_attributes
    expect(response).to have_http_status(:created)

    json_response = JSON.parse(response.body)
    expect(json_response['name']).to eq(valid_attributes[:state][:name])
    expect(json_response['abbreviation']).to eq(valid_attributes[:state][:abbreviation])
  end
end

RSpec.shared_examples 'an updated state' do
  before do
    patch :update, params: { id: state.id, state: valid_attributes[:state] }
    state.reload
  end

  it 'updates the state' do
    expect(state.name).to eq(valid_attributes[:state][:name])
  end

  it 'returns a JSON representation of the updated state' do
    expect(response).to have_http_status(:success)

    json_response = JSON.parse(response.body)
    expect(json_response['name']).to eq(valid_attributes[:state][:name])
  end
end

RSpec.shared_examples 'an unprocessable entity response for state' do |invalid_key|
  it 'does not update the state' do
    original_name = state.name
    patch :update, params: { id: state.id, state: { name: '' } }
    state.reload
    expect(state.name).to eq(original_name)
  end

  it 'returns a JSON representation of errors' do
    patch :update, params: { id: state.id, state: { name: '' } }
    expect(response).to have_http_status(:unprocessable_entity)

    json_response = JSON.parse(response.body)
    expect(json_response).to have_key(invalid_key)
  end
end

RSpec.shared_examples 'a destroyed state' do
  it 'destroys the state' do
    expect { delete :destroy, params: { id: state.id } }.to change(State, :count).by(-1)
  end

  it 'returns a no content response' do
    delete :destroy, params: { id: state.id }
    expect(response).to have_http_status(:no_content)
  end
end

RSpec.shared_examples 'a #index for cities' do
  it 'returns a successful response' do
    get :index
    expect(response).to have_http_status(:success)
  end

  it_behaves_like 'a JSON representation of states'
end

RSpec.shared_examples 'a #show for city' do
  it 'returns a successful response' do
    get :show, params: { id: state1.id }
    expect(response).to have_http_status(:success)
  end

  it_behaves_like 'a JSON representation of a state for show action'
end

RSpec.describe StatesController, type: :controller do
  before(:each) do
    City.destroy_all
    State.destroy_all
  end

  describe 'GET #index' do
    include_context 'with states data'
    it_behaves_like 'a #index for cities'
  end

  describe 'GET #show' do
    include_context 'with states data'
    it_behaves_like 'a #show for city'
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_attributes) { { state: { name: 'Amazonas', abbreviation: 'AM' } } }

      it_behaves_like 'a new state creation'
    end
  end

  describe 'PATCH #update' do
    let(:state) { State.create(name: 'Espirito Santo', abbreviation: 'ES') }

    context 'with valid attributes' do
      let(:valid_attributes) { { state: { name: 'Espírito Santo', abbreviation: 'ES' } } }

      it_behaves_like 'an updated state'
    end

    context 'with invalid attributes' do
      it_behaves_like 'an unprocessable entity response for state', 'name'
    end
  end

  describe 'DELETE #destroy' do
    let!(:state) { State.create(name: 'Espirito Santo', abbreviation: 'ES') }

    it_behaves_like 'a destroyed state'
  end
end
