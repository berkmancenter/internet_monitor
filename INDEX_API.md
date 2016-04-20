Internet Monitor Index API
=================================
The indicators, datum sources, and weights used by Internet Monitor to index and score countries is public. With this data, third parties can work with the indicators and manipulate the weights to answer new questions and create custom widgets.

This API adheres to the JSON API 1.0 specification: http://jsonapi.org/

Countries & Indicators
======================
The platform brings together various **datum sources** on Internet access and infrastructure to create the Internet Monitor Index, offering a starting point for further analysis of Internet access conditions in **countries** for which we have enough **indicators**. In the API, an indicator is the value a country has for a given datum source.

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
            "score": 9.06027840425504,
            "rank": 1
          },
          "links": {
            "self": "https://thenetmonitor.org/countries/96"
          },
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
            "start_date": "2008-01-01"
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
    
Each indicator contains the original value recorded for a country in a specific source of data (datum_source), e.g., Net Index average download speeds. The indicator also contains a weighted, calculated value which compares the given country with others and takes into account factors such as populations & GDPs. For more information on how our index values are calculated, see: [A Hackable Access Index](https://thenetmonitor.org/faq/a-hackable-access-index).

A country's score is a value between zero and ten. It the average of the groups of weighted scores of all the country's indicators in the **Access** category. It can be used to rank countries. The next section further describes which indicators are used to calculate the score.

Datum Sources, Categories, and Groups
=====================================
The Internet Monitor aggregates data from various external sources (**datum_sources** in the API) from three different **categories**: Access, Control, and Activity.

Indicators in the Access category measure four **groups**: Internet adoption, speed & quality, price, and literacy & gender equality. Only indicators in the Access category are used to score countries. This is why the scores and ranking are often referred to as the **Access Index**.

Indicators in the Control category measure three **groups**: Internet control, filtering, and filtering style. How and what a country's government filters is useful to research censorship but not quantitative or verifiable enough to include in the index scores.

Indicators in the Activity category are not currently grouped. They are data the social activity, topics, and interaction of the people in a country or communication in a specific language. These do not affect the Access index but can be used for further research in the social, political, and community aspects of Internet users.

For the full list an explanation of the sources, see: [Internet Monitor Access Index](https://thenetmonitor.org/sources/platform-data).

You can access the current list of datum_sources by using the /datum_sources endpoint.

    GET https://thenetmonitor.org/datum_sources HTTP/1.1
    Accept: application/vnd.api+json

The result is an array of datum_sources currently in the index as well as related category and group information.

    {
      "data": [
        {
          "type": "datum_sources",
          "id": "7",
          "attributes": {
            "admin_name": "wisr",
            "public_name": "Wired Internet subscription rate",
            "short_name": "Wired rate",
            "description": "Also listed as \"Fixed (wired) Internet subscriptions per 100 inhabitants\"; measures both the number of active fixed (wired) Internet subscriptions at speeds less than 256 kbps (kilobits per second), such as dial-up and other fixed non-broadband subscriptions, and total fixed (wired) broadband subscriptions.",
            "min": 0.0065407023,
            "max": 42.6118409977,
            "default_weight": 1,
            "affects_score": true,
            "source_name": "ITU",
            "source_link": "http://www.itu.int",
            "display_class": "people",
            "display_prefix": null,
            "display_suffix": "%",
            "precision": 0
          },
          "relationships": {
            "category": {
              "data": { "type": "categories", "id": "1" }
            },
            "group": {
              "data": { "type": "groups", "id": "1" }
            }
          }
        }
      ],
      "included": [
        {
          "type": "categories",
          "id": "1",
          "attributes": {
            "name": "Access",
            "slug": "access"
          }
        },
        {
          "type": "groups",
          "id": "1",
          "attributes": {
            "admin_name": "adoption",
            "public_name": "Adoption",
            "default_weight": 1
          }
        }
      ]
    }



