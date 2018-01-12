@therapy.detail
@ECO-6554
@ECO-6557
@ECO-7717
@ECO-13276

Feature:
  (@ECO-6554) As a user
   I want to download detailed data
  so that I can monitor my patient's therapy.

  (ECO-6557) As a clinical user
   I want ECO to receive wireless detailed data from Newport devices
  so that I can monitor my patient's therapy progess

  (ECO-7717) As a clinical user
   I want ECO to receive wireless detailed data from Newport devices
  so that I can monitor my patient's therapy progess

  (ECO-13276) As the Machine Portal,
   I want to update a Suspended Cellular Module state to Activated when a message is received
   so that I known when the last communication occurred


  # ACCEPTANCE CRITERIA: (ECO-6554)
  # 1. ECO shall store Newport wirelessly collected detailed data.
  # Note 1: Data probably to be stored in the hi-cloud database.

  # ACCEPTANCE CRITERIA: (ECO-6557)
  # Note 1: The purpose of this story is to allow some early integration testing with the FG and CAM teams.
  # The server shall receive wireless detailed data from Newport devices for a day (i.e. session).
  # Note 2: Protocol and model details:
  # The protocol including example exchange is specified at http://confluence.corp.resmed.org/display/CA/Night+profile+and+detailed+data
  # Note 3: Identify and subscription validation will be performed. Range checking will be provided by a later card.
  # Note 4: For an unused day the detailed data will not be posted at all.

  # ACCEPTANCE CRITERIA: (ECO-7717)
  # Note 1: This story extends ECO-6557 by updating the system to also receive and process compressed detailed data from Newport devices.
  # Note 2: Refer to the following spike ECO-7149 for guidance on implementation.
  # Note 3: Details of the compression algorithm is specified in D379-215 - Compression Format and Algorithm For JSON Encoded Signals. A copy is attached to spike ECO-7149.
  # Note 4: For an unused day the detailed data will not be posted at all.
  # 1. The server shall receive and process compressed wireless detailed data from Newport devices for a day (i.e. session). Note: This is addition to non-compressed detailed data. See sample detailed data JSON for identification of compressed detailed data. e.g. "RD1".
  # 2. For each day, if any of the compressed wireless detailed data items cannot be processed, then the server shall discard the entire days detailed data. Note: This is consistent with the existing valid/invalid framework. See ECO-5154 and ECO-5012.
  # 2a. The system shall keep sufficient information for diagnosis when an invalid compressed detail data is detected. Note: See recommendations from ECO-7149.

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
         | /data/manufacturing/batch_new_fg2008_cam2008.xml |
      And manufacture verify the status of the job
         | status           |
         | COMPLETE-SUCCESS |
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 20080811223               | 20080811223                     |
      And I am a device with the FlowGen serial number "20080811223"
      And I send the following registration
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
         | { "FG": {"SerialNo": "20080811223", "Software": "SX567-0302", "MID": 36, "VID": 26, "PCBASerialNo":"(90)R370-7341(91)2(21)4Z244018", "ProductCode":"37067", "Configuration": "CX036-026-008-024-101-101-100" }, "CAM": {"SerialNo": "20080811223", "Software": "SX558-0308", "PCBASerialNo":"449000222", "Subscriptions": [ "30B59434-BF4F-4788-9678-A00FF860C038", "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "018A5655-81C6-4888-A2AD-6480087BE3B7", "1D1771B2-890B-4576-8863-FC8559C03040", "12A64E97-6E6F-4C18-A78D-7844A827BF28", "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "1C166B19-01FA-4D7D-A825-A25682C7CB0C", "2896C763-FE94-4B3F-AD6C-305583FD4210", "21C219CD-EB66-43E7-B677-50E858BB851B", "28D54873-A79C-47A5-A08F-D55D979418F0", "23268714-645A-4A38-85C3-AE691D62907A", "2B04744B-1676-42DE-97ED-199205723183", "24208A76-16A4-427E-BBCF-149A49D9623E", "24208A76-16A4-427E-BBCF-179A49D9718B", "24208A76-16A4-427E-BBCF-179A49D3564C", "2C7CF86E-4E4C-4AEF-97D1-407D23FA9245", "2DD86205-45B5-4023-84D6-40772455902C", "2E30A610-741A-465D-AF65-299CD62BBB1A", "2FADA80D-8094-491C-9481-3CCC471F0372" ] }, "Hum": {"Software": "SX556-0203"} } |

  @therapy.detail.S1
  @ECO-6554.1
  @ECO-6557.1
   Scenario: Store therapy detail data for multiple session dates
      Given these devices have the following therapy details
         | json                                                                                                                                                                                                                                                                                                                                                                           |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "2 days ago", "CollectTime": "1 days ago 102252", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -2, -1, 0 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 6, 5, 4 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] }  |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "1 day ago",  "CollectTime": "today 010101",      "Val.Leak.1m": [ { "StartTime": 540, "Values": [ 1, 2, 3 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 3, 2, 1 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] }    |
      When I send the therapy details from 3 days ago
      Then I should receive a server ok response
      And the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
         | THERAPY_DETAIL                 | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } |
      When I send the therapy details from 2 days ago
      Then I should receive a server ok response
      And the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
         | THERAPY_DETAIL                 | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "2 days ago", "CollectTime": "1 days ago 102252", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -2, -1, 0 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 6, 5, 4 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } |
      When I send the therapy details from 1 days ago
      Then I should receive a server ok response
      And the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
         | THERAPY_DETAIL                 | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "1 day ago",  "CollectTime": "today 010101",      "Val.Leak.1m": [ { "StartTime": 540, "Values": [ 1, 2, 3 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 3, 2, 1 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } |
      Then the following therapy details are stored in the cloud
         | json                                                                                                                                                                                                                                                                                                                                                                           |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "2 days ago", "CollectTime": "1 days ago 102252", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -2, -1, 0 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 6, 5, 4 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] }  |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "1 day ago",  "CollectTime": "today 010101",      "Val.Leak.1m": [ { "StartTime": 540, "Values": [ 1, 2, 3 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 3, 2, 1 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] }    |

  @therapy.detail.S2
  @ECO-6554.1
  @ECO-6557.1
   Scenario: Store therapy detail data for single session date, multiple collect times
      When I send the following therapy details
         | json                                                                                                                                                                                                                                                                                                                                                                                  |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] }        |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 141302", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3, -2 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7, 8 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } |
      Then the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                  |
         | THERAPY_DETAIL                 | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] }        |
         | THERAPY_DETAIL                 | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 141302", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3, -2 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7, 8 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } |
      Then the following therapy details are stored in the cloud
         | json                                                                                                                                                                                                                                                                                                                                                                                  |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] }        |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 141302", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3, -2 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7, 8 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } |

  @therapy.detail.S3
  @ECO-6554.1
   Scenario: Therapy detail with same serial number, session date, and collect time but unique JSON gets logged
      When I send the following therapy details
         | json                                                                                                                                                                                                                                                                                                                                                                                  |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] }        |
      Then the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                  |
         | THERAPY_DETAIL                 | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] }        |
      And the following therapy details are stored in the cloud
         | json                                                                                                                                                                                                                                                                                                                                                                                  |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] }        |
      When I send the following therapy details
         | json                                                                                                                                                                                                                                                                                                                                                                                  |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3, -2 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7, 8 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } |
      Then the server should log the following duplicate key but unique content therapy details error
         | json                                                                                                                                                                                                                                                                                                                                                                                  |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3, -2 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7, 8 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } |
      And no device data received events have been published
      And the following therapy details are stored in the cloud
         | json                                                                                                                                                                                                                                                                                                                                                                                  |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] }        |

  @therapy.detail.S4
  @ECO-6554.1
  @ECO-7717.1
   Scenario Outline: Therapy Detail service responds with OK and is able to decoded data
      When I send the following therapy details
         | json          | contentEncoding |
         | <encodedJson> | resdelta        |
      Then I should receive a server ok response
      And the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json          |
         | THERAPY_DETAIL                 | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | <decodedJson> |
      Then the following therapy details are stored in the cloud
         | json          |
         | <decodedJson> |
      Examples:
         | encodedJson                                                                                                                                                                                                                                                                                                                                                                                                                                                  | decodedJson                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
         | { "FG.SerialNo": "20080811223", "SubscriptionId":"018A5655-81C6-4888-A2AD-6480087BE3B7", "Date":"1 day ago",  "CollectTime":"today 090100",      "Val.Leak.1m": [ { "StartTime": 540, "Values": "RD1:%hgggiiiii" } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": "RD1:%iggzjghi*Dhigi*Dhi*Dhighh*Tgjgj*Jgfggh*Ggf*Egi*Egf*Igf*Fgf*Hgih*Egf*Jgfh*Egh*Dgf*Gg" } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } | { "FG.SerialNo": "20080811223", "SubscriptionId":"018A5655-81C6-4888-A2AD-6480087BE3B7", "Date":"1 day ago",  "CollectTime":"today 090100",      "Val.Leak.1m": [ { "StartTime": 540, "Values": [ 0, 1, 2, 3, 4, 5 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [4.75, 5.5, 5.5, 5.75, 6.25, 6.5, 6.75, 7, 7.5, 7.5, 8, 8.25, 8.5, 8.75, 9.25, 9.5, 9.75, 10, 10.5, 10.5, 10.75, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11.75, 11.75, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.25, 12.25, 12.25, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.25, 12.25, 12.25, 12.25, 12.25, 12.75, 12.75, 12.75, 12.75, 12.75, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.25, 12.25, 12.25, 12.25, 12.25, 12.25, 12, 12, 12, 12, 12, 12, 12, 12, 12.5, 12.75, 12.75, 12.75, 12.75, 12.75, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.25, 12.5, 12.5, 12.5, 12.5, 12.5, 12.75, 12.75, 12.75, 12.75, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5, 12.5] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } |

  @therapy.detail.S5
  @ECO-7717.2 @ECO-7717.2a
   Scenario: Therapy Detail service responds with OK but is unable to decode data
      When I send the following therapy details
         | contentEncoding | json                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
         | resdelta        | { "FG.SerialNo": "20080811223", "SubscriptionId":"018A5655-81C6-4888-A2AD-6480087BE3B7", "Date":"1 day ago",  "CollectTime":"today 090100",      "Val.Leak.1m": [ { "StartTime": 540, "Values": "%hgggiiiii" } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": "RD1:%iggzjghi*Dhigi*Dhi*Dhighh*Tgjgj*Jgfggh*Ggf*Egi*Egf*Igf*Fgf*Hgih*Egf*Jgfh*Egh*Dgf*Gg" } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } |
      Then I should receive a server ok response
      And the server should log a therapy details error
        | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason                                                                                                                                                                                                                                                                                                                                                  |
        | FIELD_VALIDATION    | THERAPY_DETAIL_FIELD  | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/definitions.json#","pointer":"/definitions/flowPerSecondValueArray"},"instance":{"pointer":"/Val.Leak.1m/0/Values"},"domain":"validation","keyword":"type","message":"instance type does not match any allowed primitive type","expected":["array"],"found":"string"} ] } |
      And no device data received events have been published
      And no therapy details are stored in the cloud for serial number "20080811223"

  @therapy.detail.S6
  @ECO-13276.10
  Scenario: Therapy detail event from a suspended device should change status to active
    Given the communication module with serial number "20080811223" has suspended status for 1 days
    When I send the following therapy details
      | json                                                                                                                                                                                                                                                                                                                                                                                  |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] }        |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 141302", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3, -2 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7, 8 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } |
    Then the communication module with serial number "20080811223" should eventually have a status of "ACTIVE" within 5 seconds
