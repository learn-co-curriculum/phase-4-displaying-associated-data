# Displaying Associated Data

## Learning Goals

- Use Active Model associations in the controller
- Render nested JSON data based on model associations

## Introduction

In this section, we're going to be building out an API for an exciting new
business: AirBudNB, a website for renting dog houses. We are using two models to
represent our application's data: **dog houses** and **reviews**. A dog house
has many reviews, and each review belongs to one dog house.

```txt
DogHouse -< Review
```

![AirBudNB entity relationship diagram](https://curriculum-content.s3.amazonaws.com/phase-4/displaying-associated-data/airbudnb-erd.png)

The code for our models is already in place, so we can focus on getting the
controller to return the right data. To get set up, run:

```console
$ bundle install
$ rails db:migrate db:seed
```

## Nesting has_many Associations

Our designers have created a mockup of one of the pages of our application for
displaying details about one individual dog house. It will look like this:

![AirBudNB reviews page](https://curriculum-content.s3.amazonaws.com/phase-4/displaying-associated-data/airbudnb-dog_houses-show.png)

Our API will need to serve up the data for this page as efficiently as possible.
Ideally, that means we'll be able to have just **one** request that returns the
data about the dog house as well as a list of all its reviews.

Start up your Rails server and make a GET request to `/dog_houses/1`. Check
out the controller action for this request:

```rb
# app/controllers/dog_houses_controller.rb
def show
  dog_house = DogHouse.find(params[:id])
  render json: dog_house
end
```

Currently, this route returns _only_ the data about the dog house, not its
reviews:

```json
{
  "id": 1,
  "image": "https://assets.petco.com/petco/image/upload/f_auto,q_auto/1563564-right-1",
  "name": "Cozy Studio in Historic District",
  "city": "Denver",
  "price": 90,
  "favorite": false,
  "latitude": "39.7433",
  "longitude": "-104.98322"
}
```

> _Note_: the seed file creates seed data randomly, so the data you see in your
> browser will be different.

Based on our models, we know each dog house has many reviews associated with it,
and we can use Active Record to access that data:

```rb
class DogHouse < ApplicationRecord
  has_many :reviews
end
```

You can verify this by running `rails c`:

```rb
DogHouse.first.reviews
# => #<ActiveRecord::Associations::CollectionProxy [#<Review id: 1...>, #<Review id: 2...>]
```

So we need some way to **include** this review data in the response from our
controller!

Thankfully for us, Rails gives us some additional [serialization][] options when
converting Active Record objects to JSON data. In this case, the `include`
option will let us nest associated data in our response. Let's update the code
in our controller:

```rb
render json: dog_house, include: :reviews
```

Using `include: :reviews` will call the `.reviews` method that is provided with
the `has_many :reviews` macro, and will serialize the reviews as a nested array
of JSON data. Try making that same `GET /dog_houses/1` request again, and you
should now see the reviews listed along with the dog house they belong to.
Again, your data will be different, but it should be structured as follows:

```json
{
  "id": 1,
  "image": "https://assets.petco.com/petco/image/upload/f_auto,q_auto/1563564-right-1",
  "name": "Cozy Studio in Historic District",
  "city": "Denver",
  "price": 90,
  "favorite": false,
  "latitude": "39.7433",
  "longitude": "-104.98322",
  "reviews": [
    {
      "id": 1,
      "username": "emory_rolfson",
      "comment": "Listicle diy messenger bag food truck yuccie pug thundercats.",
      "rating": 4,
      "dog_house_id": 1
    },
    {
      "id": 2,
      "username": "willena",
      "comment": "Brunch aesthetic williamsburg taxidermy.",
      "rating": 1,
      "dog_house_id": 1
    }
  ]
}
```

Now, our API returns all the data we need to handle this view on the frontend
with just one request.

## Nesting belongs_to Data

One of the other pages our frontend will need is a page to list out all of the
top reviews, along with their associated dog house:

![AirBudNB reviews page](https://curriculum-content.s3.amazonaws.com/phase-4/displaying-associated-data/airbudnb-reviews-index.png)

Again, we'd like to make just one request to get all of the data to populate
this view. Currently, a `GET` to `/reviews` returns an array of all review
data, but it's missing the data we need for the associated dog house:

```json
[
  {
    "id": 3,
    "username": "alton",
    "comment": "Meh polaroid letterpress occupy freegan.",
    "rating": 5,
    "dog_house_id": 1
  },
  {
    "id": 4,
    "username": "malorie.grant",
    "comment": "8-bit 3 wolf moon tattooed blog +1.",
    "rating": 5,
    "dog_house_id": 1
  },
  {
    "id": 10,
    "username": "mary.hodkiewicz",
    "comment": "Fixie art party cronut pug tattooed.",
    "rating": 5,
    "dog_house_id": 2
  }
]
```

We can see that each review has an associated dog house based on the
`dog_house_id` attribute, but it'd be quite the ordeal to make individual
requests for each dog house to get the associated data! Again, we can leverage
the power of our Active Record associations, and serialize the dog house along
with each review:

```rb
class ReviewsController < ApplicationController

  def index
    reviews = Review.all.order(rating: :desc)
    render json: reviews, include: :dog_house
  end

end
```

With this `include: :dog_house` option in place, we now get a nested object
under each review representing the dog house that the review belongs to:

```json
[
  {
    "id": 3,
    "username": "alton",
    "comment": "Meh polaroid letterpress occupy freegan.",
    "rating": 5,
    "dog_house_id": 1,
    "dog_house": {
      "id": 1,
      "image": "https://assets.petco.com/petco/image/upload/f_auto,q_auto/1563564-right-1",
      "name": "Cozy Studio in Historic District",
      "city": "Denver",
      "price": 90,
      "favorite": false,
      "latitude": "39.7433",
      "longitude": "-104.98322"
    }
  },
  {
    "id": 4,
    "username": "malorie.grant",
    "comment": "8-bit 3 wolf moon tattooed blog +1.",
    "rating": 5,
    "dog_house_id": 1,
    "dog_house": {
      "id": 1,
      "image": "https://assets.petco.com/petco/image/upload/f_auto,q_auto/1563564-right-1",
      "name": "Cozy Studio in Historic District",
      "city": "Denver",
      "price": 90,
      "favorite": false,
      "latitude": "39.7433",
      "longitude": "-104.98322"
    }
  },
  {
    "id": 10,
    "username": "mary.hodkiewicz",
    "comment": "Fixie art party cronut pug tattooed.",
    "rating": 5,
    "dog_house_id": 2,
    "dog_house": {
      "id": 2,
      "image": "https://loveincorporated.blob.core.windows.net/contentimages/gallery/e7fd2f69-8c5b-4865-8add-d3ae27693f45-bowwowhaus.jpg",
      "name": "Mid Century Studio in Lively Uptown",
      "city": "Houston",
      "price": 88,
      "favorite": false,
      "latitude": "29.750588",
      "longitude": "-95.364063"
    }
  }
]
```

Now we can retrieve all the data for our reviews page with just one request!

You may notice that making the request for this data is a bit slow compared to
some of the other endpoints we've been working on. This is due to how Active
Record is accessing data for the associated dog house for each individual
review.

If you open the Rails server log after making this request, you'll see why:
there are a lot of SQL queries being fired off at our database! This is an
example of the [N+1 problem][n+1 problem]. First, we load all reviews with
`Review.all`; then, for each review returned by `Review.all`, we make a separate
query for each dog house associated with that review. This is definitely not
ideal! We'll learn about a solution to this problem in a future lesson, but for
now, keep an eye out for slow queries and look at the SQL code being executed in
your Rails server to identify where these issues arise.

[n+1 problem]: https://www.sitepoint.com/silver-bullet-n1-problem/

## Conclusion

When developing APIs with our frontend needs in mind, it's best to structure our
data to minimize the number of requests needed for the frontend to retrieve that
data. We can take advantage of Active Record associations using `has_many` and
`belongs_to` relationships, and serialize JSON data between related models using
the `include` option.

## Check For Understanding

Before you move on, make sure you can answer the following question:

1. What does the `include` option do for us and how do we use it?

## Resources

- [Serialization: as_json][serialization]

[serialization]: https://api.rubyonrails.org/classes/ActiveModel/Serializers/JSON.html#method-i-as_json
