@cam
@newport
@newport.broker
@newport.broker.external.cam
@ECO-9855
@ECO-10207

Feature:
  (ECO-9855) As a clinical user
  I want ECO to deliver requests to external CAMs when needed
  so that I can update software remotely in the field.

  (ECO-10207) As an Applications Support user
  I want to be able to upgrade a list of external CAMs
  so that upgrades can be made in the field if necessary

# ACCEPTANCE CRITERIA: (ECO-9855)
# 1. The server shall provide a request broker for external CAMs (aka CAMBridge), to collect requests. Note: URL is to be
#    /api/v1/requests/cams/{cam serial number}.
#    *Note1:* The external CAM will call this interface following a CAM Rego, or in response to an SMS.
# 2. The request broker shall return the list of queued requests (FIFO) to the external CAM that are relevant to the external CAM.
# 3. If the external CAM has never registered then an error (HTTP424) shall be returned to the external CAM when it queries the request broker.
# 4. The request broker shall return an error (HTTP412) if a GET request is received from an unknown CAMBridge.

# Note 2: The Protocol detailed at: http://confluence.corp.resmed.org/display/CA/Requests is the basis for this mechanism, but rather than "FG.SerialNo", "CAM.SerialNo" will be returned, and Newport Device should be replaced with CAMBridge device.
# Note 3: The messages delivered to the broker are assumed to be correct. This card will not validate the content.
# Note 4: This card relates to ECO-9423 and ECO-9961. This queue is expected to only contain CAM specific requests, for example, software updates.
# Note 5: Expect that the SMS will continue to work for the case where requests are queued for FG or FG with CAM. A subsequent card will cover SMS for CAM specific requests.

# ACCEPTANCE CRITERIA: (ECO-10207)
#  Note 1: This card will open up a test case for ECO-9855, where was not able to seed a brokered message, specific for CAM, following a production work flow.
#
#  1. An Applications Support user shall be able to specify a list of external CAMs to upgrade.
#  2. The list of devices to upgrade shall be able to be specified using a csv file. *Note:* It is acceptable for the csv file to be consumed by the same end point as created for ECO-4964, and NGCS can differentiate by the information provided. Ie - if device type is an external CAM or bridge, then expect to receive External CAM serial number. Otherwise, then flowGenSerialNo is required.
#  3. For each device to be upgraded the following shall be specifiable:
#  3a. External CAM serial number;
#  3b. Whether to upgrade the CAM or the Bridge;
#  3c. The file to be used to upgrade the device including the host, port and file path; and
#  3d. The size and CRC of the upgrade file.
#  4. It shall be possible to specify more than one upgrade of the same external CAM in the list.  Note 1: For example this could be updating the CAM and the bridge, or it could be two successive upgrades of the CAM.
#  5. For each external CAM upgrade in the upgrade list ECO shall create a broker request to go on the external CAM request queue (see ECO-9855) for the upgrade as per http://confluence.corp.resmed.org/display/CA/Requests
#  6. ECO shall notify the external CAM of a pending upgrade request by sending an SMS to the external CAM.
#  7. In cases where there is more than one upgrade of the same external CAM in the list then the order of the broker requests shall correspond to the order of application of the upgrades.
#  8. SMS retry mechanism shall operate as per ECO-5571 for requests that have been added for the external CAM.
#
#  Note 2: This page covers OTA upgrades for Newports https://confluence.ec2.local/display/ECO/Newport+OTA+upgrades and should be appended to cover the above.
#  Note 3: It is perfectly acceptable for the upgrade facilities to be provided using back-end services such as using sql interfaces or via a command line.
#  Note 4: As per ECO-5078, details of the upgrade including software versions of all upgraded device types should be available on request.

Background:
  Given the server bulk load the following devices and modules
    | /data/manufacturing/unit_detail_new_cam10000000001_fg_bdg22151763351.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  Given the server bulk load the following devices and modules
    | /data/manufacturing/unit_detail_001_10000000003_new_camless.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the communication module "10000000001" uses mock Telco

