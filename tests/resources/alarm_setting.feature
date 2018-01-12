@alarm.setting
@ECO-9545
@ECO-13276

Feature:
  (ECO-9545) As a clinical user,
  I would like to access historical alarm logs for my patients once they are made available in AirView
  so that I can manage my patients better.

  (ECO-13276) As the Machine Portal,
  I want to update a Suspended Cellular Module state to Activated when a message is received
  so that I known when the last communication occurred

  # ACCEPTANCE CRITERIA: (ECO-9545)
  # Note 1: This story applies to devices with a subscription for alarm logs and alarm settings.
  # Note 2: Alarm logs will only be sent via CAM. There will be no upload of Alarm logs from SD card.
  # Note 3: For data items relating to alarm logs and alarm related settings, please refer to https://objective.resmedglobal.com/id:A2590135/document/versions/17.4 or see attached Excel workbook.
  # 1. AirView shall be able to accept alarm logs information sent via CAM.
  # 2. AirView shall store the alarm logs to the HI Cloud.
  # 3. AirView shall be able to accept alarm settings sent via CAM.
  # 4. AirView shall store the alarm settings to the HI Cloud.
  # Note 5: Information relating to Alarm Logs will include the date and time when alarm ends, the action which indicates whether the alarms was activated or deactivated and the alarm type.
  # Note 6: For the JSON response, see http://jirapd.corp.resmed.org/browse/NDC-1862.
  # Note 7: At the time of writing this story, only VIDs 45 and 46 support the alarm log and alarm settings subscriptions and as such should be tested by V&V.

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
         | { "FG": {"SerialNo": "20070811225", "Software": "SX567-0302", "MID": 36, "VID": 25, "PCBASerialNo": "(90)R370-7341(91)2(21)4Z242783", "ProductCode": "37036", "Configuration": "CX036-025-013-024-102-100-100" }, "CAM": {"SerialNo": "20070811225", "Software": "SX558-0308", "PCBASerialNo": "13152G00010", "Subscriptions": [ "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "30B59434-BF4F-4788-9678-A00FF860C038", "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "018A5655-81C6-4888-A2AD-6480087BE395", "2896C763-FE94-4B3F-AD6C-305583FD4210", "21C219CD-EB66-43E7-B677-50E858BB851B", "28D54873-A79C-47A5-A08F-D55D979418F0", "23268714-645A-4A38-85C3-AE691D62907A", "2B04744B-1676-42DE-97ED-199205723183", "24208A76-16A4-427E-BBCF-149A49D9623E", "24208A76-16A4-427E-BBCF-179A49D9718B", "24208A76-16A4-427E-BBCF-179A49D3564C", "2C7CF86E-4E4C-4AEF-97D1-407D23FA9245", "2DD86205-45B5-4023-84D6-40772455902C", "2E30A610-741A-465D-AF65-299CD62BBB1A", "2FADA80D-8094-491C-9481-3CCC471F0372", "12A64E97-6E6F-4C18-A78D-7844A827BF28", "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "1C166B19-01FA-4D7D-A825-A25682C7CB0C", "1D1771B2-890B-4576-8863-FC8559C03040" ] }, "Hum": {"Software": "SX556-0203"} } |

  @alarm.setting.S1
  @ECO-9545.3 @ECO-9545.4
   Scenario: Store alarm settings data for multiple session dates
      Given these devices have the following alarm settings
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Program":1, "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" } |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "2 days ago", "CollectTime": "1 days ago 112039", "Program":2, "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "Med" }  |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "1 day ago",  "CollectTime": "today      094703", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "Low" }  |
      When I send the alarm settings from 3 days ago
      Then I should receive a server ok response
      And the following device data received events have been published
        | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
        | ALARM_SETTING                  | 20070811225 | DEVICE           | 20070811225               | 36                       | 25                      | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Program":1, "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" }   |
      When I send the alarm settings from 2 days ago
      Then I should receive a server ok response
      And the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
         | ALARM_SETTING                  | 20070811225 | DEVICE           | 20070811225               | 36                       | 25                      | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "2 days ago", "CollectTime": "1 days ago 112039", "Program":2, "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "Medium" } |
      When I send the alarm settings from 1 days ago
      Then I should receive a server ok response
      And the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
         | ALARM_SETTING                  | 20070811225 | DEVICE           | 20070811225               | 36                       | 25                      | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "1 day ago",  "CollectTime": "today      094703", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "Low" }    |
     Then the following alarm settings are stored in the cloud
        | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
        | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Program":1, "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" }   |
        | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "2 days ago", "CollectTime": "1 days ago 112039", "Program":2, "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "Medium" } |
        | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "1 day ago",  "CollectTime": "today      094703", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "Low" }    |

  @alarm.setting.S2
  @ECO-9545.3 @ECO-9545.4
   Scenario: Store alarm settings data for single session date, multiple collect times
      When I send the following alarm settings
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" }   |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 141302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "Medium" } |
      Then the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
         | ALARM_SETTING                  | 20070811225 | DEVICE           | 20070811225               | 36                       | 25                      | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" }   |
         | ALARM_SETTING                  | 20070811225 | DEVICE           | 20070811225               | 36                       | 25                      | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 141302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "Medium" } |
      Then the following alarm settings are stored in the cloud
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" }   |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 141302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "Medium" } |

  @alarm.setting.S3
  @ECO-9545.3 @ECO-9545.4
   Scenario: Alarm setting with same serial number, session date, and collect time but unique JSON gets logged
      When I send the following alarm settings
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" }   |
      Then the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
         | ALARM_SETTING                  | 20070811225 | DEVICE           | 20070811225               | 36                       | 25                      | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" }   |
      And the following alarm settings are stored in the cloud
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" }   |
      When I send the following alarm settings
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "Medium" } |
      Then the server should log the following device data received error
         | PersistenceVetoPoint         |  json                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
         | DUPLICATE_KEY_UNIQUE_CONTENT |{ "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "Medium" } |
      And no device data received events have been published
      And the following alarm settings are stored in the cloud
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" }   |

  @alarm.setting.S4
  @ECO-9545.3 @ECO-9545.4
   Scenario: Alarm setting with same serial number, session date, collect time, and JSON does not get logged
      When I send the following alarm settings
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" }   |
      Then the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
         | ALARM_SETTING                  | 20070811225 | DEVICE           | 20070811225               | 36                       | 25                      | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" }   |
      And the following alarm settings are stored in the cloud
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" }   |
      When I send the following alarm settings
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" }   |
      Then the server should not log a device data received error
      And no device data received events have been published
      And the following alarm settings are stored in the cloud
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
         | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" }   |

  @alarm.setting.S5
  @ECO-13276.2
  Scenario: Alarm setting event from suspended device should change status to active
    Given the communication module with serial number "20070811225" has suspended status for 0 days
    When I send the following alarm settings
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | { "FG.SerialNo": "20070811225", "SubscriptionId": "E9D6C89A-D54B-4ABD-81C9-2D7EB4F14806", "Date": "4 days ago", "CollectTime": "3 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" }   |
   Then the communication module with serial number "20070811225" should eventually have a status of "ACTIVE" within 5 seconds