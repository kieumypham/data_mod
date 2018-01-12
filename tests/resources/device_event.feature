@newport
@newport.settings.and.system.event
@ECO-10762
@ECO-10769
@ECO-13276

Feature:

  (ECO-10762) As a clinical user
  I would like to access settings logs for my patients once they are made available in AirView
  so that I can manage my patients better.

  (ECO-10769) As a clinical user,
  I would like to access system event logs for my patients once they are made available in AirView
  so that I can manage my patients better.

  (ECO-13276) As the Machine Portal,
  I want to update a Suspended Cellular Module state to Activated when a message is received
  so that I known when the last communication occurred

# ACCEPTANCE CRITERIA: (ECO-10762)
#  Note 1: This story applies to devices with a subscription for settings change logs (currently sent by Astral 100, Astral 150 and Stellar devices).
#  Note 2: Settings change logs will only be sent wirelessly (CAMBridge). There will be no upload of Alarm logs from SD card.
#
#  1. AirView shall be able to accept settings change logs information sent wirelessly to the service point: "/api/v1/events/streams/settings".
#  2. AirView shall store the settings change logs. *Note:* Expected to be in the HI Cloud.
#
#  *Note 3:* POSTED JSON will look like the following
#  {
#    "FG.SerialNo": "20142427340",
#    "SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2",
#    "CollectTime": "20151128 173448",
#    "Date": "20151128",
#    "Val.UtcOffset": -120,
#    "Val.SettingChange": [
#      {
#        "EndDateTime": "2015-07-10T12:02:03",
#        "SettingType": "Val.ResRate",
#        "Change": {
#        "Value": 50,
#        "Previous": 40,
#        "Units": "1/Min"
#        }
#      },
#      {
#        "EndDateTime": "2015-11-28T12:43:40",
#        "Program": 0,
#        "SettingType": "Unknown",
#        "SettingCode": "S-ITX",
#        "Change": {
#        "Value": "0038",
#        "Previous": "003C"
#        }
#      }
#    ]
#  }

# ACCEPTANCE CRITERIA: (ECO-10769)
#  Note 1: This story applies to devices with a subscription for system event logs (currently sent by Astral 100, Astral 150 and Stellar devices).
#  Note 2: System event logs will only be sent wirelessly (CAMBridge). There will be no upload of Alarm logs from SD card.
#
#  1. AirView shall be able to accept system event logs information sent wirelessly to the service point: "/api/v1/events/streams/activities".
#  2. AirView shall store the system event logs. *Note:* Expected to be in the HI Cloud.
#
#  *Note 3:* POSTED JSON will look like the following
#  {
#    "FG.SerialNo": "20142427340",
#    "SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2",
#    "CollectTime": "20151128 173448",
#    "Date": "20151128",
#    "Val.UtcOffset": -120,
#    "Val.SystemEvent": [
#      {
#        "EndDateTime": "2015-11-28T12:43:09",
#        "SystemCode": "E-003"
#      },
#      {
#        "EndDateTime": "2015-11-28T12:44:58",
#        "SystemCode": "E-018"
#      },
#      {
#        "EndDateTime": "2015-11-28T13:05:01",
#        "SystemCode": "E-019"
#      }
#    ]
#  }

