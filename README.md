# SF Food Trucks

Hello and welcome!

This project is based on the [Peck Assessment](https://github.com/peck/engineering-assessment) and dataset indicated therein. It is foremost a dev starter project which I've so far used to explore new things and showcase typical work as it might be found in Elixir/Phoenix applications. 

## Installation

  * Run `mix setup` to install and setup dependencies
  * User credential and an API token will pop up at the end of install
  * Put it in `config.exs` where it says `<put api token here>`
  * You will need a Google API key. Follow the steps for generating a key on the [google console](https://developers.google.com/maps/documentation/javascript/get-api-key)
    * Once obtained, put your Google API key in `config.exs` where it says `<put google api key here>`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Rationale

What can we do with a dataset of food trucks in San Francisco? An interactive map for users to get a sampling and info on trucks around the city. For site admins and developers, authenticated routes and an API for CRUD actions. A daily background task pulls data from the source, creating and updating records in the database. This fetching can also be done at any time via the button in the UI at `/vendors`, updating the listed vendors in the table automatically. Tests and alterations demonstrate code practices and changes needed for a developing spec.

### Frontend
A simple UI in React displays a map loading a sampling of 100 random food truck from around the city. Click on a location marker to get information on the selected food truck. Pan and zoom around the map to get a closer look. The user location is fetched on mount, to see this, make sure to have location settings turned on and allowed for `localhost`.

### Backend
Use the provided API token for Bearer authentication to hit an endpoint to interact with vendors via API.

Request info:
   ```
   get "/vendors"
   get "/vendors/:id"
   post "/vendors"
   put "/vendors/update"
   { 
    "id": 486,
    "params":{
        "name": "Hey Now Food Truck"
    }
   }
   delete "/vendors/:id"
   ```

All routes are configured to work with localhost.

## Background

Much of my approach was to do some of the typical things you might see and add to an app in development. Some of the included development items are:
* Database seeding
* Migrations
* Raw SQL migrations/updates
* Mix task
* Background task
* PubSub

I also used this opportunity to explore some of the new patterns and conventions from the Phoenix 1.7 rollout that I hadn't fully developed with via the use of generators. Since my experience with LiveView is mostly based on the use of Surface it was interesting to see the examples and paradigms employed in the standard setup. Cleaning up commit history and creating PRs, as is typical in a collaborative development setting, were done to keep up with standard practices. 

Interesting tradeoffs include working in standard LiveView and new file structures in a more slot driven and context-like environment; avoiding `insert_all()` for bulk inserting to bypass large scale timestamp updating in exchange for no returned records if/after insert and therefore having to re-query for all records in the index view; and opting for Enum rather than Stream for processing fetched data since it's currently under 500 items. 

I'm delighted to have this starter project up and running. It's allowed me to re-engage with React, try out some unfamiliar tech (wip) and am excited to see where this goes!
