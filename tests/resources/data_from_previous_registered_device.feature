@newport
@newport.data.from.previous.registered.device
@ECO-6607

Feature:

  (ECO-6607) As a Newport Device,
  I want an HTTP response code that indicates I should register and then retry my request
  so that I stop assuming all is fine.

# ACCEPTANCE CRITERIA: (ECO-6607)
# Note 1: This story relates to the NGCS to CAM interface interface.
#  1. ECO shall return a 424 HTTP response code for a device request if the device has no recorded registration. Note 2: Message authentication must succeed first.

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

  @newport.data.from.previous.registered.device.S1
  @ECO-6607.1
  Scenario: A device and CAM are registered, followed by the CAM connected to a different device, with which the CAM also registers. The CAM then posts data of the first device.
    # FG:10000000003 and CAM:10000000001 registered, hence paired
    Given the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000001                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    And these devices have the following therapy summaries
      | json                                                                                                                                                                                                                               |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ]} |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "Date": "2 days ago", "CollectTime": "1 days ago 102252", "Val.Mode": "CPAP", "Val.Duration": 615, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1215 ]} |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "Date": "1  day ago", "CollectTime": "today      010101", "Val.Mode": "CPAP", "Val.Duration": 590, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1190 ]} |
    # Data sent from un-registered device
    When I send the therapy summaries from 3 days ago
    Then I should receive a response code of "424"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G10001"},
      "Subscriptions": []
    }
    """
    Then 1 count of registration history where flow generator has an paired communication module has been added
    And the server should get the following device configuration change
      | json                                                                                                                                                      |
      | { "serialNo": "10000000003", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false} |
    # Preparing device subscription
    When the newport management queue received the following "SUBSCRIPTION" messages
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff"] } |
    Then the flow generator "10000000003" should eventually have the following subscriptions within 10 seconds
      | id     | json                                                                                                                                                                                                                                                                                                                                                      |
      | UUID-2 | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff"] } |
    And the communication module "10000000001" should eventually have the following subscriptions for its paired flow gen within 10 seconds
      | id     | json                                                                                                                                                                                                                                                                                                                                                      |
      | UUID-2 | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff"] } |
    And I should eventually receive a call home SMS within 15 seconds
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 7 seconds
      | URI Fixed Part         | Content Identifier |
      | /api/v1/subscriptions/ | UUID-2             |
    # Data sent from currently registered device
    When I send the therapy summaries from 3 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                               |
      | THERAPY_SUMMARY | 10000000003 | DEVICE           | 10000000003               | 36                       | 33                      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ]} |
    When I send the therapy summaries from 2 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                               |
      | THERAPY_SUMMARY | 10000000003 | DEVICE           | 10000000003               | 36                       | 33                      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "Date": "2 days ago", "CollectTime": "1 days ago 102252", "Val.Mode": "CPAP", "Val.Duration": 615, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1215 ]} |
    And the following therapy summaries are stored in the cloud
      | json                                                                                                                                                                                                                               |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ]} |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "Date": "2 days ago", "CollectTime": "1 days ago 102252", "Val.Mode": "CPAP", "Val.Duration": 615, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1215 ]} |
    # FG:10000000004 and CAM:10000000001 (Another flow generator is now paired with above CAM)
    Given the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 10000000004               |
    And I am a device with the FlowGen serial number "10000000004"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000004", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G10001"},
      "Subscriptions": []
    }
    """
    Then 1 count of registration history where flow generator has an paired communication module has been added
    And the server should get the following device configuration change
      | json                                                                                                                                                       |
      | { "serialNo": "10000000004", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false } |
    # For the steps below, a real-life physical reconnection of FG and CAM is not necessary. The CAM can already send the data of the
    # FG that it had been connected to in the past. However, due to cucumber implementation of steps, where most actions appear as device
    # initiated, while in real life they are CAM initiated, we had to have the steps for the "reconnection" of FG and CAM.
    # Swapping connection FG:10000000003 to CAM:10000000001 without sending registration.
    Given I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    # Send data from previously registered device (not the currently registered device 1000000004)
    When I send the therapy summaries from 1 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                               |
      | THERAPY_SUMMARY | 10000000003 | DEVICE           | 10000000003               | 36                       | 33                      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "Date": "1  day ago", "CollectTime": "today      010101", "Val.Mode": "CPAP", "Val.Duration": 590, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1190 ]} |
    Then the following therapy summaries are stored in the cloud
      | json                                                                                                                                                                                                                               |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "Date": "1  day ago", "CollectTime": "today      010101", "Val.Mode": "CPAP", "Val.Duration": 590, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1190 ]} |
