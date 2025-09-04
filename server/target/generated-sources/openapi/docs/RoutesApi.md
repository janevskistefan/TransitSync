# RoutesApi

All URIs are relative to *https://api.transit-example.com/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**getRoutes**](RoutesApi.md#getRoutes) | **GET** /routes | Find transit routes |


<a id="getRoutes"></a>
# **getRoutes**
> List&lt;Route&gt; getRoutes(agencyId)

Find transit routes

Returns a list of transit routes, optionally filtered by agency.

### Example
```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.models.*;
import org.openapitools.client.api.RoutesApi;

public class Example {
  public static void main(String[] args) {
    ApiClient defaultClient = Configuration.getDefaultApiClient();
    defaultClient.setBasePath("https://api.transit-example.com/v1");

    RoutesApi apiInstance = new RoutesApi(defaultClient);
    String agencyId = "MTA"; // String | The ID of the agency to filter routes by.
    try {
      List<Route> result = apiInstance.getRoutes(agencyId);
      System.out.println(result);
    } catch (ApiException e) {
      System.err.println("Exception when calling RoutesApi#getRoutes");
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
| **agencyId** | **String**| The ID of the agency to filter routes by. | [optional] |

### Return type

[**List&lt;Route&gt;**](Route.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | A list of routes that match the criteria. |  -  |

