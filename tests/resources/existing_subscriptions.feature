@cam
@newport
@newport.broker
@newport.subscriptions
@newport.subscriptions.existing
@newport.subscriptions.validation

@ECO-9843
@ECO-10358
@ECO-12459

Feature:
  (ECO-9843) As ECO
  I want to generate subscriptions for a CAMBridge device customised to its connected flow generator
  so that the device can talk to ECO

  (ECO-10358) As ECO
  I want to generate subscriptions for a CAMBridge device customised to its connected flow generator
  so that the device can talk to ECO

  # ACCEPTANCE CRITERIA: (ECO-9843)
  #  1. When an external CAM registers with a device (ie. as per ECO-9421) and AirView holds subscriptions for that device then:
  #  1a. The subscriptions for the device shall be sent to the CAMBridge through the existing communications protocol.
  #  *Note:* This card will cover getting the subscriptions onto the request broker. SMS, etc, is handled elsewhere.
  #
  #  *Note1:* A test case related to ECO-9423 AC5 is opened up here - this will be an example of a request that can go on the
  #  CAMBridge that is only relevant to a given device and therefore should be subject to the filtering specified there.
  #  Please add a feature file test case for this.

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

  Background:
    Given the server completed bulk load the following devices and modules with status
      | jobFile                                                                  | jobStatus        |
      | /data/manufacturing/unit_detail_new_cam10000000001_fg_bdg22151763351.xml | COMPLETE-SUCCESS |
      | /data/manufacturing/unit_detail_new_cam10000000003_fg_bdg22151763361.xml | COMPLETE-SUCCESS |
      | /data/manufacturing/unit_detail_001_10000000003_new_camless.xml          | COMPLETE-SUCCESS |
    And the communication module "10000000001" uses mock Telco
    And the communication module "10000000003" uses mock Telco
    # First registration, subscriptions shall be generated from template
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000001                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G00001"},
      "Subscriptions": []
    }
    """
    And the server should get the following device configuration change
      | json                                                                                                                                                      |
      | { "serialNo": "10000000003", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false} |
    And the server has no SMS retry for flow generator 10000000003
    When a subscription batch holding following subscriptions is queued for device with serial number "10000000003"
      | /data/subscription_E0C70BA1-FEE3-4445-9FF1-AD9942640000_10000000003.json |
      | /data/subscription_E0C70BA1-FEE3-4445-9FF1-AD9942641111_10000000003.json |
      | /data/subscription_UUID1_10000000003.json                                |
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 10 seconds
      | URI Fixed Part          | Content Identifier                   |
      | /api/v1/subscriptions/  | E0C70BA1-FEE3-4445-9FF1-AD9942640000 |
      | /api/v1/subscriptions/  | E0C70BA1-FEE3-4445-9FF1-AD9942641111 |
      | /api/v1/subscriptions/  | UUID-1                               |
      | /api/v1/configurations/ | <ANY_UUID>                           |
    And I request SUBSCRIPTION brokered requests for flow generator 10000000003
    And I should receive all of the following subscriptions
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942640000", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942641111", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": ["Val.LastEraseDate"]}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
    And the server has a CALL_HOME SMS retry for flow generator 10000000003
    And I acknowledge all brokered messages

  @newport.subscriptions.existing.S1
  @ECO-9843.1a @ECO-12459.1
  Scenario Outline: V2 registration of device and external CAM with empty subscription array in registration message and pre-existing subscriptions exist
    When the following subscription update is requested on management api
      | subscriptionId | requestBody            |
      | UUID-1         | <BlockOrCancelMessage> |
    Then I should receive a response code of "200"
    And I should eventually receive a call home SMS within 10 seconds
    When by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 10 seconds
      | URI Fixed Part         | Content Identifier |
      | /api/v1/subscriptions/ | UUID-1             |
    Then I should receive the following broker requests
      | json                                                                        |
      | {"FG.SerialNo":"10000000003","Broker":["/api/v1/subscriptions/<ANY_UUID>"]} |
    When I request the subscription with identifier "UUID-1"
    Then I should receive the following subscription
      | json                                                                         |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-1", "Cancel": true } |
    And I acknowledge all brokered messages
    # A subsequent registration, where the server already holds subscription for this device
    Given the cached device list and cached responses are cleared
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000003                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000003" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000003", "Software": "SX588-0101", "PCBASerialNo":"13152G00003"},
      "Subscriptions": []
    }
    """
    Then the server should not log a device configuration change
    And I should eventually receive a call home SMS within 10 seconds
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 7 seconds
      | URI Fixed Part          | Content Identifier                   |
      | /api/v1/subscriptions/  | E0C70BA1-FEE3-4445-9FF1-AD9942640000 |
      | /api/v1/subscriptions/  | E0C70BA1-FEE3-4445-9FF1-AD9942641111 |
      | /api/v1/configurations/ | <ANY_UUID>                           |
    When I request SUBSCRIPTION brokered requests for flow generator 10000000003
    Then I should receive all of the following subscriptions
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942640000", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942641111", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
    And the server has a CALL_HOME SMS retry for flow generator 10000000003

  Examples:
    | BlockOrCancelMessage                  |
    |  {"Block": true}                      |
    |  {"Cancel": true}                     |


  @newport.subscriptions.existing.S2
  @ECO-9843.1a @ECO-10358.1a @ECO-12459.1
  Scenario: Registration via V2 of flow generator with external CAM, where JSON message contains only unknown subscriptions
    Given the cached device list and cached responses are cleared
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000003                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000003" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000003", "Software": "SX588-0101", "PCBASerialNo":"13152G00003"},
      "Subscriptions": ["CAMSUB_1", "CAMSUB_2"]
    }
    """
    Then the server should not log a device configuration change
    And I should eventually receive a call home SMS within 10 seconds
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 7 seconds
      | URI Fixed Part          | Content Identifier                   |
      | /api/v1/subscriptions/  | CAMSUB_1                             |
      | /api/v1/subscriptions/  | CAMSUB_2                             |
      | /api/v1/subscriptions/  | UUID-1                               |
      | /api/v1/subscriptions/  | E0C70BA1-FEE3-4445-9FF1-AD9942640000 |
      | /api/v1/subscriptions/  | E0C70BA1-FEE3-4445-9FF1-AD9942641111 |
      | /api/v1/configurations/ | <ANY_UUID>                           |

  @newport.subscriptions.existing.S3
  @ECO-9843.1a @ECO-10358.1a @ECO-10358.2
  Scenario: Registration via V2 of flow generator with external CAM, where JSON message contains unknown and known subscription as well as missing some existing subscription in server
    Given the cached device list and cached responses are cleared
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000003                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000003" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000003", "Software": "SX588-0101", "PCBASerialNo":"13152G00003"},
      "Subscriptions": ["CAMSUB_1", "E0C70BA1-FEE3-4445-9FF1-AD9942640000"]
    }
    """
    Then the server should not log a device configuration change
    And I should eventually receive a call home SMS within 10 seconds
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 7 seconds
      | URI Fixed Part          | Content Identifier                   |
      | /api/v1/subscriptions/  | CAMSUB_1                             |
      | /api/v1/subscriptions/  | UUID-1                               |
      | /api/v1/subscriptions/  | E0C70BA1-FEE3-4445-9FF1-AD9942641111 |
      | /api/v1/configurations/ | <ANY_UUID>                           |

  @newport.subscriptions.existing.S4
  @ECO-9843.1a @ECO-10358.1a
  Scenario: Registration via V2 of flow generator with external CAM, where JSON message contains all server known subscriptions and one unknown one
    Given the cached device list and cached responses are cleared
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000003                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000003" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
  """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000003", "Software": "SX588-0101", "PCBASerialNo":"13152G00003"},
      "Subscriptions": ["CAMSUB_1", "UUID-1", "E0C70BA1-FEE3-4445-9FF1-AD9942640000", "E0C70BA1-FEE3-4445-9FF1-AD9942641111"]
    }
    """
    Then the server should not log a device configuration change
    And I should eventually receive a call home SMS within 10 seconds
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 7 seconds
      | URI Fixed Part          | Content Identifier |
      | /api/v1/subscriptions/  | CAMSUB_1           |
      | /api/v1/configurations/ | <ANY_UUID>         |
    When I request SUBSCRIPTION brokered requests for flow generator 10000000003
    Then I should receive all of the following subscriptions
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "CAMSUB_1", "Cancel": true} |

  @newport.subscriptions.existing.S5
  @ECO-9843.1a @ECO-12459.1
  Scenario: V2 registration of device and external CAM with subscription array containing a subscription, which is already cancelled
    When the following subscription update is requested on management api
      | subscriptionId | requestBody            |
      | UUID-1         | {"Cancel": true} |
    Then I should receive a response code of "200"
    And I should eventually receive a call home SMS within 10 seconds
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 10 seconds
      | URI Fixed Part         | Content Identifier |
      | /api/v1/subscriptions/ | UUID-1             |
    And I should receive the following broker requests
      | json                                                                        |
      | {"FG.SerialNo":"10000000003","Broker":["/api/v1/subscriptions/<ANY_UUID>"]} |
    And I acknowledge all brokered messages
    # In following registration, server holds E0C70BA1-FEE3-4445-9FF1-AD9942640000, E0C70BA1-FEE3-4445-9FF1-AD9942641111 which are active
    # It also holds UUID-1, which had been cancelled previously
    Given the cached device list and cached responses are cleared
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000003                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000003" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000003", "Software": "SX588-0101", "PCBASerialNo":"13152G00003"},
      "Subscriptions": ["UUID-1"]
    }
    """
    Then the server should not log a device configuration change
    And I should eventually receive a call home SMS within 10 seconds
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 7 seconds
      | URI Fixed Part          | Content Identifier                   |
      | /api/v1/subscriptions/  | E0C70BA1-FEE3-4445-9FF1-AD9942640000 |
      | /api/v1/subscriptions/  | E0C70BA1-FEE3-4445-9FF1-AD9942641111 |
      | /api/v1/subscriptions/  | UUID-1                               |
      | /api/v1/configurations/ | <ANY_UUID>                           |
    When I request SUBSCRIPTION brokered requests for flow generator 10000000003
    Then I should receive all of the following subscriptions
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942640000", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942641111", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-1", "Cancel": true } |
    And the server has a CALL_HOME SMS retry for flow generator 10000000003
