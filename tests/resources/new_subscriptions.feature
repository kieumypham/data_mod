@cam
@newport
@newport.broker
@newport.subscriptions
@newport.subscriptions.new
@ECO-6668
@ECO-9654
@ECO-10358
@ECO-12459

Feature:
  (ECO-6668) As ECO
  I want to record subscriptions for each device
  so that I can track subscriptions for devices.

  (ECO-9654) As ECO
  I want to generate subscriptions for a CAMBridge device customised to
  its connected flow generator so that the device can talk to ECO.

  (ECO-10358) As ECO
  I want to generate subscriptions for a CAMBridge device customised to its connected flow generator
  so that the device can talk to ECO

  # ACCEPTANCE CRITERIA: (ECO-6668)
  # Note 1: The intent of this story is to keep track of subscriptions that are sent to a device. ECO-5555 generates and sends the subscriptions to a device. This story keeps a record of these subscriptions in ECO.
  # 1. ECO shall keep a record of subscriptions sent to a device so that data sent by the device can be validated.
  # 1a. Log file requests shall not be recorded when they are sent to a device.

  # ACCEPTANCE CRITERIA: (ECO-9654)
  # 1. When the external CAM registers with a device (ie. as per ECO-9421) and the registration message contains an empty subscription and AirView holds no subscriptions for that device then:
  # 1a. Subscriptions shall be generated for the device connected to the external CAM as per ECO-5555 1a, 1b and 1c.
  # 1b. The subscriptions shall be sent to the CAMBridge.

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

  @newport.subscriptions.new.S1
  @ECO-6668.1
  Scenario: New subscription for a new device is stored in the database
    Given the server receives the following manufacturing unit detail
      | resource                                                             |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg88800000001_cam88810000001_new.xml |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    When the server is given the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                 |
      | {"FG.SerialNo":"88800000001","SubscriptionId":"E0C70BA1-FEE3-4445-9FF1-AD9942643F42","ServicePoint":"/api/v1/therapy/summaries","Trigger":"HALO","Schedule":{"StartDate":"01/01/2014","EndDate":null},"Data":["Val.Mode","Val.Duration","Val.MaskOn","Val.MaskOff","Val.What.Ever"]} |
    Then NGCS has the following subscriptions
      | subscriptionId                       | subscriptionJson                                                                                                                                                                                                                                                                                       |
      | E0C70BA1-FEE3-4445-9FF1-AD9942643F42 | {"FG.SerialNo": "88800000001", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint": "/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"01/01/2014", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.What.Ever" ] } |
    And by requesting messages for FG "88800000001" by myself I should eventually receive the following results in 7 seconds
      | URI Fixed Part         | Content Identifier                   |
      | /api/v1/subscriptions/ | E0C70BA1-FEE3-4445-9FF1-AD9942643F42 |

  @newport.subscriptions.new.S2
  @ECO-6668.1a
  Scenario: New log request is not stored in the database
    Given the server receives the following manufacturing unit detail
      | resource                                                             |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg88800000001_cam88810000001_new.xml |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    When the server is given the following subscriptions to be sent to devices
      | json                                                                                                                                                                                   |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "341D4CDF-3A1B-4369-93C0-BF07573A6F5E", "ServicePoint": "/api/v1/logs", "Trigger": { "Collect": [ "NOW" ] }, "Log.Type": "Log.CAM" } |
    Then by requesting messages for FG "88800000001" by myself I should eventually receive the following results in 7 seconds
      | URI Fixed Part         | Content Identifier                   |
      | /api/v1/subscriptions/ | 341D4CDF-3A1B-4369-93C0-BF07573A6F5E |
    And NGCS does not have subscription "341D4CDF-3A1B-4369-93C0-BF07573A6F5E"

  @newport.subscriptions.new.S3
  @ECO-9654.1a @ECO-9654.1b @ECO-10358.1 @ECO-12459.1
  Scenario: Registration via V1 api, flow generator with external CAM, where server holds no subscriptions and registration JSON message has empty subscriptions array.
    Given the server completed bulk load the following devices and modules with status
      | jobFile                                                         | jobStatus        |
      | /data/manufacturing/batch_new_fg1000.xml                        | COMPLETE-SUCCESS |
      | /data/manufacturing/batch_new_cam10000000001_bdg22151763351.xml | COMPLETE-SUCCESS |
      | /data/manufacturing/batch_new_cam10000000003_bdg22151763361.xml | COMPLETE-SUCCESS |
    And the communication module "10000000001" uses mock Telco
    And the communication module "10000000003" uses mock Telco
    # First registration, server holds no existing subscriptions
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000001                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                                                     |
      | { "FG": {"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G10001", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    Then the server should get the following device configuration change
      | json                                                                                                                                                      |
      | { "serialNo": "10000000003", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false} |
    When a subscription batch holding following subscriptions is queued for device with serial number "10000000003"
      | /data/subscription_UUID1_10000000003.json |
      | /data/subscription_UUID2_10000000003.json |
    Then the flow generator "10000000003" should eventually have the following subscriptions within 10 seconds
      | id     | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-1 | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-2 | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
    And the communication module "10000000001" should eventually have the following subscriptions for its paired flow gen within 10 seconds
      | id     | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-1 | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-2 | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
    And I should eventually receive a call home SMS within 10 seconds
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 7 seconds
      | URI Fixed Part          | Content Identifier |
      | /api/v1/subscriptions/  | UUID-1             |
      | /api/v1/subscriptions/  | UUID-2             |
      | /api/v1/configurations/ | <ANY_UUID>         |
    When I request SUBSCRIPTION brokered requests for flow generator 10000000003
    Then I should receive all of the following subscriptions
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
    And I acknowledge all brokered messages
    # CAM 10000000003 must be paired with a FlowGen
    Given the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000004               | 10000000003                     |
    And I am a device with the FlowGen serial number "10000000004"
    And I have been connected with CAM with serial number "10000000003" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG": {"SerialNo": "10000000004", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030011", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "10000000003", "Software": "SX588-0101", "PCBASerialNo":"13152G30003", "Subscriptions": [] }, "Hum": {"Software": "HUMABCDEFH"} } |
    Then the server should get the following device configuration change
      | json                                                                                                                                                      |
      | { "serialNo": "10000000004", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false} |
    # Second registration, where there exist subscriptions for the FG in NGCS server
    Given the cached device list and cached responses are cleared
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000003                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000003" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG": {"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "10000000003", "Software": "SX588-0101", "PCBASerialNo":"13152G30003", "Subscriptions": [] }, "Hum": {"Software": "HUMABCDEFH"} } |
    Then the server should not log a device configuration change
    And the flow generator "10000000003" should eventually have the following subscriptions within 1 seconds
      | id     | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-1 | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-2 | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 30 seconds
      | URI Fixed Part          | Content Identifier |
      | /api/v1/subscriptions/  | UUID-1             |
      | /api/v1/subscriptions/  | UUID-2             |
      | /api/v1/configurations/ | <ANY_UUID>         |
    When I request SUBSCRIPTION brokered requests for flow generator 10000000003
    Then I should receive all of the following subscriptions
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |

  @newport.subscriptions.new.S4
  @ECO-9654.1a @ECO-9654.1b
  Scenario: Registration via V2 api, flow generator with external CAM, where server holds no subscriptions and registration JSON message has empty subscriptions array
    Given the server completed bulk load the following devices and modules with status
      | jobFile                                                         | jobStatus        |
      | /data/manufacturing/batch_new_fg1000.xml                        | COMPLETE-SUCCESS |
      | /data/manufacturing/batch_new_cam10000000001_bdg22151763351.xml | COMPLETE-SUCCESS |
      | /data/manufacturing/batch_new_cam10000000003_bdg22151763361.xml | COMPLETE-SUCCESS |
    And the communication module "10000000001" uses mock Telco
    And the communication module "10000000003" uses mock Telco
    # First registration, server has no subscriptions for the registering device
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000001                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G10001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
    Then the server should get the following device configuration change
      | json                                                                                                                                                       |
      | { "serialNo": "10000000003", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false } |
    And a subscription batch holding following subscriptions is queued for device with serial number "10000000003"
      | /data/subscription_UUID1_10000000003.json |
      | /data/subscription_UUID2_10000000003.json |
    Then the flow generator "10000000003" should eventually have the following subscriptions within 10 seconds
      | id     | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-1 | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-2 | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
    And the communication module "10000000001" should eventually have the following subscriptions for its paired flow gen within 10 seconds
      | id     | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-1 | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-2 | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
    And I should eventually receive a call home SMS within 10 seconds
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 10 seconds
      | URI Fixed Part          | Content Identifier |
      | /api/v1/subscriptions/  | UUID-1             |
      | /api/v1/subscriptions/  | UUID-2             |
      | /api/v1/configurations/ | <ANY_UUID>         |
    When I request SUBSCRIPTION brokered requests for flow generator 10000000003
    Then I should receive all of the following subscriptions
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
    And I acknowledge all brokered messages
    # CAM 10000000003 must be paired with a FlowGen
    Given the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000004               | 10000000003                     |
    And I am a device with the FlowGen serial number "10000000004"
    And I have been connected with CAM with serial number "10000000003" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000004", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030011",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000003", "Software": "SX588-0101", "PCBASerialNo":"13152G30003"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
    Then the server should get the following device configuration change
      | json                                                                                                                                                       |
      | { "serialNo": "10000000004", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false } |
    # Second registration, NGCS server already has subscriptions for the device
    Given the cached device list and cached responses are cleared
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000003                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000003" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000003", "Software": "SX588-0101", "PCBASerialNo":"13152G30003"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
    Then the server should not log a device configuration change
    And the flow generator "10000000003" should eventually have the following subscriptions within 10 seconds
      | id     | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-1 | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-2 | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 30 seconds
      | URI Fixed Part          | Content Identifier |
      | /api/v1/subscriptions/  | UUID-1             |
      | /api/v1/subscriptions/  | UUID-2             |
      | /api/v1/configurations/ | <ANY_UUID>         |
    When I request SUBSCRIPTION brokered requests for flow generator 10000000003
    Then I should receive all of the following subscriptions
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
    And I acknowledge all brokered messages

  @newport.subscriptions.new.S5
  @ECO-9654.1a @ECO-9654.1b
  Scenario: Registration via V1 api, flow generator with internal CAM, where server holds no subscriptions and registration JSON message has empty subscriptions array.
    Given the server completed bulk load the following devices and modules with status
      | jobFile                                          | jobStatus        |
      | /data/manufacturing/batch_new_fg4000_cam4000.xml | COMPLETE-SUCCESS |
      | /data/manufacturing/batch_new_cam1000.xml        | COMPLETE-SUCCESS |
    And the communication module "40000000001" uses mock Telco
    And the communication module "10000000005" uses mock Telco
    # First registration, brand new CAM, and server holds no subscriptions
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 40000000001               | 40000000001                     |
    And I am a device with the FlowGen serial number "40000000001"
    And I have been connected with CAM with serial number "40000000001" with authentication key "MzYxMDAwMDAwMDAwMTEwMDAwMDAwMDAx"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                                                     |
      | { "FG": {"SerialNo": "40000000001", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030008", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "40000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G00001", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    Then the server should not log a device configuration change
    And the flow generator "40000000001" should not have any flow gen subscriptions
    And the communication module "40000000001" should not have any flow gen subscriptions
    # Second registration, replacement CAM, and server holds no subscriptions
    Given the cached device list and cached responses are cleared
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 40000000001               | 10000000005                     |
    And I am a device with the FlowGen serial number "40000000001"
    And I have been connected with CAM with serial number "10000000005" with authentication key "123456789DAwMDAwNTEwMDAwMDAwMDA1"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                                                     |
      | { "FG": {"SerialNo": "40000000001", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030008", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "10000000005", "Software": "SX588-0101", "PCBASerialNo":"13152G00005", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    Then the server should get the following device configuration change
      | json                                                                                                                                                             |
      | { "serialNo": "40000000001", "mid": 36, "vid": 25, "communicationModuleMode": "ACTIVE", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false } |
    When a subscription batch holding following subscriptions is queued for device with serial number "40000000001"
      | /data/subscription_UUID1_40000000001.json |
      | /data/subscription_UUID2_40000000001.json |
    Then the flow generator "40000000001" should eventually have the following subscriptions within 10 seconds
      | id     | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-1 | { "FG.SerialNo": "40000000001", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-2 | { "FG.SerialNo": "40000000001", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
    And the communication module "10000000005" should eventually have the following subscriptions for its paired flow gen within 10 seconds
      | id     | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-1 | { "FG.SerialNo": "40000000001", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-2 | { "FG.SerialNo": "40000000001", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
    And I should eventually receive a call home SMS within 10 seconds
    And by requesting messages for FG "40000000001" by myself I should eventually receive the following results in 7 seconds
      | URI Fixed Part         | Content Identifier |
      | /api/v1/subscriptions/ | UUID-1             |
      | /api/v1/subscriptions/ | UUID-2             |
    When I request SUBSCRIPTION brokered requests for flow generator 40000000001
    Then I should receive all of the following subscriptions
      | { "FG.SerialNo": "40000000001", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "40000000001", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |

  @newport.subscriptions.new.S6
  @ECO-9654.1a @ECO-9654.1b
  Scenario: Registration via V2 api, flow generator with internal CAM, where server holds no subscriptions and registration JSON message has empty subscriptions array.
    Given the server completed bulk load the following devices and modules with status
      | jobFile                                          | jobStatus        |
      | /data/manufacturing/batch_new_fg4000_cam4000.xml | COMPLETE-SUCCESS |
      | /data/manufacturing/batch_new_cam1000.xml        | COMPLETE-SUCCESS |
    And the communication module "40000000001" uses mock Telco
    And the communication module "10000000005" uses mock Telco
    # First registration, brand new CAM, and server holds no subscriptions
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 40000000001               | 40000000001                     |
    And I am a device with the FlowGen serial number "40000000001"
    And I have been connected with CAM with serial number "40000000001" with authentication key "MzYxMDAwMDAwMDAwMTEwMDAwMDAwMDAx"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "40000000001", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030008",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "40000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G00001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
    Then the server should not log a device configuration change
    And the flow generator "40000000001" should not have any flow gen subscriptions
    And the communication module "40000000001" should not have any flow gen subscriptions
    # Second registration, replacement CAM, and server holds no subscriptions
    Given the cached device list and cached responses are cleared
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 40000000001               | 10000000005                     |
    And I am a device with the FlowGen serial number "40000000001"
    And I have been connected with CAM with serial number "10000000005" with authentication key "123456789DAwMDAwNTEwMDAwMDAwMDA1"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "40000000001", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030008",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000005", "Software": "SX588-0101", "PCBASerialNo":"13152G00005"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
    Then the server should get the following device configuration change
      | json                                                                                                                                                             |
      | { "serialNo": "40000000001", "mid": 36, "vid": 25, "communicationModuleMode": "ACTIVE", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false } |
    And a subscription batch holding following subscriptions is queued for device with serial number "40000000001"
      | /data/subscription_UUID1_40000000001.json |
      | /data/subscription_UUID2_40000000001.json |
    Then the flow generator "40000000001" should eventually have the following subscriptions within 10 seconds
      | id     | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-1 | { "FG.SerialNo": "40000000001", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-2 | { "FG.SerialNo": "40000000001", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
    And the communication module "10000000005" should eventually have the following subscriptions for its paired flow gen within 10 seconds
      | id     | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-1 | { "FG.SerialNo": "40000000001", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | UUID-2 | { "FG.SerialNo": "40000000001", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
    And I should eventually receive a call home SMS within 10 seconds
    And by requesting messages for FG "40000000001" by myself I should eventually receive the following results in 10 seconds
      | URI Fixed Part         | Content Identifier |
      | /api/v1/subscriptions/ | UUID-1             |
      | /api/v1/subscriptions/ | UUID-2             |
    When I request SUBSCRIPTION brokered requests for flow generator 40000000001
    Then I should receive all of the following subscriptions
      | { "FG.SerialNo": "40000000001", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "40000000001", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |

  @newport.subscriptions.new.S7
  @ECO-10358.1 @ECO-12459.1
  Scenario: Registration via V2 api, flow generator with external CAM, where server holds no subscriptions and registration JSON message has some subscriptions.
    Given the server completed bulk load the following devices and modules with status
      | jobFile                                                         | jobStatus        |
      | /data/manufacturing/batch_new_fg1000.xml                        | COMPLETE-SUCCESS |
      | /data/manufacturing/batch_new_cam10000000001_bdg22151763351.xml | COMPLETE-SUCCESS |
      | /data/manufacturing/batch_new_cam10000000003_bdg22151763361.xml | COMPLETE-SUCCESS |
    And the communication module "10000000001" uses mock Telco
    And the communication module "10000000003" uses mock Telco
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000001                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G10001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": ["UUID-A", "UUID-B"]
    }
    """
    Then the server should get the following device configuration change
      | json                                                                                                                                                      |
      | { "serialNo": "10000000003", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false} |
    And a subscription batch holding following subscriptions is queued for device with serial number "10000000003"
      | /data/subscription_UUID1_10000000003.json |
      | /data/subscription_UUID2_10000000003.json |
    Then I should eventually receive a call home SMS within 10 seconds
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 10 seconds
      | URI Fixed Part          | Content Identifier |
      | /api/v1/subscriptions/  | UUID-1             |
      | /api/v1/subscriptions/  | UUID-2             |
      | /api/v1/subscriptions/  | UUID-A             |
      | /api/v1/subscriptions/  | UUID-B             |
      | /api/v1/configurations/ | <ANY_UUID>         |
    When I request SUBSCRIPTION brokered requests for flow generator 10000000003
    Then I should receive all of the following subscriptions
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-A", "Cancel": true}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-B", "Cancel": true}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
    And I acknowledge all brokered messages