@newport
@newport.machine.metric
@ECO-18772

Feature:

  (ECO-18772) As an HME user
  I want to access to service information about my patients' device
  so that I am informed of when it may require servicing or replacement.

# ACCEPTANCE CRITERIA: (ECO-18772)
# Note 1: This story applies to devices with a subscription relating to Machine Metrics/Service Information (currently supported devices are Astral 100 (VID 9) and Astral 150 devices(VID 10)).
# Note 1: Machine Metric specification (HTTP method, URI, etc) can be found at https://confluence.ec2.local/display/NGCS/17+00+Machine+Metric
# Note 2: Implementation notes are provided to capture and consolidate the current NGCS machine data workflow patterns
# 1. The server shall receive machine metrics from machines
# 1a. The server shall authenticate the request using Type 2 Authentication protocol
# Note 3: Message authentication specification can be found at https://confluence.ec2.local/display/NGCS/00+05+Authentication. This has been implemented as various interceptors and should simply be configuration of a new CXF bean.
# 1b. The server shall redirect an authenticated request if necessary
# Note 4: Redirect specification can be found at https://confluence.ec2.local/display/NGCS/15+00+Redirect. This has been implemented as an interceptor and should simply be configuration of the new CXF bean.
# 1c. The server shall authorize acceptance of an authenticated request using the Authorization protocol
# Note 5: Message authorization specification can be found at https://confluence.ec2.local/display/NGCS/01+01+Authorization. This has been implemented as an interceptor and should simply be configuration of the new CXF bean.
# Note 6: The endpoint needs to add NGCS standard Camel headers when passing the accepted message and notify the system that a machine has delivered a message. This has been implemented as a Camel route and should simply be the calling of "direct-vm:prepareDeviceDataReception". Additionally, the response needs to have all HTTP headers removed - this should be done by simply calling the existing "direct-vm:prepareNewportResponse" Camel route.
# 1d. The server shall return a HTTP response code of 202 (Accepted) for accepted (authenticated and authorized) machine metrics messages
# Note 7: Accepted machine metrics messages should be placed on a "to be validated" JMS queue (MachineMetricValidation).
# 2. When an accepted machine metrics message does not pass validation, the server shall reject the message
# Note 8: Standard validation (see https://confluence.ec2.local/display/NGCS/Machine+Data+Validation for overview) should be incorporated by using the "direct-vm:validateIdentityAndSubscription" Camel route and checking for a ValidationVetoPoint value (not null) from the calling Camel route. Field validation is described in the machine metrics specification at https://confluence.ec2.local/display/NGCS/17+00+Machine+Metric and should use the existing NGCS JSON Schema based validation library.
# Note 9: Rejected messages should be "logged" to a JMS queue (InvalidMachineMetricsInformation) with sufficient JMS headers (i.e. ValidationVetoPoint, ValidationFailureType, etc.) for validation failure identification
# 3. The server shall store a machine metrics received event for valid machine metrics messages in HI Cloud.
# 4. As per ECO-13276 a Suspended Cellular Module shall be updated to Activated when a Machine Metrics message is received.
# Note 10: The subscription template is as follows:
# Note 2: POSTED JSON will look like the following
# {
# 	"FG.SerialNo": "20142427340",
# 	"SubscriptionId": "1BDDA233-7114-13D1-ABEE-ABB1861234C2",
# 	"CollectTime": "20180628 133448",
# 	"Date": "20180627",
# 	"Val.NextServiceDate": "20200828",
# 	"Val.FullChargeCapacity": 54000,
# 	"Val.FullChargeCapacityThresh": 5280,
#  	"Val.ChargeCycleCount": 5,
#   	"Val.ChargeCycleCountThresh": 400,
# 	"Val.UtcOffset": -120
# }

  Background:
      Given the server receives the following manufacturing unit detail
         | resource                                                                               |
         | /data/manufacture/unit/detail/build_new/geneva/flowgenerator/12345678901.xml           |
         | /data/manufacture/unit/detail/build_new/geneva/cellularmodule/external/20170315895.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 12345678901               | 20170315895                     |
      And I am a device with the FlowGen serial number "12345678901"
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                               |
         | 131fac75-6bc8-3685-a140-a0491059d99c | /data/manufacture/unit/detail/build_new/geneva/cellularmodule/external/20170315895.xml |
      When I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                                      |
         | 131fac75-6bc8-3685-a140-a0491059d99c | /data/unit/geneva/registration/flowgenerator/12345678901_20170315895.json |
      And I do receive a server ok response
      And the response is signed by Authorization header based on its content with the following details
         | cellularModuleGuid                   |
         | 131fac75-6bc8-3685-a140-a0491059d99c |
      And the server should get the following device configuration change
         | json                                                                                                                                                      |
         | { "serialNo": "12345678901", "mid": 30, "vid": 9, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false } |
      # Setting up subscriptions
      And the newport management queue received the following "SUBSCRIPTION" messages
         | { "FG.SerialNo": "12345678901", "SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2", "ServicePoint": "/api/v1/machines/metrics", "Trigger": {"Collect": ["HALO", "ONDEMAND"], "Programs": [], "Conditional": {}, "OnlyOnChange": false}, "Schedule": {}, "Data": ["Val.NextServiceDate", "Val.FullChargeCapacity", "Val.FullChargeCapacityThresh", "Val.ChargeCycleCount", "Val.ChargeCycleCountThresh", "Val.UtcOffset"]}|

  @newport.machine.metric.S1
  @ECO-18772.1a @ECO-18772.1c @ECO-18772.1d @ECO-18772.3
  Scenario: Received machine metrics from different (session) dates, or same date but with different collect time for an existing subscription.
    # First post received from device
    When the cellular module updates authentication context
    And the machine sends the following machine metric with type 2 authentication
      | json                                                                                                                                                                                                                                                                                                                                 |
      | {"FG.SerialNo": "12345678901","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "2 days ago 010203","Date": "2  day ago","Val.UtcOffset": -120, "Val.NextServiceDate":"20200828","Val.FullChargeCapacity":54000,"Val.FullChargeCapacityThresh":5280,"Val.ChargeCycleCount":5,"Val.ChargeCycleCountThresh":400} |
    Then I should receive a server Accepted response
    And the following device data received events have been published
      | JMSType        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                 |
      | MACHINE_METRIC | 12345678901 | DEVICE           | 12345678901               | 30                       |  9                      | {"FG.SerialNo": "12345678901","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "2 days ago 010203","Date": "2  day ago","Val.UtcOffset": -120, "Val.NextServiceDate":"20200828","Val.FullChargeCapacity":54000,"Val.FullChargeCapacityThresh":5280,"Val.ChargeCycleCount":5,"Val.ChargeCycleCountThresh":400} |
    # Another post from same device in a different day
    When the cellular module updates authentication context
    And the machine sends the following machine metric with type 2 authentication
      | json                                                                                                                                                                                                                                                                                                                                  |
      | {"FG.SerialNo": "12345678901","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today      010101","Date": "1  day ago","Val.UtcOffset": -120, "Val.NextServiceDate":"20200828","Val.FullChargeCapacity":54000,"Val.FullChargeCapacityThresh":5280,"Val.ChargeCycleCount":15,"Val.ChargeCycleCountThresh":400} |
    Then I should receive a server Accepted response
    And the following device data received events have been published
      | JMSType        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                  |
      | MACHINE_METRIC | 12345678901 | DEVICE           | 12345678901               | 30                       |  9                      | {"FG.SerialNo": "12345678901","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today      010101","Date": "1  day ago","Val.UtcOffset": -120, "Val.NextServiceDate":"20200828","Val.FullChargeCapacity":54000,"Val.FullChargeCapacityThresh":5280,"Val.ChargeCycleCount":15,"Val.ChargeCycleCountThresh":400} |
    # Yet another post in same session date but with different collect time
    When the cellular module updates authentication context
    And the machine sends the following machine metric with type 2 authentication
      | json                                                                                                                                                                                                                                                                                                                                  |
      | {"FG.SerialNo": "12345678901","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today      010130","Date": "1  day ago","Val.UtcOffset": -120, "Val.NextServiceDate":"20200828","Val.FullChargeCapacity":54000,"Val.FullChargeCapacityThresh":5280,"Val.ChargeCycleCount":20,"Val.ChargeCycleCountThresh":400} |
    Then I should receive a server Accepted response
    And the following device data received events have been published
      | JMSType        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                  |
      | MACHINE_METRIC | 12345678901 | DEVICE           | 12345678901               | 30                       | 9                       | {"FG.SerialNo": "12345678901","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today      010130","Date": "1  day ago","Val.UtcOffset": -120, "Val.NextServiceDate":"20200828","Val.FullChargeCapacity":54000,"Val.FullChargeCapacityThresh":5280,"Val.ChargeCycleCount":20,"Val.ChargeCycleCountThresh":400} |
    And the following machine metrics are stored in the cloud
      | json                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "12345678901", "SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "2 days ago 010203","Date": "2 days ago","Val.UtcOffset": -120, "Val.NextServiceDate":"20200828","Val.FullChargeCapacity":54000,"Val.FullChargeCapacityThresh":5280,"Val.ChargeCycleCount":5,"Val.ChargeCycleCountThresh":400} |
      | { "FG.SerialNo": "12345678901", "SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2", "Date": "1  day ago", "CollectTime": "today 010101", "Val.UtcOffset": -120, "Val.NextServiceDate":"20200828","Val.FullChargeCapacity":54000,"Val.FullChargeCapacityThresh":5280,"Val.ChargeCycleCount":15,"Val.ChargeCycleCountThresh":400}  |
      | { "FG.SerialNo": "12345678901", "SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2", "Date": "1  day ago", "CollectTime": "today 010130", "Val.UtcOffset": -120, "Val.NextServiceDate":"20200828","Val.FullChargeCapacity":54000,"Val.FullChargeCapacityThresh":5280,"Val.ChargeCycleCount":20,"Val.ChargeCycleCountThresh":400}  |

  @newport.machine.metric.S2
  @ECO-18772.1b
  Scenario: Redirect from a machine data post
    Given Fleet manager sends the following redirect descriptors to be persisted
      | cellularModuleGuid                   | jsonFile                                                                   | responseCode |
      | 131fac75-6bc8-3685-a140-a0491059d99c | /data/management/redirect/cellularmodule/redirect_descriptor_create_2.json | 201          |
    When the cellular module updates authentication context
    And the machine sends the following machine metric with type 2 authentication
      | json                                                                                                                                                                                                                                                                                                                                 |
      | {"FG.SerialNo": "12345678901","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "2 days ago 010203","Date": "2  day ago","Val.UtcOffset": -120, "Val.NextServiceDate":"20200828","Val.FullChargeCapacity":54000,"Val.FullChargeCapacityThresh":5280,"Val.ChargeCycleCount":5,"Val.ChargeCycleCountThresh":400} |
    Then I should receive a server Permanent Redirect response
    And the response is signed by Authorization header based on its content with the following details
      | cellularModuleGuid                   |
      | 131fac75-6bc8-3685-a140-a0491059d99c |
    And I should receive the following message in the response body
      | jsonFile                                                          |
      | /data/management/redirect/cellularmodule/redirect_response_2.json |
    And I should receive the following HTTP Headers
      | Key              | Value                                                 |
      | Content-Type     | application/json;charset=UTF-8                        |
      | Location         | http://newport-amr.resmed.com/api/v1/machines/metrics |

  @newport.machine.metric.S3
  @ECO-18772.2
  Scenario: Received machine metric that failed to meet validation requirements
    When the cellular module updates authentication context
    And the machine sends the following machine metric with type 2 authentication
      | json                                                                                                                                                                                                                                                                                                                           |
      | {"FG.SerialNo": "12345678901","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today 010101","Date": "1  day ago","Val.UtcOffset": -120, "Val.NextServiceDate":"INVALID","Val.FullChargeCapacity":54000,"Val.FullChargeCapacityThresh":5280,"Val.ChargeCycleCount":5,"Val.ChargeCycleCountThresh":400} |
    Then I should receive a server Accepted response
    And no device data received events have been published
    And the server sends the message to invalid machine metric queue
      | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason                                                                                                                                                                                                                                                                                                                                                                |
      | FIELD_VALIDATION    | MACHINE_METRIC_FIELD  | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/definitions.json#","pointer":"/definitions/dateValue"},"instance":{"pointer":"/Val.NextServiceDate"},"domain":"validation","keyword":"pattern","message":"regex does not match input string","regex":"^[12][0-9]{3}(0[1-9]\|1[012])(0[1-9]\|[12][0-9]\|3[01])$","string":"INVALID"} ] } |
    And no machine metrics are stored in the cloud for serial number "12345678901"
    When the cellular module updates authentication context
    And the machine sends the following machine metric with type 2 authentication
      | json                                                                                                                                                                                                                                                                                                                         |
      | {"FG.SerialNo": "12345678901","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today 010101","Date": "1  day ago","Val.UtcOffset": -120, "Val.NextServiceDate":"20181212","Val.FullChargeCapacity":-5,"Val.FullChargeCapacityThresh":5280,"Val.ChargeCycleCount":5,"Val.ChargeCycleCountThresh":400} |
    Then I should receive a server Accepted response
    And no device data received events have been published
    And the server sends the message to invalid machine metric queue
      | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason                                                                                                                                                                                                                                                                                                                       |
      | FIELD_VALIDATION    | MACHINE_METRIC_FIELD  | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/definitions.json#","pointer":"/definitions/chargeCapacityNumber"},"instance":{"pointer":"/Val.FullChargeCapacity"},"domain":"validation","keyword":"minimum","message":"number is lower than the required minimum","minimum":0,"found":-5} ] } |
    And no machine metrics are stored in the cloud for serial number "12345678901"

  @newport.machine.metric.S4
  @ECO-18722.4
  Scenario: Machine metric from a suspended device should change status to active
    Given the communication module with serial number "20170315895" has suspended status for 1 days
    When the cellular module updates authentication context
    And the machine sends the following machine metric with type 2 authentication
      | json                                                                                                                                                                                                                                                                                                                            |
      | {"FG.SerialNo": "12345678901","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today 010101","Date": "1  day ago","Val.UtcOffset": -120, "Val.NextServiceDate":"20200828","Val.FullChargeCapacity":54000,"Val.FullChargeCapacityThresh":5280,"Val.ChargeCycleCount":5,"Val.ChargeCycleCountThresh":400} |
    Then the communication module with serial number "20170315895" should eventually have a status of "ACTIVE" within 5 seconds
