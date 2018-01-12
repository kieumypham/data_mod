@therapy.summary
@ECO-5222
@ECO-5876
@ECO-13276

Feature:
  (ECO-5222) As a user
  I want received Newport therapy device summary data to be stored when it is received
  so that it can be used by ECO users or others when needed.

  (ECO-5876) As a Hawkesbury user or a technical services user
  I want the 70 percentile Leak and technical service data to be received from Newport devices.

  (@ECO-10173) As a clinical user
  I want to add a Astral 100 device to a patient
  so that I can monitor my patient's therapy.

  (ECO-13276) As the Machine Portal,
   I want to update a Suspended Cellular Module state to Activated when a message is received
   so that I known when the last communication occurred

  # ACCEPTANCE CRITERIA: (ECO-5222)
  # 1. When summary data is received from an AutoSet for Her device then the data shall be stored
  #    (includes patient interface data received with summary data from ECO-4847).
  # 2. When data is received from a device for a day for which there is already data for a day
  #    then it shall be possible to determine the most recent data using the Collect Time.
  #    Note: this implies that all versions of the data for a day are stored.
  # Note 1: It is not necessary for a patient to have been created in ECO that is associated with the device in order to store the data.
  # Note 2: Newport summary data is listed in ECO-4768 and ECO-4847 and the "S10 Models baseline" at http://confluence.corp.resmed.org/x/N4Nj
  # Note 3: It is likely that not all summary data is received each time. In particular, summary data received from the device may be only the data that is relevant for the mode

  # ACCEPTANCE CRITERIA: (ECO-5876)
  # 1. The following items shall be able to be received and stored from Newport AutoSet for Her (VID 25), AutoSet Comfort (VID 26) and AutoSet (VID 1) devices in posts of summary data:
  # 1a. Val.Leak.70
  # 1b. Val.HTubePow.50
  # 1c. Val.HumPow.50
  # Note 1: The data is not required at the ECO UI. The Leak.70 is needed for Hawkesbury and the Humidifier and Heated Tube powers are needed for the technical services application which accesses data via ECX2.

  # ACCEPTANCE CRITERIA: (ECO-10173)
  #  Note 1: For supported data items refer to https://objective.resmedglobal.com/id:A2590135/document/versions/19.5 or see attached Excel workbook.
  #  Note 2: CAL metadata needs to be updated for this VID using the attached xml. See ECO-6726.
  #  Note 3: CamSim should be updated as per ECO-10545.
  #  Note 4: Astral USB MSD will not be supported in AirView. Only wireless data is available for Astral devices.
  #  Note 5: The default mode for this device is ACV.
  #  Note 6: This VID supports 2 programs and as such data for both programs will eventually need to be requested and stored.  However, for the purposes of this card, ignore the programs and just receive data for the single program.  Also, for the purposes of this card, the program number does not need to be stored in the database.
  #
  #  1. Users shall be able to add an Astral 100 (MID30, VID5) to new or existing patients and receive data from the device as per ECO-7292.
  #
  #  Note 7: Normally, product display name is specified however it is now expected that the name displayed is read off the device (node PNA).  Default name for this variant is Astral 100.
  #  Note 8: US Product Code is 27007 and EU Product Code 27011.
  #  Note 9: Device image is attached.
  #
  #  2. Users shall be able to generate excel exports for an Astral 100 (MID30, VID5) device as per ECO-7295.
  #  3. Incoming data from an Astral 100 (MID30, VID5) device shall be validated as per ECO-7296.
  #
  #  Note 10: Astral devices do NOT support settings changes. Hiding the settings change links is covered in ECO-10499.
  #  Note 11: Incoming alarm logs from Astral 100 (MID30, VID5) device will be stored as per ECO-9545.
  #  Note 12: Incoming alarm related settings from Astral 100 (MID 30, VID5) device will be stored as per ECO-9545.
  #  Note 13: The ACs in the generic stories (ECO-7292 - ECO-7296) have been updated to reflect the Lumis, Stellar and Astral platforms. These ACs will need to be updated in feature files where they are present.

  #  ACCEPTANCE CRITERIA: (ECO-13276)
  #  A Suspended Cellular Module will be updated to Activated when:
  #  1. A Registration is received
  #  2. An Alarm Setting is received
  #  3. A Climate Setting is received
  #  4. A Device Alarm is received
  #  5. A Device Erasure is received
  #  6. A Device Fault is received
  #  7. A Device Log is received
  #  8. A Settings Event is received
  #  9. A System Event is received
  #  10. A Therapy Detail is received
  #  11. A Therapy Setting is received
  #  12. A Therapy Summary is received

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
      | { "FG": {"SerialNo": "20080811223", "Software": "SX567-0302", "MID": 36, "VID": 26, "PCBASerialNo":"(90)R370-7341(91)2(21)4Z244018", "ProductCode":"37067", "Configuration": "CX036-026-008-024-101-101-100" }, "CAM": {"SerialNo": "20080811223", "Software": "SX558-0308", "PCBASerialNo":"449000222", "Subscriptions": [ "30B59434-BF4F-4788-9678-A00FF860C038", "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "018A5655-81C6-4888-A2AD-6480087BE3B7", "1D1771B2-890B-4576-8863-FC8559C03040", "12A64E97-6E6F-4C18-A78D-7844A827BF28", "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "1C166B19-01FA-4D7D-A825-A25682C7CB0C", "2896C763-FE94-4B3F-AD6C-305583FD4210", "21C219CD-EB66-43E7-B677-50E858BB851B", "28D54873-A79C-47A5-A08F-D55D979418F0", "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "2B04744B-1676-42DE-97ED-199205723183", "24208A76-16A4-427E-BBCF-149A49D9623E", "24208A76-16A4-427E-BBCF-179A49D9718B", "24208A76-16A4-427E-BBCF-179A49D3564C", "2C7CF86E-4E4C-4AEF-97D1-407D23FA9245", "2DD86205-45B5-4023-84D6-40772455902C", "2E30A610-741A-465D-AF65-299CD62BBB1A", "2FADA80D-8094-491C-9481-3CCC471F0372" ] }, "Hum": {"Software": "SX556-0203"} } |

  @therapy.summary.S1
  @ECO-5222.1
  @ECO-5876.1a @ECO-5876.1b @ECO-5876.1c
  Scenario: Store therapy summary data for multiple session dates
    Given these devices have the following therapy summaries
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "2 days ago", "CollectTime": "1 days ago 102252", "Val.Mode": "CPAP", "Val.Duration": 615, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1215 ], "Val.AHI": 5.8, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "1  day ago", "CollectTime": "today      010101", "Val.Mode": "CPAP", "Val.Duration": 590, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1190 ], "Val.AHI": 5.4, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.0, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
    When I send the therapy summaries from 3 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | THERAPY_SUMMARY | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
    When I send the therapy summaries from 2 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | THERAPY_SUMMARY | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "2 days ago", "CollectTime": "1 days ago 102252", "Val.Mode": "CPAP", "Val.Duration": 615, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1215 ], "Val.AHI": 5.8, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
    When I send the therapy summaries from 1 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | THERAPY_SUMMARY | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "1  day ago", "CollectTime": "today      010101", "Val.Mode": "CPAP", "Val.Duration": 590, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1190 ], "Val.AHI": 5.4, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.0, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
    Then the following therapy summaries are stored in the cloud
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "2 days ago", "CollectTime": "1 days ago 102252", "Val.Mode": "CPAP", "Val.Duration": 615, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1215 ], "Val.AHI": 5.8, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "1  day ago", "CollectTime": "today      010101", "Val.Mode": "CPAP", "Val.Duration": 590, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1190 ], "Val.AHI": 5.4, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.0, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |

  @therapy.summary.S2
  @ECO-5222.2
  @ECO-5876.1a @ECO-5876.1b @ECO-5876.1c
  Scenario: Store therapy summary data for single session date, multiple collect times
    When I send the following therapy summaries
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "3 days ago", "CollectTime": "2 days ago 141302", "Val.Mode": "CPAP", "Val.Duration": 615, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1215 ], "Val.AHI": 5.8, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
    Then the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | THERAPY_SUMMARY | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
      | THERAPY_SUMMARY | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "3 days ago", "CollectTime": "2 days ago 141302", "Val.Mode": "CPAP", "Val.Duration": 615, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1215 ], "Val.AHI": 5.8, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
    Then the following therapy summaries are stored in the cloud
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "3 days ago", "CollectTime": "2 days ago 141302", "Val.Mode": "CPAP", "Val.Duration": 615, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1215 ], "Val.AHI": 5.8, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |

  @therapy.summary.S3
  @ECO-10173.3
  Scenario: Accepting therapy summary data from Astral 100 and similar program capable devices (e.g. Astral)
    Given these devices have the following therapy summaries
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Program": 1, "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
    When I send the therapy summaries from 3 days ago
    Then I should receive a server ok response

  @therapy.summary.S4
  @ECO-13276.12
  Scenario: Therapy summary event from a suspended device should change status to active
    Given the communication module with serial number "20080811223" has suspended status for 1 days
    When I send the following therapy summaries
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "3 days ago", "CollectTime": "2 days ago 141302", "Val.Mode": "CPAP", "Val.Duration": 615, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1215 ], "Val.AHI": 5.8, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
    Then the communication module with serial number "20080811223" should eventually have a status of "ACTIVE" within 5 seconds
    # If device is scrapped, should go to DLQ.DeviceDataReceived
    When the communication module with serial number "20080811223" is scrapped
    And I send the following therapy summaries
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
    And the server should log a therapy summaries error with software version headers
      | ValidationVetoPoint       | ValidationFailureType   | ValidationFailureReason   | softwareVersionJson                                                                                                                 | hasSubscriptionJson   |
      |  DEVICE_STATUS_VALIDATION | INVALID_DEVICE_STATUS   | The device is scrapped.   |  {"humidifierSoftwareVersion": "SX556-0203", "commModuleSoftwareVersion": "SX558-0308", "flowGenSoftwareVersion": "SX567-0302"}     | no                    |

