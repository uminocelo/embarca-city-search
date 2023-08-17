# frozen_string_literal: true

states_data = [
  { name: 'Paraná', abbreviation: 'PR' },
  { name: 'Santa Catarina', abbreviation: 'SC' },
  { name: 'Rio Grande do Sul', abbreviation: 'RS' }
]

states_data.each do |state_data|
  State.create(state_data)
end

# PR
cities_pr = [
  'Abatiá',
  'Adrianópolis',
  'Agudos do Sul',
  'Curitiba'
]

parana_id = State.find_by(name: 'Paraná').id
unless parana_id.nil?
  cities_pr.each do |city_name|
    city_data = { state_id: parana_id, name: city_name }
    City.create(city_data)
  end
end

# SC
cities_sc = [
  'Abdon Batista',
  'Abelardo Luz',
  'Agrolândia'
]

santa_catarina_id = State.find_by(name: 'Santa Catarina').id
unless santa_catarina_id.nil?
  cities_sc.each do |city_name|
    city_data = { state_id: santa_catarina_id, name: city_name }
    City.create(city_data)
  end
end

# RS

cities_rs = [
  'Aceguá',
  'Água Santa',
  'Agudo'
]
rio_grande_do_sul_id = State.find_by(name: 'Rio Grande do Sul').id
unless rio_grande_do_sul_id.nil?
  cities_rs.each do |city_name|
    city_data = { state_id: rio_grande_do_sul_id, name: city_name }
    City.create(city_data)
  end
end
