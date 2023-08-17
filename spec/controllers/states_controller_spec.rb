# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatesController, type: :controller do
  before(:each) do
    City.destroy_all
    State.destroy_all
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns JSON representation of all states' do
      state1 = State.create(name: 'Espirito Santo', abbreviation: 'ES')
      state2 = State.create(name: 'Amazonas', abbreviation: 'AM')

      get :index
      expected_response = [
        { 'id' => state1.id, 'name' => 'Espirito Santo', 'abbreviation' => 'ES' },
        { 'id' => state2.id, 'name' => 'Amazonas', 'abbreviation' => 'AM' }
      ]
      parsed_response = JSON.parse(response.body).map { |response| response.slice('id', 'name', 'abbreviation') }

      expect(parsed_response).to eq(expected_response)
    end
  end

  describe 'GET #show' do
    let(:state) { State.create(name: 'Espirito Santo', abbreviation: 'ES') }

    it 'returns a successful response' do
      get :show, params: { id: state.id }
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct state JSON' do
      get :show, params: { id: state.id }
      expected_response = { 'id' => state.id, 'name' => 'Espirito Santo', 'abbreviation' => 'ES' }
      parsed_response = JSON.parse(response.body).slice('id', 'name', 'abbreviation')
      expect(parsed_response).to eq(expected_response)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_attributes) { { state: { name: 'Amazonas', abbreviation: 'AM' } } }

      it 'creates a new state' do
        expect do
          post :create, params: valid_attributes
        end.to change(State, :count).by(1)
      end

      it 'returns a JSON representation of the created state' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('Amazonas')
        expect(json_response['abbreviation']).to eq('AM')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { state: { name: '' } } }

      it 'does not create a new state' do
        expect do
          post :create, params: invalid_attributes
        end.not_to change(State, :count)
      end

      it 'returns a JSON representation of errors' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('name')
      end
    end
  end

  describe 'PATCH #update' do
    let(:state) { State.create(name: 'Espirito Santo', abbreviation: 'ES') }

    context 'with valid attributes' do
      let(:valid_attributes) { { state: { name: 'Espírito Santo', abbreviation: 'ES' } } }

      it 'updates the state' do
        patch :update, params: { id: state.id, state: { name: 'Espírito Santo' } }
        state.reload
        expect(state.name).to eq('Espírito Santo')
      end

      it 'returns a JSON representation of the updated state' do
        patch :update, params: { id: state.id, state: { name: 'Espírito Santo' } }
        expect(response).to have_http_status(:success)

        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('Espírito Santo')
      end
    end

    context 'with invalid attributes' do
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
        expect(json_response).to have_key('name')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:state) { State.create(name: 'Espirito Santo', abbreviation: 'ES') }

    it 'destroys the state' do
      expect do
        delete :destroy, params: { id: state.id }
      end.to change(State, :count).by(-1)
    end

    it 'returns a no content response' do
      delete :destroy, params: { id: state.id }
      expect(response).to have_http_status(:no_content)
    end
  end
end
