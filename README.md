

# Getting started

## Prerequisites
- Docker v18.x

## How to run server and client 
```sh
# Clone
git clone --recurse-submodules git@github.com:gokceyucel/movie-searcher-total.git
cd movie-searcher-total

# Update submodules if necessary
git submodule update --recursive --remote

# Run
docker-compose up

# Run with --build option to get updates
docker-compose up --build
```
Now go to "http://127.0.0.1:9090/" in your favorite web browser. (Chrome v69+ is preferred)


# Solution and decisions to functional requirements
## Backend
1. > *__... /api/search?keyword=foo endpoint should return the first 20 results in 1 request, that means you need to make 2 requests to the external API as it will return only 10 results each time.__*

    After returning first set of results from the external api, I check number of results. If they're greater than 10, I make a second request to get more results. After that, I combine them and return with a response of 20 objects.

2. >  *__If a user searches for the same keyword again within 30 seconds, the request should not go the server again and should be served from the browser cache instead.__*

    I've decided to benefit from Cache-Control header (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control). To perform this, I return 'Cache-Control=private,max-age=30' header in the response.

3. > *__Each search result should be cached on the server indefinitely and served from the cache if requested again. Use any cache library or store if you prefer.__*
    
    > *__If many concurrent requests hit the server searching for the same keyword, the external API should be called only once and all requests should be served__*
  
    Implemented a simple in-memory cache middleware and used it in search router like this: 
    ```sh 
    search.get('/', cache, (req, res)...)
    ```

## Frontend
1. > *__Display the results as a grid of 3 columns, for each movie display the movie poster returned from API and the movie title below it. On mobile screens (width <= 768px), the grid will be 2 columns.__*

    Basically I benefited from Bootstrap 3's grid system.

2. > *__You should start to fetch and display the results from the backend once the user types 3 characters or more in the search bar. If the user is typing, don't make any API calls until they stop typing for 300ms.__*

    I've decided to implement this requirement by creating a component (`src/app/components/SearchInput.js`) which takes arguments as props. This way I provided reusability and it's customizable.

3. > *__Consider all the possible UI states: initial, loading, error,... and present them to the user clearly. No fancy UI required__*

    Each possible UI states handled by actions and reducers. A simple text displayed below the search.


## Overall
1. > *__A single command to run the frontend & backend. Using docker is preferred.__*

    I've seperated backend and frontend applications to their own repositories. So to meet this particular requirement, I've created another repository which includes backend and frontend apps as submodules, and used docker-compose to build and run them both in a single command. Instructions are at the top of this document.

2. > *__Feel free to use any boilerplate to start the project, but remove unused code before submitting the challenge.__*

    I've used very simple boilerplates and left MIT license declarations for the sake of copywrite owners.

# Time spent
Roughtly 
- ~5 hours for frontend 
- ~4.5 hours for backend
- ~1.5 hours for sum-up, clean-up, finalize.

Overall ~11 hours.

# What would I change to make it production ready?
- Take linting more seriously. Put more work into eslint rules and add it to npm script lifescyle.
- Improve test coverage. Maybe do some automated browser tests using tools like Selenium.
- Use pre-commit hooks to standardize commit messages.
- Move all configs and secrets (api keys, urls, db connections etc.) out of the source code and manage them seperatly for each environment (test, stage, prod etc.).
- Add more work into the build steps to optimize generated bundled files.
- Protect master branches of repositories, develop in seperated branched then merge into the master.
- Put more effort on versioning. In terms of api endpoints as well. (`/api/v1/search?keyword=...`)

# What would I do differently if I had more time?
- Definetly use Create React App boilerplate in frontend.
- Use some external key-value storage for cache in backend. Like Redis.
- Put more effort on project structure and merge all repositories into a mono repo to avoid using git submodules and make it simpler.

# Some screenshots
![Desktop Screenshot](https://github.com/gokceyucel/movie-searcher-total/blob/master/screenshots/chrome-desktop.png "Desktop Screenshot") 

![Mobile Screenshot](https://github.com/gokceyucel/movie-searcher-total/blob/master/screenshots/safari-mobile-ios.png "Mobile Screenshot")

