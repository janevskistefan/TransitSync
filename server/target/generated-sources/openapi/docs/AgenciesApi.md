# AgenciesApi

All URIs are relative to *https://api.transit-example.com/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**getAgencies**](AgenciesApi.md#getAgencies) | **GET** /agencies | List all transit agencies |


<a id="getAgencies"></a>
# **getAgencies**
> List&lt;Agency&gt; getAgencies()

List all transit agencies

Returns a list of all transit agencies available in the feed.

### Example
```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AgenciesApi;

public class Example {
  public static void main(String[] args) {
    ApiClient defaultClient = Configuration.getDefaultApiClient();
    defaultClient.setBasePath("https://api.transit-example.com/v1");

    AgenciesApi apiInstance = new AgenciesApi(defaultClient);
    try {
      List<Agency> result = apiInstance.getAgencies();
      System.out.println(result);
    } catch (ApiException e) {
      System.err.println("Exception when calling AgenciesApi#getAgencies");
      System.err.println("Status code: " + e.getCode());
      System.err.println("Reason: " + e.getResponseBody());
      System.err.println("Response headers: " + e.getResponseHeaders());
      e.printStackTrace();
    }
  }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;Agency&gt;**](Agency.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | A list of agencies. |  -  |

