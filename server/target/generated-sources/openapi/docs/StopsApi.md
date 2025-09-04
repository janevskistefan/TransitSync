# StopsApi

All URIs are relative to *https://api.transit-example.com/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**getStopDepartures**](StopsApi.md#getStopDepartures) | **GET** /stops/{stopId}/departures | Get upcoming departures for a stop |
| [**getStops**](StopsApi.md#getStops) | **GET** /stops | Find transit stops near a location |


<a id="getStopDepartures"></a>
# **getStopDepartures**
> List&lt;StopDeparture&gt; getStopDepartures(stopId)

Get upcoming departures for a stop

Returns a list of upcoming departures for a specific stop, including route and trip information.

### Example
```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.models.*;
import org.openapitools.client.api.StopsApi;

public class Example {
  public static void main(String[] args) {
    ApiClient defaultClient = Configuration.getDefaultApiClient();
    defaultClient.setBasePath("https://api.transit-example.com/v1");

    StopsApi apiInstance = new StopsApi(defaultClient);
    String stopId = "STP_GTC_1"; // String | The unique ID of the stop.
    try {
      List<StopDeparture> result = apiInstance.getStopDepartures(stopId);
      System.out.println(result);
    } catch (ApiException e) {
      System.err.println("Exception when calling StopsApi#getStopDepartures");
      System.err.println("Status code: " + e.getCode());
      System.err.println("Reason: " + e.getResponseBody());
      System.err.println("Response headers: " + e.getResponseHeaders());
      e.printStackTrace();
    }
  }
}
```

### Parameters

| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **stopId** | **String**| The unique ID of the stop. | |

### Return type

[**List&lt;StopDeparture&gt;**](StopDeparture.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | A list of upcoming scheduled departures. |  -  |
| **404** | Stop not found. |  -  |

<a id="getStops"></a>
# **getStops**
> List&lt;Stop&gt; getStops(lat, lon, radius)

Find transit stops near a location

Returns a list of stops within a specified radius of a geographic point.

### Example
```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.models.*;
import org.openapitools.client.api.StopsApi;

public class Example {
  public static void main(String[] args) {
    ApiClient defaultClient = Configuration.getDefaultApiClient();
    defaultClient.setBasePath("https://api.transit-example.com/v1");

    StopsApi apiInstance = new StopsApi(defaultClient);
    Double lat = 42.0012D; // Double | Latitude of the search center.
    Double lon = 21.4325D; // Double | Longitude of the search center.
    Integer radius = 500; // Integer | Search radius in meters.
    try {
      List<Stop> result = apiInstance.getStops(lat, lon, radius);
      System.out.println(result);
    } catch (ApiException e) {
      System.err.println("Exception when calling StopsApi#getStops");
      System.err.println("Status code: " + e.getCode());
      System.err.println("Reason: " + e.getResponseBody());
      System.err.println("Response headers: " + e.getResponseHeaders());
      e.printStackTrace();
    }
  }
}
```

### Parameters

| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **lat** | **Double**| Latitude of the search center. | |
| **lon** | **Double**| Longitude of the search center. | |
| **radius** | **Integer**| Search radius in meters. | [optional] [default to 500] |

### Return type

[**List&lt;Stop&gt;**](Stop.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | A list of nearby stops. |  -  |
| **400** | Invalid coordinates provided. |  -  |

