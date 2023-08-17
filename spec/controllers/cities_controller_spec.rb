# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CitiesController, type: :controller do
  before(:each) do
    City.destroy_all
    State.destroy_all
  end

  let(:state) { State.create(name: 'Espirito Santo', abbreviation: 'ES') }
  let!(:city) { City.create(name: 'Vitoria', state: state) }

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: city.id }
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct city JSON' do
      get :show, params: { id: city.id }
      expected_response = { 'id' => city.id, 'name' => city.name, 'state_id' => city.state_id }
      parsed_response = JSON.parse(response.body).slice('id', 'name', 'state_id')
      expect(parsed_response).to eq(expected_response)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_attributes) { { city: { name: 'Vitoria', state_id: state.id } } }

      it 'creates a new city' do
        expect { post :create, params: valid_attributes }.to change(City, :count).by(1)
      end

      it 'returns a JSON representation of the created city' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('Vitoria')
        expect(json_response['state_id']).to eq(state.id)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { city: { name: '' } } }

      it 'does not create a new city' do
        expect { post :create, params: invalid_attributes }.not_to change(City, :count)
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
    context 'with valid attributes' do
      let(:valid_attributes) { { city: { name: 'Vitoria', state_id: state.id } } }

      before do
        patch :update, params: { id: city.id, city: { name: 'Vitória' } }
        city.reload
      end

      it 'updates the city name' do
        expect(city.name).to eq('Vitória')
      end

      it 'returns a JSON representation of the updated city' do
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('Vitória')
        expect(json_response['state_id']).to eq(state.id)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the city' do
        original_name = city.name
        patch :update, params: { id: city.id, city: { name: '' } }
        city.reload
        expect(city.name).to eq(original_name)
      end

      it 'returns a JSON representation of errors' do
        patch :update, params: { id: city.id, city: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('name')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the city' do
      expect { delete :destroy, params: { id: city.id } }.to change(City, :count).by(-1)
    end

    it 'returns a no content response' do
      delete :destroy, params: { id: city.id }
      expect(response).to have_http_status(:no_content)
    end
  end
end
