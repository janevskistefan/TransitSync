# SchedulesApi

All URIs are relative to *https://api.transit-example.com/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**getStopDepartures**](SchedulesApi.md#getStopDepartures) | **GET** /stops/{stopId}/departures | Get upcoming departures for a stop |


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
import org.openapitools.client.api.SchedulesApi;

public class Example {
  public static void main(String[] args) {
    ApiClient defaultClient = Configuration.getDefaultApiClient();
    defaultClient.setBasePath("https://api.transit-example.com/v1");

    SchedulesApi apiInstance = new SchedulesApi(defaultClient);
    String stopId = "STP_GTC_1"; // String | The unique ID of the stop.
    try {
      List<StopDeparture> result = apiInstance.getStopDepartures(stopId);
      System.out.println(result);
    } catch (ApiException e) {
      System.err.println("Exception when calling SchedulesApi#getStopDepartures");
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

