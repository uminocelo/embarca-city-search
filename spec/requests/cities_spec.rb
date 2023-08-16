# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cities', type: :request do
  describe 'GET /cities/search' do
    it 'renders the search view' do
      get '/cities/search'
      expect(response).to have_http_status(:success)
    end
  end
end
