@device.erasure
@ECO-5884
@ECO-13276

Feature:
  (ECO-5884) As an clinical user
  I only want data copied to a patient since the device was last erased
  so that I do not see data for previous patients

  (ECO-13276) As the Machine Portal,
   I want to update a Suspended Cellular Module state to Activated when a message is received
   so that I known when the last communication occurred

  # ACCEPTANCE CRITERIA: (ECO-5884)
  # 1. The last erase date shall be received from Newport devices and stored.
  # Note 1: The "Erases" interface described at http://confluence.corp.resmed.org/display/CA/Wireless+Protocol should be used for this purpose

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

  @device.erasure.S1
  @ECO-5884.1
   Scenario Outline:
      When I send the following device erasures
         | json   |
         | <json> |
      Then I should receive a server ok response
      And the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
         | DEVICE_ERASURE                 | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | <json> |
      Then the following device erasures are stored in the cloud
         | json   |
         | <json> |
      Examples:
         | json                                                                                                                                                                            |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "Date": "1 day ago", "CollectTime": "today 120000", "Val.LastEraseDate": "2 days ago" } |

  @device.erasure.S2
  @ECO-5884.1
   Scenario: Store device erasures data for single session date, multiple collect times
      When I send the following device erasures
         | json                                                                                                                                                                                    |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LastEraseDate": "4 days ago" } |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "Date": "3 days ago", "CollectTime": "2 days ago 162957", "Val.LastEraseDate": "4 days ago" } |
      Then the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                    |
         | DEVICE_ERASURE                 | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | { "FG.SerialNo": "20080811223", "SubscriptionId": "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LastEraseDate": "4 days ago" } |
         | DEVICE_ERASURE                 | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | { "FG.SerialNo": "20080811223", "SubscriptionId": "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "Date": "3 days ago", "CollectTime": "2 days ago 162957", "Val.LastEraseDate": "4 days ago" } |
      Then the following device erasures are stored in the cloud
         | json                                                                                                                                                                                    |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LastEraseDate": "4 days ago" } |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "Date": "3 days ago", "CollectTime": "2 days ago 162957", "Val.LastEraseDate": "4 days ago" } |

  @device.erasure.S3
  @ECO-13276.5
  Scenario: Device erasure event from a suspended device should change status to active
    Given the communication module with serial number "20080811223" has suspended status for 1 days
    When I send the following device erasures
      | json                                                                                                                                                                                    |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LastEraseDate": "4 days ago" } |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "Date": "3 days ago", "CollectTime": "2 days ago 162957", "Val.LastEraseDate": "4 days ago" } |
    Then the communication module with serial number "20080811223" should eventually have a status of "ACTIVE" within 5 seconds