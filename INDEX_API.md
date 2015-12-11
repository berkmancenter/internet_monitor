Internet Monitor Access Index API
=================================
The data, indicators, and weights used by Internet Monitor to index and score countries is public. With this data, third parties can work with the data, manipulate the weights to ask different questions, and create custom widgets.

This API adheres to the JSON API 1.0 specification: http://jsonapi.org/

Countries & Indicators
======================
The platform brings together various **datum sources** on Internet access and infrastructure to create the Internet Monitor Access Index, offering a starting point for further analysis of Internet access conditions in **countries** for which we have enough **indicators**. In the API, an indicator is the value a country has for a given datum source.

You can access country data, country scores, and all indicators used to calculate each country's score by using the /countries endpoint.

    GET https://thenetmonitor.org/countries HTTP/1.1
    Accept: application/vnd.api+json

The result is the country data and related indicator data.

    {
      "data": [
        {
          "type": "countries",
          "id": "96",
          "attributes": {
            "name": "South Korea",
            "iso_code": "KR",
            "iso3_code": "KOR",
            "score": 9.06027840425504
          },
          "links": {
            "self": "https://thenetmonitor.org/countries/96"
          }
          "relationships": {
            "indicators": {
              "data": [
                { "type": "indicators", "id": "10588" },
                { "type": "indicators", "id": "10589" },
                { "type": "indicators", "id": "10590" }
              ]
            }
          }
        }
      ],
      "included": [
        {
          "type": "indicators",
          "id": "10588",
          "attributes": {
            "original_value": 32.4173437895,
            "value": 0.7607223247455746
          },
          "relationships": {
            "datum_source": {
              "data": { "type": "datum_sources", "id": "7" }
            }
          }
        }
      ]
    }
    

