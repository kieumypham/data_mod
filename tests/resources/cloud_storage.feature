@cloud.storage
@ECO-5733
@ECO-6554
@ECO-7292
@ECO-5235
@ECO-5588
@ECO-6460
@ECO-6553
@ECO-6734
@ECO-6746
@ECO-6758
@ECO-6969
@ECO-7298
@ECO-5222
@ECO-5876
@ECO-5234
@ECO-5884

Feature:
  (@ECO-5733) As a user
   I want received Newport patient interface data to be stored when it is received
   In order that it can be used users or others when needed.

  (@ECO-6554) As a user
   I want to download detailed data
  so that I can monitor my patient's therapy.

  (@ECO-7292) As a user
   I want received Newport therapy device summary data and settings to be stored when it is received
  so that it can be used by ECO users or others when needed

  (@ECO-5235) As a user
   I want received Newport therapy device fault data to be stored when it is received
   In order that it can be used by ECO users or others when needed.

  (@ECO-5588) As a user
   I want received Newport therapy device
  summary data and settings to be stored when it is received
  so that it can be used by ECO users or others when needed.

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

  (@ECO-7298) As a clinical user
   I want to add an Vauto Germany device to a patient
  so that I can monitor my patient's therapy

  (ECO-5222) As a user
   I want received Newport therapy device summary data to be stored when it is received
  so that it can be used by ECO users or others when needed.

  (ECO-5876) As a Hawkesbury user or a technical services user
   I want the 70 percentile Leak and technical service data to be received from Newport devices.

  (@ECO-5234) As a user
   I want received Newport therapy device settings to be stored when it is received
  so that it can be used by ECO users or others when needed.

  (ECO-5884) As an clinical user
  I only want data copied to a patient since the device was last erased
  so that I do not see data for previous patients

  # ACCEPTANCE CRITERIA: (ECO-5733)
  # 1. When patient interface data is received from a Newport device then the data shall be stored in the Cloud DB.
  # 2. When data is received from a device for a day for which there is already data for a day then it shall be possible to determine the most recent data using the Collect Time. Note: this implies that all versions of the data for a day are stored.
  #
  # Note 1: It is not necessary for a patient to have been created in ECO that is associated with the device in order to store the data.
  # Note 2: Patient interface data will usually be sent once per day if changed by the device. This means that the most recently received data continues to apply to subsequent days unless new data is received.

  # ACCEPTANCE CRITERIA: (ECO-6554)
  # 1. ECO shall store Newport wirelessly collected detailed data.
  # Note 1: Data probably to be stored in the hi-cloud database.

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

  # ACCEPTANCE CRITERIA: (ECO-5234)
  # 1. When settings data is received from an AutoSet for Her device then the data shall be stored (includes patient interface as well as therapy settings).
  # 2. When settings are received from a device for a day for which there are already settings for a day then it shall be possible to determine the most recent settings using the Collect Time. Note: this implies that all versions of the settings for a day are stored.
  # Note 1: It is not necessary for a patient to have been created in ECO that is associated with the device in order to store the data.
  # Note 2: Settings data will usually be sent once per day if changed by the device. This means that the most recently recently received settings continue to apply to subsequent days unless new settings are received.
  # Note 3: Newport settings data is listed in ECO-4689, ECO-4730 and ECO-4860 and the "S10 Models baseline" at http://confluence.corp.resmed.org/x/N4Nj

  # ACCEPTANCE CRITERIA: (ECO-5884)
  # 1. The last erase date shall be received from Newport devices and stored.
  # Note 1: The "Erases" interface described at http://confluence.corp.resmed.org/display/CA/Wireless+Protocol should be used for this purpose

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

  @cloud.storage.S1
  @ECO-5733.1 @ECO-5733.2
  @ECO-5235.1 @ECO-5235.2
  @ECO-5588.3
  @ECO-6460.3
  @ECO-6553.3
  @ECO-6734.3
  @ECO-6746.3
  @ECO-6758.3
  @ECO-6969.3
  @ECO-6554.1
  @ECO-7292.3c @ECO-7292.3d
  @ECO-7298.1
  @ECO-5222.1
  @ECO-5876.1a @ECO-5876.1b @ECO-5876.1c
  @ECO-5234.1
  @ECO-5884.1
   Scenario Outline: Store Newport data in HI Cloud Database
      When I send the following <typeName>
         | json   |
         | <json> |
      Then the following device data received events have been published
         | JMSType   | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | json   |
         | <jmsType> | 20070811225 | DEVICE           | 20070811225               | 36                       | <json> |
      Then the following <typeName> are stored in the cloud
         | json   |
         | <json> |
      Examples:
         | typeName                          | jmsType                        | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
         | climate settings                  | CLIMATE_SETTING                | { "FG.SerialNo": "20070811225", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "1 day ago", "CollectTime": "today 113900", "Val.ClimateControl": "Auto", "Val.HumEnable": "On", "Val.HumLevel": 5, "Val.TempEnable": "Off", "Val.Temp": 28, "Val.Tube": "15mm", "Val.Mask": "Pillows", "Val.SmartStart": "Off" }                                                                                                                                                                                   |
         | device erasures                   | DEVICE_ERASURE                 | { "FG.SerialNo": "20070811225", "SubscriptionId": "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "Date": "1 day ago", "CollectTime": "today 113900", "Val.LastEraseDate": "3 days ago" }                                                                                                                                                                                                                                                                                                                                     |
         | device faults                     | DEVICE_FAULT                   | { "FG.SerialNo": "20070811225", "SubscriptionId": "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "Date": "1 day ago", "CollectTime": "today 113900", "Fault.Device": [], "Fault.Humidifier": [ 3, 4 ], "Fault.HeatedTube": [ 10 ] }                                                                                                                                                                                                                                                                                          |
         | therapy details                   | THERAPY_DETAIL                 | { "FG.SerialNo": "20070811225", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE395", "Date": "1 day ago", "CollectTime": "today 100000", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ 1, 2, 3 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 3, 2, 1 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] }                                                                                                                                                 |
         | therapy settings                  | THERAPY_SETTING                | { "FG.SerialNo": "20070811225", "SubscriptionId": "23268714-645A-4A38-85C3-AE691D62907A", "Date": "1 day ago", "CollectTime": "today 100000", "Val.Mode":"CPAP", "CPAP.Val.StartPress": 6.3, "CPAP.Val.Press": 7.1, "CPAP.Val.EPR.EPREnable": "On", "CPAP.Val.EPR.EPRType": "FullTime", "CPAP.Val.EPR.Level": 1, "CPAP.Val.Ramp.RampEnable": "On", "CPAP.Val.Ramp.RampTime": 5 }                                                                                                                                      |
         | therapy summaries                 | THERAPY_SUMMARY                | { "FG.SerialNo": "20070811225", "SubscriptionId": "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "Date": "1 day ago", "CollectTime": "today 090100", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.95": 4.4, "Val.Leak.Max": 4.6, "Val.CSR": 990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |

  @cloud.storage.S2
  @ECO-5733.1 @ECO-5733.2
  @ECO-5235.1 @ECO-5235.2
  @ECO-5588.3
  @ECO-6460.3
  @ECO-6553.3
  @ECO-6734.3
  @ECO-6746.3
  @ECO-6758.3
  @ECO-6969.3
  @ECO-6554.1
  @ECO-7292.3c @ECO-7292.3d
  @ECO-7298.1
  @ECO-5222.1
  @ECO-5876.1a @ECO-5876.1b @ECO-5876.1c
  @ECO-5234.1
  @ECO-5884.1
  Scenario: Store climate settings in HI Cloud Database
    When I send the following climate settings
      | json                                                                                                                                                                                                                                                                                                                                 |
      | { "FG.SerialNo": "20070811225", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "1 day ago", "CollectTime": "today 114001", "Set.ClimateControl": "Manual", "Set.HumEnable": "On", "Set.HumLevel": 8, "Set.TempEnable": "On", "Set.Temp": 30, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
    Then the following device data received events have been published
      | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | json                                                                                                                                                                                                                                                                                                                                 |
      | CLIMATE_SETTING_ACKNOWLEDGMENT | 20070811225 | DEVICE           | 20070811225               | 36                       | { "FG.SerialNo": "20070811225", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "1 day ago", "CollectTime": "today 114001", "Set.ClimateControl": "Manual", "Set.HumEnable": "On", "Set.HumLevel": 8, "Set.TempEnable": "On", "Set.Temp": 30, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
    Then the following climate settings acknowledgements are stored in the cloud
      | json                                                                                                                                                                                                                                                                                                                                 |
      | { "FG.SerialNo": "20070811225", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "1 day ago", "CollectTime": "today 114001", "Set.ClimateControl": "Manual", "Set.HumEnable": "On", "Set.HumLevel": 8, "Set.TempEnable": "On", "Set.Temp": 30, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |

  @cloud.storage.S3
  @ECO-5733.1 @ECO-5733.2
  @ECO-5235.1 @ECO-5235.2
  @ECO-5588.3
  @ECO-6460.3
  @ECO-6553.3
  @ECO-6734.3
  @ECO-6746.3
  @ECO-6758.3
  @ECO-6969.3
  @ECO-6554.1
  @ECO-7292.3c @ECO-7292.3d
  @ECO-7298.1
  @ECO-5222.1
  @ECO-5876.1a @ECO-5876.1b @ECO-5876.1c
  @ECO-5234.1
  @ECO-5884.1
  Scenario: Store therapy settings in HI Cloud Database
    When I send the following therapy settings
      | json                                                                                                                                                                                                                                                                                                                                                                                |
      | { "FG.SerialNo": "20070811225", "SubscriptionId": "28D54873-A79C-47A5-A08F-D55D979418F0", "Date": "1 day ago", "CollectTime": "today 100000", "Set.Mode": "CPAP", "CPAP.Set.Press": 12.5, "CPAP.Set.StartPress": 8.3, "CPAP.Set.EPR.EPREnable": "On", "CPAP.Set.EPR.EPRType": "FullTime", "CPAP.Set.EPR.Level": 2, "CPAP.Set.Ramp.RampEnable": "Off", "CPAP.Set.Ramp.RampTime": 0 } |
    Then the following device data received events have been published
      | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                |
      | THERAPY_SETTING_ACKNOWLEDGMENT | 20070811225 | DEVICE           | 20070811225               | 36                       | { "FG.SerialNo": "20070811225", "SubscriptionId": "28D54873-A79C-47A5-A08F-D55D979418F0", "Date": "1 day ago", "CollectTime": "today 100000", "Set.Mode": "CPAP", "CPAP.Set.Press": 12.5, "CPAP.Set.StartPress": 8.3, "CPAP.Set.EPR.EPREnable": "On", "CPAP.Set.EPR.EPRType": "FullTime", "CPAP.Set.EPR.Level": 2, "CPAP.Set.Ramp.RampEnable": "Off", "CPAP.Set.Ramp.RampTime": 0 } |
    Then the following therapy settings acknowledgements are stored in the cloud
      | json                                                                                                                                                                                                                                                                                                                                                                                |
      | { "FG.SerialNo": "20070811225", "SubscriptionId": "28D54873-A79C-47A5-A08F-D55D979418F0", "Date": "1 day ago", "CollectTime": "today 100000", "Set.Mode": "CPAP", "CPAP.Set.Press": 12.5, "CPAP.Set.StartPress": 8.3, "CPAP.Set.EPR.EPREnable": "On", "CPAP.Set.EPR.EPRType": "FullTime", "CPAP.Set.EPR.Level": 2, "CPAP.Set.Ramp.RampEnable": "Off", "CPAP.Set.Ramp.RampTime": 0 } |
