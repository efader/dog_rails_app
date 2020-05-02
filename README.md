# Tasks and Notes
All tasks are completed. Where there was ambiguity in design or implementation, I made what I believe are reasonable assumptions; In all cases, these assumptions are debatable and easily changed, time permitting.

> Add pagination to index page, to display 5 dogs per page

* Completed. Page size is adjustable by query param for future use.

> Add the ability to for a user to input multiple dog images on an edit form or new dog form

* Completed. Number of images is somewhat impractically changed with query parameters, but I believe the challenge at the heart of the task is addressed. A future improvement would be to dynamically create a new image upload field with client-side templating after each successive image is selected.

> Associate dogs with owners

* Completed. I created a "claim" feature to make it easier for me to test this and other features. Dogs are not automatically assigned to owners when created.

> Allow editing only by owner

* Completed. Although not specified, delete operations are also restricted to owners.

> Allow users to like other dogs (not their own)

* Completed. Dogs cannot be unliked. Dogs can be liked multiple times by the same user, although this is not exposed in the UI. Dogs can be liked and then claimed by the same user, which may not be considered an acceptable state.

> Allow sorting the index page by number of likes in the last hour

* Completed. Dogs that received no likes in the last hour are not displayed. Changing sort order does not change page number. The query is a big clunky and refactoring may move it into models to avoid bloating the controller.

> Display the ad.jpg image (saved at app/assets/images/ad.jpg) after every 2 dogs in the index page, to simulate advertisements in a feed.

* Completed. I stared at this for a moment and wondered why it wasn't displaying until I remembered that my adblocker was on!

***


# Welcome

This repository contains starter code for a technical assessment. The challenges can be done at home before coming in to discuss with the Bark team or can be done as a pairing exercise at the Bark office. Either way, we don't expect you to put more than an hour or two into coding. We recommend forking the repository and getting it running before starting the challenge if you choose the pairing approach.

# Set up

Fork this repository and clone locally

You'll need [ruby 2.2.4](https://rvm.io/rvm/install) and [rails 5](http://guides.rubyonrails.org/getting_started.html#installing-rails) installed.

Run `bundle install`

Initialize the data with `rake db:reset`

Run the specs with `rspec`

Run the server with `rails s`

View the site at http://localhost:3000