# ACCEPTANCE CRITERIA: (ECO-13276)
# A Suspended Cellular Module will be updated to Activated when:
# 1. A Registration is received
# 2. An Alarm Setting is received
# 3. A Climate Setting is received
# 4. A Device Alarm is received
# 5. A Device Erasure is received
# 6. A Device Fault is received
# 7. A Device Log is received
# 8. A Settings Event is received
# 9. A System Event is received
# 10. A Therapy Detail is received
# 11. A Therapy Setting is received
# 12. A Therapy Summary is received

  Background:
    Given the server completed bulk load the following devices and modules with status
      | jobFile                                                         | jobStatus        |
      | /data/manufacturing/batch_new_fg1000.xml                        | COMPLETE-SUCCESS |
      | /data/manufacturing/batch_new_cam10000000001_bdg22151763351.xml | COMPLETE-SUCCESS |
    And the communication module "10000000001" uses mock Telco
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000001                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    And I send the following version 2 registration
  """
  {
    "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
    "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G10001"},
    "Subscriptions": []
  }
  """
    And the server should get the following device configuration change
      | json                                                                                                                                                       |
      | { "serialNo": "10000000003", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false } |
    # Setting up subscriptions
    # 2 for settings event with different UUID, and different templates, the 2nd does not include Val.UtcOffset
    # 2 for system event, also with different UUI and templates
    When the newport management queue received the following "SUBSCRIPTION" messages
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2", "ServicePoint": "/api/v1/events/streams/settings", "Trigger": {"Collect": [ "HALO" ],"Conditional": {},"OnlyOnChange": true},"Schedule": {"StartDate": null,"EndDate": null},"Data": ["Val.UtcOffset","Val.SettingChange"]} |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "ABCDEFAB-7234-47D1-9860-6BEB866AD8C2", "ServicePoint": "/api/v1/events/streams/settings", "Trigger": {"Collect": [ "HALO" ],"Conditional": {},"OnlyOnChange": true},"Schedule": {"StartDate": null,"EndDate": null},"Data": ["Val.SettingChange"]}                 |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "11111111-7234-47D1-9860-6BEB866AD8C2", "ServicePoint": "/api/v1/events/streams/activities", "Trigger": {"Collect": [ "HALO" ],"Conditional": {},"OnlyOnChange": true},"Schedule": {"StartDate": null,"EndDate": null},"Data": ["Val.UtcOffset","Val.SystemEvent"]} |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "22222222-7234-47D1-9860-6BEB866AD8C2", "ServicePoint": "/api/v1/events/streams/activities", "Trigger": {"Collect": [ "HALO" ],"Conditional": {},"OnlyOnChange": true},"Schedule": {"StartDate": null,"EndDate": null},"Data": ["Val.SystemEvent"]}                 |
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 30 seconds
      | URI Fixed Part         | Content Identifier                   |
      | /api/v1/subscriptions/ | 8BCAA9C3-7234-47D1-9860-6BEB866AD8C2 |
      | /api/v1/subscriptions/ | ABCDEFAB-7234-47D1-9860-6BEB866AD8C2 |
      | /api/v1/subscriptions/ | 11111111-7234-47D1-9860-6BEB866AD8C2 |
      | /api/v1/subscriptions/ | 22222222-7234-47D1-9860-6BEB866AD8C2 |
    And I acknowledge all brokered messages

  @newport.settings.and.system.event.S1
  @ECO-10762.1 @ECO-10762.2
  Scenario: Received settings event from different (session) dates, or same date but with different collect time for an existing subscription.
    # First post received from device
    When I send the following settings event
      | json                                                                                                                                                                                                                                                                                                        |
      | {"FG.SerialNo": "10000000003","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "2 days ago 010203","Date": "2 days ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-06-10T11:01:03","SettingType": "Val.MinuteVent","Change": {"Value": 30,"Previous": 20, "Units": "L/min"}}]} |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                        |
      | SETTINGS_EVENT | 10000000003 | DEVICE           | 10000000003               | 36                       | 33                      | {"FG.SerialNo": "10000000003","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "2 days ago 010203","Date": "2 days ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-06-10T11:01:03","SettingType": "Val.MinuteVent","Change": {"Value": 30,"Previous": 20, "Units": "L/min"}}]} |
    # Another post from same device in a different day
    When I send the following settings event
      | json                                                                                                                                                                                                                                                                                                                      |
      | {"FG.SerialNo": "10000000003","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today      010101","Date": "1  day ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 50,"Previous": 40,"Units": "1/Min"}}]} |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                      |
      | SETTINGS_EVENT | 10000000003 | DEVICE           | 10000000003               | 36                       | 33                      | {"FG.SerialNo": "10000000003","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today      010101","Date": "1  day ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 50,"Previous": 40,"Units": "1/Min"}}]} |
    # Yet another post in same session date but with different collect time
    When I send the following settings event
      | json                                                                                                                                                                                                                                                                                                                      |
      | {"FG.SerialNo": "10000000003","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today      010130","Date": "1  day ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 50,"Previous": 40,"Units": "1/Min"}}]} |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                      |
      | SETTINGS_EVENT | 10000000003 | DEVICE           | 10000000003               | 36                       | 33                      | {"FG.SerialNo": "10000000003","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today      010130","Date": "1  day ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 50,"Previous": 40,"Units": "1/Min"}}]} |
    And the following settings events are stored in the cloud
      | json                                                                                                                                                                                                                                                                                                                           |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "2 days ago 010203","Date": "2 days ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-06-10T11:01:03","SettingType": "Val.MinuteVent","Change": {"Value": 30,"Previous": 20, "Units": "L/min"}}]}                  |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2", "Date": "1  day ago", "CollectTime": "today 010101", "Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 50,"Previous": 40,"Units": "1/Min"}}]} |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2", "Date": "1  day ago", "CollectTime": "today 010130", "Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 50,"Previous": 40,"Units": "1/Min"}}]} |

  @newport.settings.and.system.event.S2
  @ECO-10762.2
  Scenario: Received settings events which have duplicated time stamps (session date and collect time)
    # First post
    When I send the following settings event
      | json                                                                                                                                                                                                                                                                                                                 |
      | {"FG.SerialNo": "10000000003","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today 010101","Date": "1  day ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 50,"Previous": 40,"Units": "1/Min"}}]} |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                      |
      | SETTINGS_EVENT | 10000000003 | DEVICE           | 10000000003               | 36                       | 33                      | {"FG.SerialNo": "10000000003","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today      010101","Date": "1  day ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 50,"Previous": 40,"Units": "1/Min"}}]} |
    # Repeated post in same session date and same collect time (Deliberately made the content different to show that it's not found in Database)
    When I send the following settings event
      | json                                                                                                                                                                                                                                                                                                              |
      | {"FG.SerialNo": "10000000003","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today 010101","Date": "1  day ago","Val.UtcOffset": 0,"Val.SettingChange": [{"EndDateTime":"2015-04-04T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 50,"Previous": 40,"Units": "1/Min"}}]} |
    Then I should receive a server ok response
    And no device data received events have been published
    # Note: only the first posted data stored in database
    And the following settings events are stored in the cloud
      | json                                                                                                                                                                                                                                                                                                                      |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2", "Date": "1  day ago", "CollectTime": "today 010101", "Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 50,"Previous": 40,"Units": "1/Min"}}]} |

  @newport.settings.and.system.event.S3
  @ECO-10762.2
  Scenario: Received device settings event that failed to meet subscription template or failed to find a matching subscription
    # Referring to "ABCDEFAB-7234-47D1-9860-6BEB866AD8C2" subscription, which excludes "Val.UtcOffset"
    When I send the following settings event
      | json                                                                                                                                                                                                                                                                                                                 |
      | {"FG.SerialNo": "10000000003","SubscriptionId": "ABCDEFAB-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today 010101","Date": "1  day ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 50,"Previous": 40,"Units": "1/Min"}}]} |
    Then I should receive a server ok response
    And no device data received events have been published
    And the server sends the message to invalid settings event queue
      | ValidationVetoPoint       | ValidationFailureType | ValidationFailureReason       |
      | SUBSCRIPTION_VALIDATION   | SUBSCRIPTION_FIELD    | Found unexpected field names  |
    And no settings events are stored in the cloud for serial number "10000000003"
    # Referring to non-existing subscription "99999999-7234-47D1-9860-6BEB866AD8C2"
    When I send the following settings event
      | json                                                                                                                                                                                                                                                                                                                 |
      | {"FG.SerialNo": "10000000003","SubscriptionId": "99999999-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today 010101","Date": "1  day ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 50,"Previous": 40,"Units": "1/Min"}}]} |
    Then I should receive a server ok response
    And no device data received events have been published
    And the server sends the message to invalid settings event queue
      | ValidationVetoPoint     | ValidationFailureType | ValidationFailureReason    |
      | SUBSCRIPTION_VALIDATION | SUBSCRIPTION_FIELD    | Subscription not found     |

  @newport.settings.and.system.event.S4
  @ECO-10762.2
  Scenario: Received device settings events from different devices
    Given the server completed bulk load the following devices and modules with status
      | jobFile                                                         | jobStatus        |
      | /data/manufacturing/batch_new_cam10000000002_bdg22151763341.xml | COMPLETE-SUCCESS |
    And the communication module "10000000002" uses mock Telco
    And the cached device list and cached responses are cleared
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000004               | 10000000002                     |
    And I am a device with the FlowGen serial number "10000000004"
    And I have been connected with CAM with serial number "10000000002" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000004", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000002", "Software": "SX588-0101", "PCBASerialNo":"13152G00002"},
      "Subscriptions": []
    }
    """
    And I pause for 3 seconds
    When the newport management queue received the following "SUBSCRIPTION" messages
      | { "FG.SerialNo": "10000000004", "SubscriptionId": "88888888-7234-47D1-9860-6BEB866AD8C2", "ServicePoint": "/api/v1/events/streams/settings", "Trigger": {"Collect": [ "HALO" ],"Conditional": {},"OnlyOnChange": true},"Schedule": {"StartDate": null,"EndDate": null},"Data": ["Val.UtcOffset","Val.SettingChange"]} |
    Then I should eventually receive a call home SMS within 10 seconds
    And by requesting messages for FG "10000000004" with external CAM I should eventually receive the following results in 7 seconds
      | URI Fixed Part         | Content Identifier                   |
      | /api/v1/subscriptions/ | 88888888-7234-47D1-9860-6BEB866AD8C2 |
    When I send the following settings event
      | json                                                                                                                                                                                                                                                                                                                 |
      | {"FG.SerialNo": "10000000004","SubscriptionId": "88888888-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today 010101","Date": "1  day ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 99,"Previous": 40,"Units": "1/Min"}}]} |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                      |
      | SETTINGS_EVENT | 10000000004 | DEVICE           | 10000000004               | 36                       | 33                      | {"FG.SerialNo": "10000000004","SubscriptionId": "88888888-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today      010101","Date": "1  day ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 99,"Previous": 40,"Units": "1/Min"}}]} |
    And the following settings events are stored in the cloud
      | json                                                                                                                                                                                                                                                                                                                      |
      | { "FG.SerialNo": "10000000004", "SubscriptionId": "88888888-7234-47D1-9860-6BEB866AD8C2", "Date": "1  day ago", "CollectTime": "today 010101", "Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 99,"Previous": 40,"Units": "1/Min"}}]} |
    # Change device
    Given the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000001                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following settings event
      | json                                                                                                                                                                                                                                                                                                                 |
      | {"FG.SerialNo": "10000000003","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today 010101","Date": "1  day ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 50,"Previous": 40,"Units": "1/Min"}}]} |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                      |
      | SETTINGS_EVENT | 10000000003 | DEVICE           | 10000000003               | 36                       | 33                      | {"FG.SerialNo": "10000000003","SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today      010101","Date": "1  day ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 50,"Previous": 40,"Units": "1/Min"}}]} |
    And the following settings events are stored in the cloud
      | json                                                                                                                                                                                                                                                                                                                      |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "8BCAA9C3-7234-47D1-9860-6BEB866AD8C2", "Date": "1  day ago", "CollectTime": "today 010101", "Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 50,"Previous": 40,"Units": "1/Min"}}]} |

  @newport.settings.and.system.event.S5
  @ECO-10769.1 @ECO-10769.2
  Scenario: Received device system event with different time stamps while valid subscription exist.
    # First post from device
    When I send the following system event
      | json                                                                                                                                                                                                                                                      |
      | {"FG.SerialNo": "10000000003","SubscriptionId": "11111111-7234-47D1-9860-6BEB866AD8C2","Date": "2 days ago","CollectTime": "2 days ago 010203","Val.UtcOffset": -120,"Val.SystemEvent": [{"EndDateTime": "2015-11-28T12:43:09","SystemCode": "E-001"}]} |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType      | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                      |
      | SYSTEM_EVENT | 10000000003 | DEVICE           | 10000000003               | 36                       | 33                      | {"FG.SerialNo": "10000000003","SubscriptionId": "11111111-7234-47D1-9860-6BEB866AD8C2","CollectTime": "2 days ago 010203","Date": "2 days ago","Val.UtcOffset": -120,"Val.SystemEvent": [{"EndDateTime": "2015-11-28T12:43:09","SystemCode": "E-001"}]} |
    # Another post from same device in a different day
    When I send the following system event
      | json                                                                                                                                                                                                                                                 |
      | {"FG.SerialNo": "10000000003","SubscriptionId": "11111111-7234-47D1-9860-6BEB866AD8C2","Date": "1  day ago","CollectTime": "today 010101","Val.UtcOffset": -120,"Val.SystemEvent": [{"EndDateTime": "2015-11-28T12:43:09","SystemCode": "E-002"}]} |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType      | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                 |
      | SYSTEM_EVENT | 10000000003 | DEVICE           | 10000000003               | 36                       | 33                      | {"FG.SerialNo": "10000000003","SubscriptionId": "11111111-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today 010101","Date": "1  day ago","Val.UtcOffset": -120,"Val.SystemEvent": [{"EndDateTime": "2015-11-28T12:43:09","SystemCode": "E-002"}]} |
    # Yet another post in same session date but with different collect time
    When I send the following system event
      | json                                                                                                                                                                                                                                                 |
      | {"FG.SerialNo": "10000000003","SubscriptionId": "11111111-7234-47D1-9860-6BEB866AD8C2","Date": "1  day ago","CollectTime": "today 010130","Val.UtcOffset": -120,"Val.SystemEvent": [{"EndDateTime": "2015-11-28T12:43:09","SystemCode": "E-003"}]} |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType      | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                 |
      | SYSTEM_EVENT | 10000000003 | DEVICE           | 10000000003               | 36                       | 33                      | {"FG.SerialNo": "10000000003","SubscriptionId": "11111111-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today 010130","Date": "1  day ago","Val.UtcOffset": -120,"Val.SystemEvent": [{"EndDateTime": "2015-11-28T12:43:09","SystemCode": "E-003"}]} |
    # Another post having duplicated time stamps to the one above, with different content. This one shall not be stored.
    When I send the following system event
      | json                                                                                                                                                                                                                                                |
      | {"FG.SerialNo": "10000000003","SubscriptionId": "11111111-7234-47D1-9860-6BEB866AD8C2","Date": "1  day ago","CollectTime": "today 010130","Val.UtcOffset": 100,"Val.SystemEvent": [{"EndDateTime": "2015-11-28T12:43:09","SystemCode": "E-123"}]} |
    Then I should receive a server ok response
    And no device data received events have been published
    And the following system events are stored in the cloud
      | json                                                                                                                                                                                                                                                           |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "11111111-7234-47D1-9860-6BEB866AD8C2", "Date": "2 days ago", "CollectTime": "2 days ago 010203","Val.UtcOffset": -120,"Val.SystemEvent": [{"EndDateTime": "2015-11-28T12:43:09","SystemCode": "E-001"}]}  |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "11111111-7234-47D1-9860-6BEB866AD8C2", "Date": "1  day ago", "CollectTime": "today      010101", "Val.UtcOffset": -120,"Val.SystemEvent": [{"EndDateTime": "2015-11-28T12:43:09","SystemCode": "E-002"}]} |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "11111111-7234-47D1-9860-6BEB866AD8C2", "Date": "1  day ago", "CollectTime": "today      010130", "Val.UtcOffset": -120,"Val.SystemEvent": [{"EndDateTime": "2015-11-28T12:43:09","SystemCode": "E-003"}]} |

  @newport.settings.and.system.event.S6
  @ECO-10769.2
  Scenario: Received device system event that failed to meet subscription template or failed to find a matching subscription
   # Referring to "11111111-7234-47D1-9860-6BEB866AD8C2" subscription, which requires "SystemCode"
    When I send the following system event
      | json                                                                                                                                                                                                                          |
      | {"FG.SerialNo": "10000000003","SubscriptionId": "11111111-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today 010101","Date": "1  day ago","Val.UtcOffset": -120, "Val.SystemEvent": [{"EndDateTime": "2015-11-28T12:43:09"}]} |
    Then I should receive a server ok response
    And no device data received events have been published
    And the server sends the message to invalid system event queue
      | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason                                                                                                                                                                                                                                                                                                                                 |
      | FIELD_VALIDATION    | SYSTEM_EVENT_FIELD    | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/definitions.json#","pointer":"/systemEventItem"},"instance":{"pointer":"/Val.SystemEvent/0"},"domain":"validation","keyword":"required","message":"missing required property(ies)","required":["EndDateTime","SystemCode"],"missing":["SystemCode"]} ] } |
    And no system events are stored in the cloud for serial number "10000000003"
    # Referring to "99999999-7234-47D1-9860-6BEB866AD8C2" subscription, which is non-existing
    When I send the following system event
      | json                                                                                                                                                                                                                          |
      | {"FG.SerialNo": "10000000003","SubscriptionId": "99999999-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today 010101","Date": "1  day ago","Val.UtcOffset": -120, "Val.SystemEvent": [{"EndDateTime": "2015-11-28T12:43:09"}]} |
    Then I should receive a server ok response
    And no device data received events have been published
    And the server sends the message to invalid system event queue
      | ValidationVetoPoint     | ValidationFailureType | ValidationFailureReason       |
      | SUBSCRIPTION_VALIDATION | SUBSCRIPTION_FIELD    | Subscription not found        |
    And no system events are stored in the cloud for serial number "10000000003"

  @newport.settings.and.system.event.S7
  @ECO-13276.8
  Scenario: Device settings event from a suspended device should change status to active
    Given the communication module with serial number "10000000001" has suspended status for 1 days
    When I send the following settings event
      | json                                                                                                                                                                                                                                                                                                                 |
      | {"FG.SerialNo": "10000000003","SubscriptionId": "ABCDEFAB-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today 010101","Date": "1  day ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 50,"Previous": 40,"Units": "1/Min"}}]} |
    Then the communication module with serial number "10000000001" should eventually have a status of "ACTIVE" within 5 seconds

  @newport.settings.and.system.event.S8
  @ECO-13276.9
  Scenario: System settings event from a suspended device should change status to active
    Given the communication module with serial number "10000000001" has suspended status for 1 days
    When I send the following system event
      | json                                                                                                                                                                                                                                                      |
      | {"FG.SerialNo": "10000000003","SubscriptionId": "11111111-7234-47D1-9860-6BEB866AD8C2","Date": "2 days ago","CollectTime": "2 days ago 010203","Val.UtcOffset": -120,"Val.SystemEvent": [{"EndDateTime": "2015-11-28T12:43:09","SystemCode": "E-001"}]} |
    Then the communication module with serial number "10000000001" should eventually have a status of "ACTIVE" within 5 seconds
