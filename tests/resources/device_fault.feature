@device.fault
@ECO-4850
@ECO-5235
@ECO-5588
@ECO-5874
@ECO-6460
@ECO-6553
@ECO-6734
@ECO-6746
@ECO-6758
@ECO-6969
@ECO-7292
@ECO-7298
@ECO-13276

Feature:
  (ECO-4850) As a clinical user
   I want to be able to see the device faults
   so I can troubleshoot patient service difficulties

  (@ECO-5235) As a user
   I want received Newport therapy device fault data to be stored when it is received
   In order that it can be used by ECO users or others when needed.

  (@ECO-5588) As a user
   I want received Newport therapy device
  summary data and settings to be stored when it is received
  so that it can be used by ECO users or others when needed.

  (ECO-5874) As ECO
   I want data received by NGCS to be validated against the subscription for the data
   to prevent rubbish data entering the system

  (@ECO-6460) As a user
   I want received Newport therapy device summary data and settings to be stored when it is received
  so that it can be used by ECO users or others when needed.

  (@ECO-6553) As a user
   I want received Newport therapy device summary data and settings to be stored when it is received
  so that it can be used by ECO users or others when needed.

  (@ECO-6734) As a user
   I want received Newport therapy device summary data and settings to be stored when it is received
  so that it can be used by ECO users or others when needed.

  (@ECO-6746) As a user
   I want received Newport therapy device summary data and settings to be stored when it is received
  so that it can be used by ECO users or others when needed.

  (@ECO-6758) As a user
   I want received Newport therapy device summary data and settings to be stored when it is received
  so that it can be used by ECO users or others when needed.

  (@ECO-6969) As a user
   I want received Newport therapy device summary data and settings to be stored when it is received
  so that it can be used by ECO users or others when needed.

  (@ECO-7292) As a user
   I want received Newport therapy device summary data and settings to be stored when it is received
  so that it can be used by ECO users or others when needed

  (@ECO-7298) As a clinical user
   I want to add an Vauto Germany device to a patient
  so that I can monitor my patient's therapy

  (ECO-13276) As the Machine Portal,
   I want to update a Suspended Cellular Module state to Activated when a message is received
   so that I known when the last communication occurred


  # ACCEPTANCE CRITERIA: (ECO-4850)
  # Note 1: The term "server" shall be used interchangeably with NGCS.
  # 1. The server shall receive the device fault data for a day from the S10 devices.
  # 2. The server shall forward the device identification, the session date and fault data for the day to an HI Cloud API.
  # Note 2: No authentication of the therapy device is necessary (i.e no need to know the authentication key or to check the MD5 checksum if present.
  # Note 3: Protocol and model details:
  # The protocol is specified at http://confluence.corp.resmed.org/display/CA/Faults
  # Note 3: Example subscription JSON is as follows:
  # {
  # "CollectTime": "20130430 140302",
  # "SubscriptionId": "Faults",
  # "Date": "20130429",
  # "Fault.Device": [],
  # "Fault.Humidifier": [3, 4],
  # "Fault.HeatedTube": [10]
  # }

  # ACCEPTANCE CRITERIA: (ECO-5235)
  # 1. When fault data is received from an AutoSet for Her device then the data shall be stored in the Cloud DB.
  # 2. When data is received from a device for a day for which there is already data for a day then it shall be possible to determine the most recent data using the Collect Time. Note: this implies that all versions of the data for a day are stored.
  # Note 1: It is not necessary for a patient to have been created in ECO that is associated with the device in order to store the data.
  # Note 2: Fault data will usually be sent once per day if changed by the device. This means that the most recently received data continues to apply to subsequent days unless new data is received.
  # Note 3: Newport device fault data is listed in ECO-4850 and the "S10 Models baseline" at http://confluence.corp.resmed.org/x/N4Nj

  # ACCEPTANCE CRITERIA: (ECO-5588)
  # 1. When wireless summary data is received from an S10 Elite device (MID 36 VID 2) then the data shall be stored (includes patient interface data received with summary data from ECO-4847).
  # 2. When wireless settings data is received from an S10 Elite device (MID 36 VID 2) then the data shall be stored (includes patient interface as well as therapy settings).
  # 3. When wireless fault data is received from an S10 Elite device (MID 36 VID 2) then the data shall be stored.
  # Note 1: This story extends ECO-5222 Store summary AfH and ECO-5234 Store settings AfH to include a extra device S10 Elite.
  # Note 2: Summary data and settings for the S10 Elite is as specified in D2225-010 or the "S10 Models baseline" at http://confluence.corp.resmed.org/x/N4Nj
  # Note 3: Summary data is the same as the AfH with the following exceptions: 1) Only has CPAP mode. 2) No RERA (RDI)
  # Note 4: Settings data is the same as the AfH except only has CPAP mode.

  # ACCEPTANCE CRITERIA: (ECO-5874)
  # Note 1: This story corresponds to part of the processing in Step 4 Subscription comparison on https://confluence.ec2.local/x/q4yeAQ
  # 1. Any messages containing data or settings received from Newport devices shall be prevented from being placed on the valid message queue if the message does not correspond to a known subscription.
  # 2. Any message containing data items that are not listed in the subscription shall be shall be prevented from being placed on the valid message queue.
  # 3. A configurable property shall be available that can disable or enable the validation in AC#1 and AC#2 above. Note 2: That is, when the validation is disabled then all messages would be placed on the valid message queue even if the message did not correspond to a known subscription.
  # Note 3: For reference testing if needed the data needed in the subscriptions for Newport CPL can be found at http://confluence.corp.resmed.org/x/N4Nj in "Subscriptions CPL.txt"

  # ACCEPTANCE CRITERIA: (ECO-6460)
  # Note 1: This story extends ECO-5222 Store summary AfH and ECO-5234 Store settings AfH to include a extra device S10 Escape.
  # 1. When wireless summary data is received from an S10 Escape device (MID 36 VID 3) then the data shall be stored (includes patient interface data received with summary data from ECO-4847).
  # 2. When wireless settings data is received from an S10 Escape device (MID 36 VID 3) then the data shall be stored (includes patient interface as well as therapy settings).
  # 3. When wireless fault data is received from an S10 Escape device (MID 36 VID 3) then the data shall be stored.
  # Note 2: Summary data and settings for the S10 Escape is as specified in D2225-010 or the "S10 Models baseline" at http://confluence.corp.resmed.org/x/N4Nj
  # Note 3: The S10 Escape device is the same as AfH except that it only supports CPAP mode, and only supports leak.95th and AHI (No leak.50, leak.max, AI, HI, RERA, CSR)
  # Note 4: Settings data is the same as the AfH except only has CPAP mode.

  # ACCEPTANCE CRITERIA: (ECO-6553)
  # Note 1: This story extends ECO-5222 Store summary AfH and ECO-5234 Store settings AfH to include an extra device S10 AfH EU.
  # 1. When wireless summary data is received from an S10 AfH EU device (MID 36 VID 34) then the data shall be stored (includes patient interface data received with summary data from ECO-4847).
  # 2. When wireless settings data is received from an S10 AfH EU device (MID 36 VID 34) then the data shall be stored (includes patient interface as well as therapy settings).
  # 3. When wireless fault data is received from an S10 AfH EU device (MID 36 VID 34) then the data shall be stored.
  # Note 2: Summary data and settings for the S10 AfH EU is as specified in D2225-010 or the "S10 Models baseline" at http://confluence.corp.resmed.org/x/N4Nj
  # Note 3: Settings data is the same as VID 25 S10 AfH device, with the addition of the Response setting (ie Comfort setting that is supported by VID 26 S10 AutoSet Comfort) when the device is in AutoSet mode.
  # Note 4: Summary data is the same as VID 25 S10 AfH device.

  # ACCEPTANCE CRITERIA: (ECO-6734)
  # Note 1: This story extends ECO-5222 Store summary AfH and ECO-5234 Store settings AfH to include a extra device S10 VAuto.
  # 1. When wireless summary data is received from an S10 VAuto device (MID 36 VID 9) then the data shall be stored (includes patient interface data received with summary data from ECO-4847).
  # 2. When wireless settings data is received from an S10 VAuto device (MID 36 VID 9) then the data shall be stored (includes patient interface as well as therapy settings).
  # 3. When wireless fault data is received from an S10 VAuto device (MID 36 VID 9) then the data shall be stored.
  # Note 2: Summary data and settings for the S10 VAuto is as specified in D2225-010 (https://objective.resmedglobal.com/id:A2590135/document/versions/11.10)

  # ACCEPTANCE CRITERIA: (ECO-6746)
  # Note 1: This story extends ECO-5222 Store summary AfH and ECO-5234 Store settings AfH to include a extra device S10 VPAPS.
  # 1. When wireless summary data is received from an S10 VPAPS device (MID 36 VID 11) then the data shall be stored (includes patient interface data received with summary data from ECO-4847).
  # 2. When wireless settings data is received from an S10 VPAPS device (MID 36 VID 11) then the data shall be stored (includes patient interface as well as therapy settings).
  # 3. When wireless fault data is received from an S10 VPAPS device (MID 36 VID 11) then the data shall be stored.
  # Note 2: Summary data and settings for the S10 VPAPS is as specified in D2225-010 (https://objective.resmedglobal.com/id:A2590135/document/versions/11.17)

  # ACCEPTANCE CRITERIA: (ECO-6758)
  # Note 1: This story extends ECO-5222 Store summary AfH and ECO-5234 Store settings AfH to include a extra device S10 AutoCS.
  # 1. When wireless summary data is received from an S10 AutoCS device (MID 36 VID 19) then the data shall be stored (includes patient interface data received with summary data from ECO-4847).
  # 2. When wireless settings data is received from an S10 AutoCS device (MID 36 VID 19) then the data shall be stored (includes patient interface as well as therapy settings).
  # 3. When wireless fault data is received from an S10 AutoCS device (MID 36 VID 19) then the data shall be stored.
  # Note 2: Summary data and settings for the S10 AutoCS is as specified in D2225-010 (https://objective.resmedglobal.com/id:A2590135/document/versions/11.17)

  # ACCEPTANCE CRITERIA: (ECO-6969)
  # Note 1: This story extends ECO-5222 Store summary AfH and ECO-5234 Store settings AfH to include a extra device S10 VPAPST.
  # 1. When wireless summary data is received from an S10 VPAPST device (MID 36 VID 12) then the data shall be stored (includes patient interface data received with summary data from ECO-4847).
  # 2. When wireless settings data is received from an S10 VPAPST device (MID 36 VID 12) then the data shall be stored (includes patient interface as well as therapy settings).
  # 3. When wireless fault data is received from an S10 VPAPST device (MID 36 VID 12) then the data shall be stored.
  # Note 2: Summary data and settings for the S10 VPAPST is as specified in D2225-010 (https://objective.resmedglobal.com/id:A2590135/document/versions/11.17)

  # ACCEPTANCE CRITERIA: (ECO-7292)
  # 1. In all countries, all supported Air series devices shall be able to be added to:
  # 1a. new patients
  # 1b. existing patients
  # 2. ECO shall be able to read summary data, detailed data and settings from a card from any supported Air series device and assign the data to a patient.
  # 3. The following data types shall be stored when they are received from any supported Air series device:
  # 3a. Wireless summary data (includes patient interface data received with summary data from ECO-4847)
  # 3b. Wireless settings data (includes patient interface as well as therapy settings)
  # 3c. Wireless fault data
  # 3d. Wireless detailed data

  # ACCEPTANCE CRITERIA: (ECO-7298)
  # Note 1: This device is most similar to VID 9 Vauto Americas.
  # Note 2: For supported data items refer to the D2225-010 document https://objective.resmedglobal.com/id:A2590135/document/versions/12.14
  # Note 3: CAL metadata needs to be updated for this VID using the attached xml. See ECO-6726.
  # Note 4: CamSim should be updated based on supported wireless items in CamSubscriptions.xml
  # Note 5: Example Newport SD card data can be found at https://confluence.ec2.local/x/IoBb
  # Note 6: Newport summary data format on the card can be found at https://confluence.ec2.local/x/WQzj
  # 1. Users shall be able to add a Vauto Germany (MID 36, VID 27) to new or existing patients and receive data from the device as per ECO-7292. Note: US Product Code 07052, Device name displayed should be "AirCurve 10 VAuto". EU Product Code 37052, Device name displayed should be "AirCurve 10 VAuto". Device image is attached.
  # 2. Users shall be able to generate compliance, therapy and detailed reports for Vauto ROE (MID 36, VID 27) devices as per ECO-7293. Note: See attached pdfs. These reports are the same as those implemented in ECO-6731 and ECO-6732 for VID 9.
  # 3. Users shall be able to remotely modify therapy settings for Vauto ROE (MID 36, VID 27) devices as per ECO-7294. Note: Backup Rate Enable (BRE) is available for this device, and is not available in VID 9. This parameter can be ignored for the purpose of this story.
  # 4. Users shall be able to generate excel exports for Vauto ROE (MID 36, VID 27) devices as per ECO-7295. Note: This is a European device, so ECO-7295 AC#2 should be tested.
  # 5. Incoming data from Vauto ROE (MID 36, VID 27) devices shall be validated as per ECO-7296. Note: The backup rate BRR is available in VID 27, and is not available in VID 9. This parameter is currently highlighted on the 010 document pending confirmation from Marketing on whether this needs to be displayed. For the purpose of this story, this parameter can be ignored.

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

  @device.fault.S1 @valid.against.subscription
  @ECO-4850.1 @ECO-4850.2
  @ECO-5235.1
  @ECO-5588.3
  @ECO-5874.1
  @ECO-6460.3
  @ECO-6553.3
  @ECO-6734.3
  @ECO-6746.3
  @ECO-6758.3
  @ECO-6969.3
  @ECO-7292.3c
  @ECO-7298.1
   Scenario Outline:
      When I send the following device faults
         | json   |
         | <json> |
      Then I should receive a server ok response
      And the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
         | DEVICE_FAULT                   | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | <json> |
      Then the following device faults are stored in the cloud
         | json   |
         | <json> |
      Examples:
         | json                                                                                                                                                                                                                          |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "Date": "1 day ago", "CollectTime": "today 140302", "Fault.Device": [ ], "Fault.Humidifier": [ 3, 4 ], "Fault.HeatedTube": [ 10 ] } |

  @device.fault.S2
  @ECO-4850.1 @ECO-4850.2
  @ECO-5235.2
  @ECO-5588.3
  @ECO-5874.1
  @ECO-6460.3
  @ECO-6553.3
  @ECO-6734.3
  @ECO-6746.3
  @ECO-6758.3
  @ECO-6969.3
  @ECO-7292.3c
  @ECO-7298.1
   Scenario: Store device faults data for single session date, multiple collect times
      When I send the following device faults
         | json                                                                                                                                                                                                                                 |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Fault.Device": [  ], "Fault.Humidifier": [ 3, 4 ], "Fault.HeatedTube": [ 10 ] } |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "Date": "3 days ago", "CollectTime": "2 days ago 162957", "Fault.Device": [  ], "Fault.Humidifier": [ 3, 4 ], "Fault.HeatedTube": [  ] }   |
      Then the following device data received events have been published
         | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                 |
         | DEVICE_FAULT                   | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | { "FG.SerialNo": "20080811223", "SubscriptionId": "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Fault.Device": [  ], "Fault.Humidifier": [ 3, 4 ], "Fault.HeatedTube": [ 10 ] } |
         | DEVICE_FAULT                   | 20080811223 | DEVICE           | 20080811223               | 36                       | 26                      | { "FG.SerialNo": "20080811223", "SubscriptionId": "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "Date": "3 days ago", "CollectTime": "2 days ago 162957", "Fault.Device": [  ], "Fault.Humidifier": [ 3, 4 ], "Fault.HeatedTube": [  ] }   |
      Then the following device faults are stored in the cloud
         | json                                                                                                                                                                                                                                 |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Fault.Device": [  ], "Fault.Humidifier": [ 3, 4 ], "Fault.HeatedTube": [ 10 ] } |
         | { "FG.SerialNo": "20080811223", "SubscriptionId": "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "Date": "3 days ago", "CollectTime": "2 days ago 162957", "Fault.Device": [  ], "Fault.Humidifier": [ 3, 4 ], "Fault.HeatedTube": [  ] }   |

  @device.fault.S3
  @ECO-13276.6
  Scenario: Device fault event from a suspended device should change status to active
    Given the communication module with serial number "20080811223" has suspended status for 1 days
    When I send the following device faults
      | json                                                                                                                                                                                                                                 |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Fault.Device": [  ], "Fault.Humidifier": [ 3, 4 ], "Fault.HeatedTube": [ 10 ] } |
      | { "FG.SerialNo": "20080811223", "SubscriptionId": "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "Date": "3 days ago", "CollectTime": "2 days ago 162957", "Fault.Device": [  ], "Fault.Humidifier": [ 3, 4 ], "Fault.HeatedTube": [  ] }   |
    Then the communication module with serial number "20080811223" should eventually have a status of "ACTIVE" within 5 seconds