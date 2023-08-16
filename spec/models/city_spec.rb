require 'rails_helper'

RSpec.describe City, type: :model do
  describe 'validations' do
    it 'is not valid without a name' do
      city = City.new(name: nil)
      expect(city.valid?).to be(false)
      expect(city.errors[:name]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a state' do
      association = described_class.reflect_on_association(:state)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'search' do
    let!(:state_rio_de_janeiro) { State.create(name: 'Rio de Janeiro', abbreviation: 'RJ') }
    let!(:state_sao_paulo) { State.create(name: 'São Paulo', abbreviation: 'SP') }

    let!(:city_angra_dos_reis) { City.create(name: 'Angra dos Reis', state: state_rio_de_janeiro) }
    let!(:city_rio_de_janeiro) { City.create(name: 'Rio de Janeiro', state: state_rio_de_janeiro) }
    let!(:city_sao_paulo) { City.create(name: 'São Paulo', state: state_sao_paulo) }

    it 'returns cities based on state name and city name' do
      search_results = City.search('Rio de Janeiro', 'Ang')
      expect(search_results).to include(city_angra_dos_reis)
      expect(search_results).not_to include(city_rio_de_janeiro, city_sao_paulo)
    end

    it 'returns cities only based on city name if state name is not provided' do
      search_results = City.search(nil, 'Paulo')
      expect(search_results).to include(city_sao_paulo)
      expect(search_results).not_to include(city_rio_de_janeiro, city_angra_dos_reis)
    end

    it 'returns empty array if no matching cities are found' do
      search_results = City.search('Espirito Santo', 'Vito')
      expect(search_results).to be_empty
    end
  end
end
