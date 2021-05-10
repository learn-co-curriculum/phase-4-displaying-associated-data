# variables for generating random data
place_adjectives = [
  "Beautiful",
  "Gorgeous",
  "Lovely",
  "Stunning",
  "Convenient",
  "Cozy",
  "Modern",
  "Airy",
  "Stylish",
  "Mid Century"
]

places = [
  "Studio",
  "Flat",
  "Apartment",
  "Home"
]

location_adjectives = [
  "Lively",
  "Quiet",
  "Scenic",
  "Beautiful",
  "Historic"
]

locations = [
  "Downtown",
  "Uptown",
  "Neighborhood",
  "District"
]

images = [
  "https://assets.petco.com/petco/image/upload/f_auto,q_auto/1563564-right-1",
  "https://i.etsystatic.com/7583922/r/il/7ef73f/1059263558/il_570xN.1059263558_qhur.jpg",
  "https://thinkoutside.biz/wp-content/uploads/2018/01/The-Shack-Dog-House-EC4200-HR-1.jpg",
  "https://cdn3.volusion.com/ormg6.urzw5/v/vspfiles/photos/BFW-CUBIX-2.jpg?v-cache=1528278873",
  "https://thebeastreviews.com/wp-content/uploads/2020/10/Best-Dog-Houses.jpg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRGu3wZzqFNT3IGEQZKDVzGQMbPQOgRZ4e_lxzlPiPdwtDxhIJH&usqp=CAU",
  "https://petlifetoday.com/wp-content/uploads/2017/10/shutterstock_137357879-min.jpg",
  "https://cdn.motor1.com/images/mgl/NvjmG/s1/ford-noise-cancelling-dog-kennel.jpg",
  "https://i.pinimg.com/originals/24/bb/c7/24bbc748799c4581a24aebe909c10ad3.jpg",
  "https://funnyneel.com/image/files/i/01-2014/funny-gadgets-dog-house.preview.jpg",
  "https://cdn.homedit.com/wp-content/uploads/2019/02/Green-dog-cool-house-design.jpg",
  "https://loveincorporated.blob.core.windows.net/contentimages/gallery/ce1db338-5914-4505-9fa2-ca4bcddb1b4e-hecate-verona-luxury-doghouse.jpg",
  "https://loveincorporated.blob.core.windows.net/contentimages/gallery/e7fd2f69-8c5b-4865-8add-d3ae27693f45-bowwowhaus.jpg",
  "https://loveincorporated.blob.core.windows.net/contentimages/gallery/c3e1659b-3a95-4316-b5df-c3ac4ae72685-Windsor%20Castle%20replica%201.jpg"
]

cities = [
  {
    name: "New York",
    lat: 40.7128,
    lng: -74.0060
  },
  {
    name: "Chicago",
    lat: 41.8781, 
    lng: -87.6298
  },
  {
    name: "Seattle",
    lat: 47.6062, 
    lng: -122.3321
  },
  {
    name: "Washington D.C.",
    lat: 38.9072,
    lng: -77.0369
  },
  {
    name: "Denver",
    lat: 39.7392, 
    lng: -104.9903
  },
  {
    name: "Houston",
    lat: 29.7604, 
    lng: -95.3698
  }
]

# generate a random latitude/longitude
# https://gis.stackexchange.com/questions/25877/generating-random-locations-nearby
def random_lat_lng(start_x, start_y)
  r = 1 / 111.32
  u = rand
  v = rand

  w = r * Math.sqrt(u)
  t = 2 * Math::PI * v
  x = w * Math.cos(t) 
  y = w * Math.sin(t)

  x = x / Math.cos(start_y)

  [x + start_x, y + start_y]
end

puts "🐕 Seeding data..."

# Create 100 random dog houses
100.times do
  city = cities.sample
  lat_lng = random_lat_lng(city[:lat], city[:lng])

  dog_house = DogHouse.create(
    image: images.sample,
    name: "#{place_adjectives.sample} #{places.sample} in #{location_adjectives.sample} #{locations.sample}",
    city: city[:name],
    price: rand(10..100),
    favorite: false,
    latitude: lat_lng[0],
    longitude: lat_lng[1]
  )

  # Create 3-7 random reviews for each dog house
  # Uses Faker for fake data https://github.com/faker-ruby/faker
  rand(3..7).times do
    Review.create(
      dog_house_id: dog_house.id,
      username: Faker::Internet.username,
      comment: Faker::Hipster.sentence,
      rating: rand(1..5)
    )
  end
end

puts "✅ Done seeding!"
