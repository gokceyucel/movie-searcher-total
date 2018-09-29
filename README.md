# Getting started
1. Get
`git clone --recurse-submodules git@github.com:gokceyucel/movie-searcher-total.git`
2. Change
`cd movie-searcher-total`
3. Update
`git submodule update --recursive --remote`
4. Run
`docker-compose up`
5. Go to http://localhost:9090/ in your favorite web browser.


# Solution and decisions to functional requirements
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
# Time spent
- 
