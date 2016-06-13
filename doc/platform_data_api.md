Internet Monitor Platform Data API
==================================

The Internet Monitor Platform brings public, Internet-related data from many providers together as a single, well-defined Platform Data API.

With this data, anyone can get information on all of the indicators and visualize the data however they wish.

This API (mostly) adheres to the JSON API 1.0 specification: http://jsonapi.org/

Countries & Data Points
=======================

The platform brings together various **indicators** on Internet access and infrastructure to create the Internet Monitor Platform, offering a starting point for further analysis of Internet access conditions in **countries**. In the API, an data point is a value a country has for a given indicator.

You can access country names and all indicator data points by using the /v2/countries endpoint.

    GET https://thenetmonitor.org/v2/countries HTTP/1.1
    Accept: application/vnd.api+json

The result is some country information and related indicator data points.

    {
      "data": [
        {
          "type": "countries",
          "id": "96",
          "attributes": {
            "name": "South Korea",
            "iso_code": "KR",
            "iso3_code": "KOR"
          },
          "links": {
            "self": "https://thenetmonitor.org/countries/96"
          },
          "relationships": {
            "data_points": {
              "data": [
                {
                  "type": "data_points",
                  "id": "10588",
                  "attributes": {
                    "indicator": "wisr",
                    "date": "2015",
                    "value": 32.4173437895
                  }
                },
                {
                  "type": "data_points",
                  "id": "10589",
                  "attributes": {
                    "indicator": "bbcost5",
                    "date": "2015",
                    "value": 49.38427483
                  }
                },
                {
                  "type": "data_points",
                  "id": "10590",
                  "attributes": {
                    "indicator": "pop",
                    "date": "2015",
                    "value": 5300000
                  }
                }
              ]
            }
          }
        }
      ]
    }
    
Each country object has a contry name, country ISO codes, and data points for indicators we have collected for the country.

Each data point object has the indicator short name, a date the data point was captured, and the value that was captured.

Attributes
----------

**indicator**

This is the indicator admin name which matches a value from the indicators endpoint: https://thenetmonitor.org/v2/indicators

An indicator is a metric being provided (e.g., GDP per capita, broadband subscription rate, etc.) by a data provider. See the next section for descriptions of data providers and indicators.

**date**

The date this particular value was captured by a data provider, though, usually only the year.

**value**

The value that was captured by a data provider. Sometimes the value is altered to match a specific unit or format used by the Internet Monitor Platform.

Data Providers, Indicators, Categories, and Groups
==================================================

The Internet Monitor aggregates data from various external organizations we call data providers (e.g., ITU, Google, and Akamai). Each data provider publishes one or more indicators. Internet Monitor uses ETL tools to transform the data from these disparate data providers into a single API defined here. We also give each indicator a category and one or more tags to make it easier to determine which indicators are related across data providers.

Internet Monitor places each indicators into one of three different categories: Access, Control, and Activity.

For the full list an explanation of the sources, see: [Internet Monitor Access Index](https://thenetmonitor.org/sources/platform-data).

You can access the descriptions of all the indicators we track as well as the data providers who publish the data by using the /v2/indicators endpoint.

    GET https://thenetmonitor.org/v2/indicators HTTP/1.1
    Accept: application/vnd.api+json

The result is an array of indicators currently in the Internet Monitor Platform as well as category and group information.

    {
      "data": [
        {
          "type": "indicators",
          "id": "7",
          "attributes": {
            "admin_name": "wisr",
            "name": "Wired Internet subscription rate",
            "short_name": "Wired rate",
            "description": "Also listed as \"Fixed (wired) Internet subscriptions per 100 inhabitants\"; measures both the number of active fixed (wired) Internet subscriptions at speeds less than 256 kbps (kilobits per second), such as dial-up and other fixed non-broadband subscriptions, and total fixed (wired) broadband subscriptions.",
            "provider_data_url": "http://www.itu.int/en/ITU-D/Statistics/Documents/statistics/2015/stat_page_all_charts_2015.xls",
            "unit": "percentage",
            "display_map": null,
            "display_class": "people",
            "precision": 0,
            "tags": "adoption",
            "inverted": false,
            "granularity": "annually"
          },
          "relationships": {
            "provider": {
              "data": { "type": "providers", "id": "1" }
            }
          }
        }
      ],
      "included": [
        {
          "type": "providers",
          "id": "1",
          "attributes": {
            "name": "International Telecommunication Union",
            "short_name": "ITU",
            "url": "http://www.itu.int"
          }
        },
        {
          "type": "units",
          "id": "1",
          "attributes": {
            "name": "percentage",
            "display_prefix": null,
            "display_suffix": "%"
          }
        }
      ]
    }



