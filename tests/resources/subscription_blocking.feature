@subscription.blocking
@ECO-12457

Feature:
  (ECO-12457) As a clinical user
  I want to be able to cancel subscriptions
  so that I can make changes to a patient's schedule.

# ACCEPTANCE CRITERIA: (ECO-12457)
#  Note 1: This story extends ECO-10358 to allow data from a specified subscription to be blocked.
#  1. When a request to block a subscription is received, the request broker shall no longer accept data from the specified subscription UUID.
#  2. When a request to block a subscription is received, the subscription shall be cancelled as per ECO-5171.
#  Note 2: This creates a new PUT endpoint at /v1/newport/management/subscriptions/{subscriptionId} to allow for blocking of a specific subscription.
#  Note 3: Bulk blocking of subscription is not required
#  Note 4: Subsequent blocking requests may return a 2xx success response if the requested subscription uuid(s) are already blocked

  Background:
    Given the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_fg1000.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_cam10000000001_bdg22151763351.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the communication module "10000000001" uses mock Telco
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000001                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    And these devices have the following therapy summaries
      | json                                                                                                                                                                                                                               |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ]} |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "Date": "2 days ago", "CollectTime": "1 days ago 102252", "Val.Mode": "CPAP", "Val.Duration": 615, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1215 ]} |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "Date": "1  day ago", "CollectTime": "today      010101", "Val.Mode": "CPAP", "Val.Duration": 590, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1190 ]} |
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G10001"},
      "Subscriptions": []
    }
    """
    Then the server should get the following device configuration change
      | json                                                                                                                                                      |
      | { "serialNo": "10000000003", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false} |
    When the following update requests are queued for delivery to the device
      | requestType        | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | SUBSCRIPTION_BATCH | { "FG.SerialNo": "10000000003", "Subscriptions": [ "{ \"FG.SerialNo\": \"10000000003\", \"SubscriptionId\": \"UUID-2\", \"ServicePoint\": \"/api/v1/therapy/summaries\", \"Trigger\": { \"Collect\": [ \"HALO\" ], \"Conditional\": { \"Setting\": \"Val.Mode\", \"Value\": \"CPAP\" }, \"OnlyOnChange\": false }, \"Schedule\": { \"StartDate\": null, \"EndDate\": null }, \"Data\": [ \"Val.Mode\", \"Val.Duration\", \"Val.MaskOn\", \"Val.MaskOff\"] }"] } |
    And the server eventually has a CALL_HOME SMS retry for flow generator 10000000003 within 5 seconds
    When by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 7 seconds
      | URI Fixed Part          | Content Identifier  |
      | /api/v1/subscriptions/  | UUID-2              |
      | /api/v1/configurations/ | <ANY_UUID>          |
    And I acknowledge all brokered messages

  @subscription.blocking.S1
  @ECO-12457.2
  Scenario: Management API for block and/or cancel REST endpoint is hit
    When the following subscription update is requested on management api
      | subscriptionId | requestBody      |
      | UUID-2         | {"Block": true } |
    Then the server returns 200 status with following response body
      """
      {
      "id":"UUID-2",
      "json":"{ \"FG.SerialNo\": \"10000000003\", \"SubscriptionId\": \"UUID-2\", \"ServicePoint\": \"/api/v1/therapy/summaries\", \"Trigger\": { \"Collect\": [ \"HALO\" ], \"Conditional\": { \"Setting\": \"Val.Mode\", \"Value\": \"CPAP\" }, \"OnlyOnChange\": false }, \"Schedule\": { \"StartDate\": null, \"EndDate\": null }, \"Data\": [ \"Val.Mode\", \"Val.Duration\", \"Val.MaskOn\", \"Val.MaskOff\"] }",
      "cancel":"true",
      "block":"true"
      }
      """
    And the server eventually has a CALL_HOME SMS retry for flow generator 10000000003 within 5 seconds
    When by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 10 seconds
      | URI Fixed Part         | Content Identifier |
      | /api/v1/subscriptions/ | UUID-2             |
    Then I should receive the following broker requests
      | json                                                                        |
      | {"FG.SerialNo":"10000000003","Broker":["/api/v1/subscriptions/<ANY_UUID>"]} |
    When I request the subscription with identifier "UUID-2"
    Then I should receive the following subscription
      | json                                                                         |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "Cancel": true } |
    When the following subscription update is requested on management api
      | subscriptionId | requestBody      |
      | NOT_FOUND_UUID | {"Block": true } |
    Then the server returns 404 status with empty response body
    # A repeating request, which succeeded last time
    When the following subscription update is requested on management api
      | subscriptionId | requestBody      |
      | UUID-2         | {"Block": true } |
    Then the server returns 200 status with following response body
      """
      {
      "id":"UUID-2",
      "json":"{ \"FG.SerialNo\": \"10000000003\", \"SubscriptionId\": \"UUID-2\", \"ServicePoint\": \"/api/v1/therapy/summaries\", \"Trigger\": { \"Collect\": [ \"HALO\" ], \"Conditional\": { \"Setting\": \"Val.Mode\", \"Value\": \"CPAP\" }, \"OnlyOnChange\": false }, \"Schedule\": { \"StartDate\": null, \"EndDate\": null }, \"Data\": [ \"Val.Mode\", \"Val.Duration\", \"Val.MaskOn\", \"Val.MaskOff\"] }",
      "cancel":"true",
      "block":"true"
      }
      """
    # A repeated request, which failed last time
    When the following subscription update is requested on management api
      | subscriptionId | requestBody      |
      | NOT_FOUND_UUID | {"Block": true } |
    Then the server returns 404 status with empty response body

  @subscription.blocking.S2
  @ECO-12457.1
  Scenario: Arrival of device data, which belongs to a blocked subscription
    When the following subscription update is requested on management api
      | subscriptionId | requestBody      |
      | UUID-2         | {"Block": true } |
    Then the server returns 200 status with following response body
      """
      {
      "id":"UUID-2",
      "json":"{ \"FG.SerialNo\": \"10000000003\", \"SubscriptionId\": \"UUID-2\", \"ServicePoint\": \"/api/v1/therapy/summaries\", \"Trigger\": { \"Collect\": [ \"HALO\" ], \"Conditional\": { \"Setting\": \"Val.Mode\", \"Value\": \"CPAP\" }, \"OnlyOnChange\": false }, \"Schedule\": { \"StartDate\": null, \"EndDate\": null }, \"Data\": [ \"Val.Mode\", \"Val.Duration\", \"Val.MaskOn\", \"Val.MaskOff\"] }",
      "cancel":"true",
      "block":"true"
      }
      """
    When I send the therapy summaries from 3 days ago
    Then I should receive a server ok response
    And no device data received events have been published
    And no therapy summaries are stored in the cloud for serial number "10000000003"

  @subscription.blocking.S3
  @ECO-12457.1
  Scenario: Arrival of device data, which belongs to a cancelled (but not blocked) subscription
    When the following subscription update is requested on management api
      | subscriptionId | requestBody       |
      | UUID-2         | {"Cancel": true } |
    Then the server returns 200 status with following response body
      """
      {
      "id":"UUID-2",
      "json":"{ \"FG.SerialNo\": \"10000000003\", \"SubscriptionId\": \"UUID-2\", \"ServicePoint\": \"/api/v1/therapy/summaries\", \"Trigger\": { \"Collect\": [ \"HALO\" ], \"Conditional\": { \"Setting\": \"Val.Mode\", \"Value\": \"CPAP\" }, \"OnlyOnChange\": false }, \"Schedule\": { \"StartDate\": null, \"EndDate\": null }, \"Data\": [ \"Val.Mode\", \"Val.Duration\", \"Val.MaskOn\", \"Val.MaskOff\"] }",
      "cancel":"true",
      "block":"false"
      }
      """
    When I send the therapy summaries from 3 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                               |
      | THERAPY_SUMMARY | 10000000003 | DEVICE           | 10000000003               | 36                       | 33                      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ]} |
    And the following therapy summaries are stored in the cloud
      | json                                                                                                                                                                                                                               |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ]} |

  @subscription.blocking.S4
  @ECO-12457.2
  Scenario: Management API for block and/or cancel REST endpoint is hit with bad requests
    # Valid JSON structure but it has bad semantic
    When the following subscription update is requested on management api
      | subscriptionId | requestBody              |
      | UUID-2         | {"Block": false }        |
    Then the server returns 400 status with empty response body
    When the following subscription update is requested on management api
      | subscriptionId | requestBody              |
      | UUID-2         | {"Block": true }         |
    Then I should receive a server ok response
    # Valid JSON structure but it has bad semantic
    When the following subscription update is requested on management api
      | subscriptionId | requestBody                        |
      | UUID-2         | {"Block": false, "Cancel": false } |
    Then the server returns 400 status with empty response body
    When the following subscription update is requested on management api
      | subscriptionId | requestBody              |
      | UUID-2         | {"Block": true }         |
    Then I should receive a server ok response
    # Valid JSON structure but it has bad semantic
    When the following subscription update is requested on management api
      | subscriptionId | requestBody              |
      | UUID-2         | {}                       |
    Then the server returns 400 status with empty response body
    When the following subscription update is requested on management api
      | subscriptionId | requestBody              |
      | UUID-2         | {"Block": true }         |
    Then I should receive a server ok response
    # Malformed JSON
    When the following subscription update is requested on management api
      | subscriptionId | requestBody              |
      | UUID-2         | {"Block": false          |
    Then the server returns 400 status with empty response body