# frozen_string_literal: true

class City < ApplicationRecord
  belongs_to :state

  validates :name, presence: true

  def self.search(state_name, city_name_part)
    cities_query = City.includes(:state)

    cities_query = cities_query.joins(:state).where('states.name ILIKE ?', "%#{state_name}%") if state_name.present?

    cities_query = cities_query.where('cities.name ILIKE ?', "%#{city_name_part}%") if city_name_part.present?

    cities_query.order('cities.name ASC')
  end
end
