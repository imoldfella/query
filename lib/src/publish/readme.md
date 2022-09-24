
Publish creates static files that can be hosted on any http server.

Things we do in this folder is resolve markdown/prosemirror files to static html and/or pdf. We build a static search index. We should break out a searcher that can search without needing to log in or start a database.

bare api will be

const index = datagrove("rootUrl","query")
interface Hit {
    more: ()=>Response
    results: [
        {
            ...stored fields

            "_htmlResult": {

            }
        },
    ]
}

// for geo searches we probably want to divide by geo first.
const tiles =   geoTiles("worldUrl", { lat: long: })

// now search in parallel
datagrove(tiles, "query")


// how do import geo things to search?
// csv 