@newport.broker.external.cam.S1
@ECO-9855.1 @ECO-9855.2
Scenario: Queued requests should be sent to external CAM. New queued requests will trigger a SMS to be sent to the external CAM.
  Given I am an external CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
  And I send the following external cam registration
    | json                                                                                                                                                                                                        |
    | {"Bridge" :{"Software": "SI584-0200-3","MID": 40,"VID": 46,"ProductCode": "28317","PCBASerialNo":"22151763351"}, "CAM" :{"SerialNo": "10000000001","Software": "SX588-0101","PCBASerialNo":"13152G00001"}}  |
  When I request my broker requests for external CAM
  Then I should receive the following broker requests for external CAM
    | json                                             |
    | { "CAM.SerialNo": "10000000001", "Broker": [] }  |
  When the server is given the following configurations to be sent to devices
    | json                                                                                                                                                                                                                                                              |
    | { "FG.SerialNo": "10000000003", "CAM.SerialNo": "10000000001", "ConfigurationId": "962cc963-43d8-44f9-a283-b114a184b4", "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/", "REGO-URI": "/v1/registrations/" }  |
  And the server has the following upgrades to be sent to devices
    | json                                                                                                                                                                                                                                            |
    | { "FG.SerialNo": "10000000003", "CAM.SerialNo": "10000000001", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "CAM",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" }  |
    | { "FG.SerialNo": "10000000003", "CAM.SerialNo": "10000000001", "UpgradeId": "80302685-93BA-494F-AFFD-B27AEC759635", "Type": "CAM",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin", "Size": 9876, "CRC": "C7D2" }   |
  And the server has the following subscriptions to be sent to devices
    | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
    | { "FG.SerialNo": "10000000003", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] }  |
    | { "FG.SerialNo": "10000000003", "SubscriptionId": "7E293B00-9396-48A8-945E-A61712BAD67E", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "OnlyOnChange": true }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                             |
  When I request my broker requests for external CAM
  Then I should receive the following broker requests for external CAM
    | json                                             |
    | { "CAM.SerialNo": "10000000001", "Broker": [] }  |

@newport.broker.external.cam.S2
@ECO-9855.3 @ECO-9855.4
Scenario: Error code 412 and 424 should be returned for requests from unknown CAM and unregistered CAM, respectively.
  Given the server is given the following configurations to be sent to devices
    | json                                                                                                                                                                                                                                                              |
    | { "FG.SerialNo": "10000000003", "CAM.SerialNo": "10000000001", "ConfigurationId": "962cc963-43d8-44f9-a283-b114a184b4", "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/", "REGO-URI": "/v1/registrations/" }  |
  And the server has the following upgrades to be sent to devices
    | json                                                                                                                                                                                                                                            |
    | { "FG.SerialNo": "10000000003", "CAM.SerialNo": "10000000001", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "CAM",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" }  |
    | { "FG.SerialNo": "10000000003", "CAM.SerialNo": "10000000001", "UpgradeId": "80302685-93BA-494F-AFFD-B27AEC759635", "Type": "CAM",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin", "Size": 9876, "CRC": "C7D2" }   |
  # CommModule is unknown
  When I am an external CAM with serial number "88810000003" with authentication key "somekey"
  And I make a random broker requests with flow generator serial "" and communication module serial "88810000003" and authentication key "somekey"
  Then I should receive a response code of "412"
  # CommModule is known, but not registered with a Bridge
  When I am an external CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
  And I make a random broker requests with flow generator serial "" and communication module serial "10000000001" and authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
  Then I should receive a response code of "424"

@newport.broker.external.cam.S3
@ECO-9855.1 @ECO-9855.2
Scenario: No queued requests should be sent to internal CAM, the server should log an error to invalid broker request queue.
  Given the server bulk load the following devices and modules
    | /data/manufacturing/unit_detail_001_10000000007_new.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the communication module "10000000007" uses mock Telco
  And the following units are cached for local use
    | flowGeneratorSerialNumber | communicationModuleSerialNumber |
    | 10000000007               | 10000000007                     |
  And I am a device with the FlowGen serial number "10000000007"
  And I have been connected with CAM with serial number "10000000007" with authentication key "MzYxMDAwMDAwMDAwMTEwMDAwMDAwMDAx"
  And I send the following registration
    | json                                                                                                                                                                                                                                                                                                                                                                                                       |
    | { "FG": {"SerialNo": "10000000007", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo": "(90)R370-7224(91)P3(21)41030008", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "10000000007", "Software": "SX558-0100", "PCBASerialNo": "13152G00017", "Subscriptions": [ "E33FD8C4-EF82-43C2-10000000007" ] }, "Hum": {"Software": "SX556-0100"} } |
  And the server is given the following configurations to be sent to devices
    | json                                                                                                                                                                                                                                                              |
    | { "FG.SerialNo": "10000000007", "CAM.SerialNo": "10000000007", "ConfigurationId": "962cc963-43d8-44f9-a283-b114a184b4", "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/", "REGO-URI": "/v1/registrations/" }  |
  And I am an external CAM with serial number "10000000007" with authentication key "MzYxMDAwMDAwMDAwMTEwMDAwMDAwMDAx"
  When I make a random broker requests with flow generator serial "" and communication module serial "10000000007" and authentication key "MzYxMDAwMDAwMDAwMTEwMDAwMDAwMDAx"
  Then I should not receive broker requests
  And the server should log a broker request error
    | ValidationVetoPoint       | ValidationFailureType | ValidationFailureReason  |
    |                           |                       |                          |

  @contact.device.external.cam.S1
  @newport.broker.external.cam.S4
  @ECO-10207.8 @ECO-9855.2 @ECO-9855.3
  Scenario: NGCS server has requests, which are to be delivered to an external CAM, before this CAM has registered (by itself or with a device
    Given I am an external CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When the server is given the following configurations to be sent to devices
      | json                                                                                                                                                                                                                                                              |
      | {"CAM.SerialNo": "10000000001", "ConfigurationId": "962cc963-43d8-44f9-a283-b114a184b4AB", "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/cams/", "REGO-URI": "/v1/registrations/" }  |
    And the server has the following upgrades to be sent to devices
      | json                                                                                                                                                                                                                                            |
      | {"CAM.SerialNo": "10000000001", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "CAM",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" }  |
      | { "FG.SerialNo": "10000000003", "UpgradeId": "80302685-93BA-494F-AFFD-B27AEC759635", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin", "Size": 9876, "CRC": "C7D2" }   |
    And the server has the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] }  |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "7E293B00-9396-48A8-945E-A61712BAD67E", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "OnlyOnChange": true }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                             |
    # Before registration, no SMS should take place
    Then I should not receive a call home SMS within 5 seconds
    And the server has no SMS retry for communication module 10000000001
    When I request my broker requests for external CAM
    Then I should receive a response code of "424"
    # Registration should enable the device to retrieve  its requests
    When I send the following external cam registration
      | json                                                                                                                                                                                                        |
      | {"Bridge" :{"Software": "SI584-0200-3","MID": 40,"VID": 46,"ProductCode": "28317","PCBASerialNo":"22151763351"}, "CAM" :{"SerialNo": "10000000001","Software": "SX588-0101","PCBASerialNo":"13152G00001"}}  |
    And I request my broker requests for external CAM
    Then I should receive the following broker requests for external CAM
      | json                                                                                                                                                                      |
      | { "CAM.SerialNo": "10000000001", "Broker": ["/api/v1/configurations/962cc963-43d8-44f9-a283-b114a184b4AB", "/api/v1/upgrades/B2AE8F06-1541-4616-AE6F-F9E4C079CC6E"] }     |
    And I should eventually receive a call home SMS within 10 seconds
    And the server has a CALL_HOME SMS retry for communication module 10000000001
    # A new request for the comm module AFTER registration is already done
    When the server is given the following configurations to be sent to devices
      | json                                                                                                                                                                                                                                      |
      | {"CAM.SerialNo": "10000000001", "ConfigurationId": "FFFFFFFF-43d8-44f9-a283-b114a184b4AB", "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/cams/", "REGO-URI": "/v1/registrations/" }  |
    Then I should eventually receive a call home SMS within 10 seconds
    And the server has a CALL_HOME SMS retry for communication module 10000000001
    When I request my broker requests for external CAM
    Then I should receive the following broker requests for external CAM
      | json                                                                                                                                                                                                                              |
      | {"CAM.SerialNo":"10000000001","Broker":["/api/v1/configurations/962cc963-43d8-44f9-a283-b114a184b4AB", "/api/v1/upgrades/B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "/api/v1/configurations/FFFFFFFF-43d8-44f9-a283-b114a184b4AB"]}   |
    Given I acknowledge the upgrade with content identifier "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E"
      | json                                                                                                          |
      | { "CAM.SerialNo": "10000000001", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Status": "Received" }  |
    And I pause for 10 seconds
    When I request my broker requests for external CAM
    Then I should receive the following broker requests for external CAM
      | json                                                                                                                                                                    |
      | {"CAM.SerialNo":"10000000001","Broker":["/api/v1/configurations/962cc963-43d8-44f9-a283-b114a184b4AB", "/api/v1/configurations/FFFFFFFF-43d8-44f9-a283-b114a184b4AB"]}  |
    And the server has a CALL_HOME SMS retry for communication module 10000000001
    Given I acknowledge the configuration with content identifier "962cc963-43d8-44f9-a283-b114a184b4AB"
      | json                                                                                                                |
      | { "CAM.SerialNo": "10000000001", "ConfigurationId": "962cc963-43d8-44f9-a283-b114a184b4AB", "Status": "Received" }  |
    And I acknowledge the configuration with content identifier "FFFFFFFF-43d8-44f9-a283-b114a184b4AB"
      | json                                                                                                                |
      | { "CAM.SerialNo": "10000000001", "ConfigurationId": "FFFFFFFF-43d8-44f9-a283-b114a184b4AB", "Status": "Received" }  |
    And I pause for 5 seconds
    When I request my broker requests for external CAM
    # Empty broker result should be returned after all requests have been acknowledged
    Then I should receive the following broker requests for external CAM
      | json                                        |
      | {"CAM.SerialNo":"10000000001","Broker":[]}  |
    And the server has no SMS retry for communication module 10000000001

  @contact.device.external.cam.S2
  @newport.broker.external.cam.S5
  @ECO-10207.8 @ECO-9855.2
  Scenario: NGCS server has requests, which are to be delivered specifically to external CAM, AFTER it has been registered
    Given I am an external CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    And I send the following external cam registration
      | json                                                                                                                                                                                                        |
      | {"Bridge" :{"Software": "SI584-0200-3","MID": 40,"VID": 46,"ProductCode": "28317","PCBASerialNo":"22151763351"}, "CAM" :{"SerialNo": "10000000001","Software": "SX588-0101","PCBASerialNo":"13152G00001"}}  |
    When the server is given the following configurations to be sent to devices
      | json                                                                                                                                                                                                                                                              |
      | {"CAM.SerialNo": "10000000001", "ConfigurationId": "FFFFFFFF-43d8-44f9-a283-b114a184b4AB", "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/cams/", "REGO-URI": "/v1/registrations/" }  |
    Then I should eventually receive a call home SMS within 10 seconds
    And the server has a CALL_HOME SMS retry for communication module 10000000001
    When I request my broker requests for external CAM
    Then I should receive the following broker requests for external CAM
      | json                                                                                                                                                            |
      | {"CAM.SerialNo":"10000000001","Broker":["/api/v1/configurations/FFFFFFFF-43d8-44f9-a283-b114a184b4AB"]}   |
    Given I acknowledge the configuration with content identifier "FFFFFFFF-43d8-44f9-a283-b114a184b4AB"
      | json                                                                                |
      | { "CAM.SerialNo": "10000000001", "ConfigurationId": "FFFFFFFF-43d8-44f9-a283-b114a184b4AB", "Status": "Received" } |
    And I pause for 5 seconds
    When I request my broker requests for external CAM
    Then I should receive the following broker requests for external CAM
      | json                                                                                                                                                            |
      | {"CAM.SerialNo":"10000000001","Broker":[]}   |
    And the server has no SMS retry for communication module 10000000001

  @newport.broker.external.cam.S6
  @ECO-10207.3a
  Scenario: NGCS server has requests for devices, which are specified with bad serial numbers
    When the server is given the following configurations to be sent to devices
      | json                                                                                                                                                                                                                                     |
      | {"CAM.SerialNo": "12345678901", "ConfigurationId": "962cc963-43d8-44f9-a283-b114a184b4AB", "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/cams/", "REGO-URI": "/v1/registrations/"}  |
    And I pause for 3 seconds
    Then the server should log the following invalid broker request
      | brokeredMessageErrorCode                  | brokeredMessageType  | jsonMessage                                                                                                                                                                                                                             |
      | FLOW_GENERATOR_OR_COMM_MODULE_UNKNOWN     | COMMUNICATION_MODE   | {"CAM.SerialNo": "12345678901", "ConfigurationId": "962cc963-43d8-44f9-a283-b114a184b4AB", "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/cams/", "REGO-URI": "/v1/registrations/"} |
    When the server is given the following upgrades to be sent to devices
      | json                                                                                                                                                                                                           |
      | { "FG.SerialNo": "20070811223", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
    And I pause for 3 seconds
    Then the server should log the following invalid broker request
      | brokeredMessageErrorCode                  | brokeredMessageType  | jsonMessage                                                                                                                                                                                                    |
      | FLOW_GENERATOR_OR_COMM_MODULE_UNKNOWN     | UPGRADE              | { "FG.SerialNo": "20070811223", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |