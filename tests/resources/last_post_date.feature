@newport
@newport.registration.v2
@last.post.date
@newport.subscriptions.validation
@ECO-9653
@ECO-10358
@ECO-12459

Feature:
  (ECO-9653) As ECO
  I want to provide external CAMs with a last data date
  to ensure I am not unnecessarily sent duplicate data

  (ECO-10358) As ECO
  I want to generate subscriptions for a CAMBridge device customised to its connected flow generator
  so that the device can talk to ECO

  # ACCEPTANCE CRITERIA: (ECO-9653)
  #  1. When the registration of a device with an external CAM occurs the server shall inform the external CAM of the most recent date of summary data received from the device (excluding card download data) via the Request Broker for external CAMs connected to a device (ECO-9423). Note: The date should come from the "Date" field of the most recent summary data post for the therapy device. Example JSON is shown below.
  #    Example:
  #    If AirView has data for the session of the 28 August 2015, then the following will be prepared for the CAM:
  #
  #    {
  #      "FG.SerialNo" : "12345678910",
  #      "ConfigurationID": "<UUID>",
  #      "LastHistoryDate": "2015-08-28T00:00:00"
  #    }
  #
  #  2. For AC#1 above, if the device has never posted data via any external CAM, then the external CAM shall be informed that the most recent date is 1970-01-01T00:00:00.
  #  3. If subscriptions are required to be sent to the external CAM for the device as per ECO-9654 and/or ECO-9843 they shall be sent to the external CAM for the device before sending this date.

  # ACCEPTANCE CRITERIA: (ECO-10358)
  #  1. When an external CAM registers with a device (ie. as per ECO-9421) with a registration message containing existing subscriptions, and there are subscriptions already held in AirView for
  #  that device that do not match then:
  #  1a. The subscriptions held by the CAMBridge for the device shall be cancelled. *Note:* Refer to http://confluence.corp.resmed.org/display/CA/Subscription.
  #  [Obsolete] 1b. The subscriptions for the device held by AirView shall be sent to the CAMBridge through the existing communications protocol. Note: This card will cover getting the subscriptions
  #  onto the request broker. SMS, etc, is handled elsewhere.
  #  2. The subscriptions shall be sent to the external CAM for the device prior to the sending of the Last Post Date, refer to ECO-9653.
  #
  #  *Note1:* If the subscriptions sent by the CAMBridge for the device *do* match, then no subscriptions are required to be sent to the device, and processing can skip to
  #  Last Post being sent to the device as per ECO-9653.
  #  *Note2:* This card invalidates https://jira.ec2.local/browse/ECO-9843. In ECO-9843, subscriptions shall be sent to the device as long as AirView holds subscriptions
  #  for the device. After this new change (optimization) subscriptions are sent from server to device only when they do not match those reported in registration JSON message.

  # ACCEPTANCE CRITERIA: (ECO-12459)
  # Note 1: This story extends ECO-10358 to prevent cancelled subscriptions from being sent to the CAMBridge.
  # 1. The subscriptions for the device held by AirView that are not cancelled and/or not blocked shall be sent to the CAMBridge through the existing
  # communications protocol.  Note: This supersedes -ECO-10358- AC1b where all subscriptions are sent to the CAMBridge.

  Background: Registration of device and external CAM, first time for FG as well as for CAM
    Given the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_cam1000_bdg2215.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    When the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_fg1000.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000001                     |
    And the communication module "10000000001" uses mock Telco
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G00001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
    And the server should get the following device configuration change
      | json                                                                                                                                                       |
      | { "serialNo": "10000000003", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false } |
    And the following update requests are queued for delivery to the device
      | requestType        | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | SUBSCRIPTION_BATCH | { "FG.SerialNo": "10000000003", "Subscriptions": [ "{ \"FG.SerialNo\": \"10000000003\", \"SubscriptionId\": \"1ae07605-ff49-4a04-a1bb-b10c5c1873b9\", \"ServicePoint\": \"/api/v1/erasures\", \"Trigger\": { \"Collect\": [ \"HALO\" ], \"Conditional\": {}, \"OnlyOnChange\": true }, \"Schedule\": { \"StartDate\": null, \"EndDate\": null }, \"Data\": [ \"Val.LastEraseDate\" ] }", "{\"FG.SerialNo\":\"10000000003\",\"SubscriptionId\":\"4f8a3ac8-8731-4fc8-83de-aea46d06c119\",\"ServicePoint\":\"/api/v1/therapy/summaries\",\"Trigger\":{\"Collect\":[\"HALO\"],\"Conditional\":{\"Setting\":\"Val.Mode\",\"Value\":\"CPAP\"}},\"Data\":[\"Val.Mode\",\"Val.Duration\",\"Val.MaskOn\",\"Val.MaskOff\",\"Val.AHI\",\"Val.AI\",\"Val.HI\",\"Val.OAI\",\"Val.CAI\",\"Val.UAI\",\"Val.RIN\",\"Val.CSR\",\"Val.Leak.50\",\"Val.Leak.70\",\"Val.Leak.95\",\"Val.Leak.Max\",\"Val.Humidifier\",\"Val.HeatedTube\",\"Val.AmbHumidity\",\"Val.HTubePow.50\",\"Val.HumPow.50\",\"Val.HumPow.50\",\"Val.PatientHours\",\"Val.BlowPress.5\",\"Val.BlowPress.95\",\"Val.Flow.5\",\"Val.Flow.95\",\"Val.BlowFlow.50\",\"Val.SpO2.50\",\"Val.SpO2.95\",\"Val.SpO2.Max\",\"Val.SpO2Thresh\",\"Val.SignalStrength\",\"Val.FlightMode\"]}"] } |
    And I should eventually receive a call home SMS within 10 seconds

  @last.post.date.S1
  @ECO-9653.2 @ECO-9653.3 @ECO-12459.1 @ECO-10358.2
  Scenario: Should have default last post date (1970-01-01T00:00:00) after first registration
    # Receiving a mix of requests (subscriptions, settings, etc)
    When by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 7 seconds
      | URI Fixed Part          | Content Identifier |
      | /api/v1/subscriptions/  | <ANY_UUID>         |
      | /api/v1/subscriptions/  | <ANY_UUID>         |
      | /api/v1/configurations/ | <ANY_UUID>         |
    And I request my last configuration brokered message
    Then I should receive the following configuration
      | json                                                                                                        |
      | { "FG.SerialNo": "10000000003", "ConfigurationId": "<URL_UUID>", "LastHistoryDate": "1970-01-01T00:00:00" } |

  @last.post.date.S2
  @ECO-9653.1
  @ECO-12459.1 @ECO-10358.2
  Scenario: Subsequent (not the first time) registration of external CAM with device, where server have identical non-empty list with those listed in registration message.
    Given I request my broker requests for flow generator and external cam
    And I acknowledge all brokered messages
    And I request my broker requests for flow generator and external cam
    And I should eventually receive the following broker requests within 7 seconds
      | json                                             |
      | { "FG.SerialNo": "10000000003", "Broker": [  ] } |
    And these devices have the following therapy summaries
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "4f8a3ac8-8731-4fc8-83de-aea46d06c119", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "4f8a3ac8-8731-4fc8-83de-aea46d06c119", "Date": "2 days ago", "CollectTime": "1 days ago 102252", "Val.Mode": "CPAP", "Val.Duration": 615, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1215 ], "Val.AHI": 5.8, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "4f8a3ac8-8731-4fc8-83de-aea46d06c119", "Date": "1  day ago", "CollectTime": "today      010101", "Val.Mode": "CPAP", "Val.Duration": 590, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1190 ], "Val.AHI": 5.4, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.0, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
    And I send the therapy summaries from 3 days ago
    And I should receive a server ok response
    And I send the therapy summaries from 2 days ago
    And I should receive a server ok response
    And I send the therapy summaries from 1 days ago
    And I should receive a server ok response
    # This delay is needed to ensure data is in the cloud before we query it in next step.
    And I pause for 10 seconds
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G00001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": ["1ae07605-ff49-4a04-a1bb-b10c5c1873b9", "4f8a3ac8-8731-4fc8-83de-aea46d06c119"]
    }
    """
    And the server should not log a device configuration change
    Then I should eventually receive a call home SMS within 10 seconds
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 7 seconds
      | URI Fixed Part          | Content Identifier |
      | /api/v1/configurations/ | <ANY_UUID>         |
    When I request my last configuration brokered message
    Then I should receive the following configuration
      | json                                                                                                         |
      | { "FG.SerialNo": "10000000003", "ConfigurationId": "<URL_UUID>", "LastHistoryDate": "<YESTERDAY>T00:00:00" } |

  @last.post.date.S3
  @ECO-9653.1 @ECO-9653.2
  Scenario: Racing condition, where device assignment happens just after registration but before all management requests (including last post data) have been acknowledged by the CAMBridge.
    When I request my broker requests for flow generator and external cam
    And the following devices have been assigned
      | serialNumber | mid | vid | setupDate  | updatedOn           |
      | 10000000003  | 36  | 33  | 2014-01-01 | 2014-01-01 13:07:45 |
    And I request my last configuration brokered message
    Then I should receive the following configuration
      | json                                                                                                        |
      | { "FG.SerialNo": "10000000003", "ConfigurationId": "<URL_UUID>", "LastHistoryDate": "1970-01-01T00:00:00" } |
