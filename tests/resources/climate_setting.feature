@climate.setting
@ECO-5733
@ECO-13276

Feature:
  (@ECO-5733) As a user
   I want received Newport patient interface data to be stored when it is received
   In order that it can be used users or others when needed.

  (ECO-13276) As the Machine Portal,
   I want to update a Suspended Cellular Module state to Activated when a message is received
   so that I known when the last communication occurred


  # ACCEPTANCE CRITERIA: (ECO-5733)
  # 1. When patient interface data is received from a Newport device then the data shall be stored in the Cloud DB.
  # 2. When data is received from a device for a day for which there is already data for a day then it shall be possible to determine the most recent data using the Collect Time. Note: this implies that all versions of the data for a day are stored.
  #
  # Note 1: It is not necessary for a patient to have been created in ECO that is associated with the device in order to store the data.
  # Note 2: Patient interface data will usually be sent once per day if changed by the device. This means that the most recently received data continues to apply to subsequent days unless new data is received.

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
      Given the server bulk load the following devices and modules
         | /data/manufacturing/batch_new_fg2007_cam2007.xml |
      And manufacture verify the status of the job
         | status           |
         | COMPLETE-SUCCESS |
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 20070811225               | 20070811225                     |
      And I am a device with the FlowGen serial number "20070811225"
      And I send the following registration
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
         | { "FG": {"SerialNo": "20070811225", "Software": "SX567-0302", "MID": 36, "VID": 25, "PCBASerialNo": "(90)R370-7341(91)2(21)4Z242783", "ProductCode": "37036", "Configuration": "CX036-025-013-024-102-100-100" }, "CAM": {"SerialNo": "20070811225", "Software": "SX558-0308", "PCBASerialNo": "13152G00010", "Subscriptions": [ "30B59434-BF4F-4788-9678-A00FF860C038", "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "018A5655-81C6-4888-A2AD-6480087BE395", "2896C763-FE94-4B3F-AD6C-305583FD4210", "21C219CD-EB66-43E7-B677-50E858BB851B", "28D54873-A79C-47A5-A08F-D55D979418F0", "23268714-645A-4A38-85C3-AE691D62907A", "2B04744B-1676-42DE-97ED-199205723183", "24208A76-16A4-427E-BBCF-149A49D9623E", "24208A76-16A4-427E-BBCF-179A49D9718B", "24208A76-16A4-427E-BBCF-179A49D3564C", "2C7CF86E-4E4C-4AEF-97D1-407D23FA9245", "2DD86205-45B5-4023-84D6-40772455902C", "2E30A610-741A-465D-AF65-299CD62BBB1A", "2FADA80D-8094-491C-9481-3CCC471F0372", "12A64E97-6E6F-4C18-A78D-7844A827BF28", "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "1C166B19-01FA-4D7D-A825-A25682C7CB0C", "1D1771B2-890B-4576-8863-FC8559C03040" ] }, "Hum": {"Software": "SX556-0203"} } |

  @climate.setting.S1
  @ECO-5733.1
   Scenario: Store climate settings data for multiple session dates
      Given these devices have the following climate settings
         | json                                                                                                                                                                                                                                                                                                                                       |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 5, "Val.TempEnable": "Off", "Val.Temp": 28, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "2 days ago", "CollectTime": "1 days ago 112039", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 8, "Val.TempEnable": "On",  "Val.Temp": 23, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "1 day ago",  "CollectTime": "today      094703", "Val.ClimateControl": "Auto", "Val.HumEnable": "Off", "Val.HumLevel": 6, "Val.TempEnable": "Off", "Val.Temp": 25, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |
      When I send the climate settings from 3 days ago
      Then I should receive a server ok response
      And the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
         | CLIMATE_SETTING                | 20070811225 | DEVICE           | 20070811225               | 36                       | 25                      | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 5, "Val.TempEnable": "Off", "Val.Temp": 28, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |
      When I send the climate settings from 2 days ago
      Then I should receive a server ok response
      And the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
         | CLIMATE_SETTING                | 20070811225 | DEVICE           | 20070811225               | 36                       | 25                      | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "2 days ago", "CollectTime": "1 days ago 112039", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 8, "Val.TempEnable": "On",  "Val.Temp": 23, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |
      When I send the climate settings from 1 days ago
      Then I should receive a server ok response
      And the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
         | CLIMATE_SETTING                | 20070811225 | DEVICE           | 20070811225               | 36                       | 25                      | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "1 day ago",  "CollectTime": "today      094703", "Val.ClimateControl": "Auto", "Val.HumEnable": "Off", "Val.HumLevel": 6, "Val.TempEnable": "Off", "Val.Temp": 25, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |
      Then the following climate settings are stored in the cloud
         | json                                                                                                                                                                                                                                                                                                                                       |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 5, "Val.TempEnable": "Off", "Val.Temp": 28, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "2 days ago", "CollectTime": "1 days ago 112039", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 8, "Val.TempEnable": "On",  "Val.Temp": 23, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "1 day ago",  "CollectTime": "today      094703", "Val.ClimateControl": "Auto", "Val.HumEnable": "Off", "Val.HumLevel": 6, "Val.TempEnable": "Off", "Val.Temp": 25, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |

  @climate.setting.S2
  @ECO-5733.2
   Scenario: Store climate settings data for single session date, multiple collect times
      When I send the following climate settings
         | json                                                                                                                                                                                                                                                                                                                                        |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 5, "Val.TempEnable": "Off", "Val.Temp": 28, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" }  |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "3 days ago", "CollectTime": "2 days ago 141302", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 5, "Val.TempEnable": "Off", "Val.Temp": 28, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "Off" } |
      Then the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                        |
         | CLIMATE_SETTING                | 20070811225 | DEVICE           | 20070811225               | 36                       | 25                      | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 5, "Val.TempEnable": "Off", "Val.Temp": 28, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" }  |
         | CLIMATE_SETTING                | 20070811225 | DEVICE           | 20070811225               | 36                       | 25                      | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "3 days ago", "CollectTime": "2 days ago 141302", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 5, "Val.TempEnable": "Off", "Val.Temp": 28, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "Off" } |
      Then the following climate settings are stored in the cloud
         | json                                                                                                                                                                                                                                                                                                                                        |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 5, "Val.TempEnable": "Off", "Val.Temp": 28, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" }  |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "3 days ago", "CollectTime": "2 days ago 141302", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 5, "Val.TempEnable": "Off", "Val.Temp": 28, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "Off" } |

   @climate.setting.S3
   @ECO-13276.3
   Scenario: Climate setting event from a suspended device should change status to active
      Given the communication module with serial number "20070811225" has suspended status for 0 days
      When I send the following climate settings
         | json                                                                                                                                                                                                                                                                                                                                        |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 5, "Val.TempEnable": "Off", "Val.Temp": 28, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" }  |
     Then the communication module with serial number "20070811225" should eventually have a status of "ACTIVE" within 5 seconds

  @climate.setting.S4
  @ECO-5733.1
  Scenario: Store climate settings acknowledgements data for multiple session dates
    Given these devices have the following climate settings
      | json                                                                                                                                                                                                                                                                                                                                       |
      | { "FG.SerialNo": "20070811225", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Set.ClimateControl": "Auto", "Set.HumEnable": "On",  "Set.HumLevel": 5, "Set.TempEnable": "Off", "Set.Temp": 28, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
      | { "FG.SerialNo": "20070811225", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "2 days ago", "CollectTime": "1 days ago 112039", "Set.ClimateControl": "Auto", "Set.HumEnable": "On",  "Set.HumLevel": 8, "Set.TempEnable": "On",  "Set.Temp": 23, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
      | { "FG.SerialNo": "20070811225", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "1 day ago",  "CollectTime": "today      094703", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
    When I send the climate settings from 3 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                       |
      | CLIMATE_SETTING_ACKNOWLEDGMENT | 20070811225 | DEVICE           | 20070811225               | 36                       | 25                      | { "FG.SerialNo": "20070811225", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Set.ClimateControl": "Auto", "Set.HumEnable": "On",  "Set.HumLevel": 5, "Set.TempEnable": "Off", "Set.Temp": 28, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
    When I send the climate settings from 2 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                       |
      | CLIMATE_SETTING_ACKNOWLEDGMENT | 20070811225 | DEVICE           | 20070811225               | 36                       | 25                      | { "FG.SerialNo": "20070811225", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "2 days ago", "CollectTime": "1 days ago 112039", "Set.ClimateControl": "Auto", "Set.HumEnable": "On",  "Set.HumLevel": 8, "Set.TempEnable": "On",  "Set.Temp": 23, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
    When I send the climate settings from 1 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                       |
      | CLIMATE_SETTING_ACKNOWLEDGMENT | 20070811225 | DEVICE           | 20070811225               | 36                       | 25                      | { "FG.SerialNo": "20070811225", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "1 day ago",  "CollectTime": "today      094703", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
    Then the following climate settings acknowledgements are stored in the cloud
      | json                                                                                                                                                                                                                                                                                                                                       |
      | { "FG.SerialNo": "20070811225", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Set.ClimateControl": "Auto", "Set.HumEnable": "On",  "Set.HumLevel": 5, "Set.TempEnable": "Off", "Set.Temp": 28, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
      | { "FG.SerialNo": "20070811225", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "2 days ago", "CollectTime": "1 days ago 112039", "Set.ClimateControl": "Auto", "Set.HumEnable": "On",  "Set.HumLevel": 8, "Set.TempEnable": "On",  "Set.Temp": 23, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
      | { "FG.SerialNo": "20070811225", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "1 day ago",  "CollectTime": "today      094703", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
