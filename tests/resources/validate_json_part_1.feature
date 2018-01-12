@newport
@newport.validation.part1
@ECO-5110
@ECO-5565
@ECO-5581
@ECO-5628
@ECO-5884
@ECO-5879
@ECO-5880
@ECO-5874
@ECO-6557
@ECO-8198
@ECO-9545

Feature:
  (ECO-5110) As NGCS
  I want to validate the data posted from the device
  so that I can process them correctly.

  (ECO-5565) As a clinical user
  I only want data discarded if the duration is missing
  so that I do not have days of data missing.

  (ECO-5581) As ECO
  I want to be able to receive CAM subscriptions on registration
  so that registration operations do not fail

  (ECO-5628) As ECO
  I want NGCS to prevent garbage data entering the cloud database
  to protect the integrity of the system

  (ECO-5884) As an clinical user
  I only want data copied to a patient since the device was last erased
  so that I do not see data for previous patients

  (ECO-5879) As a clinical user
  I want to see the settings shown for a day that correspond to those used during treatment for the day
  so that I am not misled about the patients therapy

  (ECO-5880) As a clinical user
  I want to see when my wireless settings have been completed
  so that I know that the patient will have the required treatment

  (ECO-5874) As ECO
  I want data received by NGCS to be validated against the subscription for the data
  to prevent rubbish data entering the system

  (ECO-6557) As a clinical user
  I want ECO to receive wireless detailed data from Newport devices
  so that I can monitor my patient's therapy progess

  (ECO-9545) As a clinical user,
  I would like to access historical alarm logs for my patients once they are made available in AirView
  so that I can manage my patients better.

  # ACCEPTANCE CRITERIA: (ECO-5110)
  # 1. Data received from Newport devices shall be validated. Note 1: the data received from Newport should be consistent with the interface specified in http://confluence.corp.resmed.org/display/CA/Wireless+Protocol+-+new
  # Note 2: This card is to test that the JSON body is consistent with the specification rather than to test for valid values in the data

  # ACCEPTANCE CRITERIA: (ECO-5565)
  # Note 1: When putting in functionality for ECO-5222 Store AfH Summary Data (via ECO-5305 and ECO-5336) validation of the JSON was added that apparently discards the posts if anything is missing. This card intends to remove most of this validation.
  # 1. Wireless summary data posts should be discarded only if any of the following mandatory JSON fields are missing: FG.SerialNo, SubscriptionId, Date, CollectTime and Val.Duration.
  # 2. Wireless therapy settings posts should be discarded only if any of the following mandatory JSON fields are missing: FG.SerialNo, SubscriptionId, Date, CollectTime and Set.Mode.
  # 3. Wireless climate settings posts should be discarded only if any of the following mandatory JSON fields are missing: FG.SerialNo, SubscriptionId, Date and CollectTime.
  # 4. Wireless fault data posts should be discarded only if any of the following mandatory JSON fields are missing: FG.SerialNo, SubscriptionId, Date and CollectTime.
  # Note 2: Example Summary data post that should be not be discarded because JSON fields are missing (note that hash is not correct)
  # POST /api/v1/therapies/summaries HTTP/1.1
  # X-CamSerialNo:23045678121
  # X-Hash:C23A2345
  #
  # {
  # "FG.SerialNo": "23045678121",
  # "SubscriptionId": "Summary_CPAP-01-23045678121",
  # "CollectTime": "20130430 140302",
  # "Date": "20130429",
  # "Val.Duration": 220
  # }

  # ACCEPTANCE CRITERIA: (ECO-5581)
  # 1. CAM subscription information during Registration should be able to be received as per http://confluence.corp.resmed.org/x/YwGz
  #
  # Note 1: It is not necessary at this stage to do anything with the CAM subscription information. The important thing is to prevent all registrations failing.

  # ACCEPTANCE CRITERIA: (ECO-5628)
  # Note 1: NGCS currently checks the range of numeric items against a valid range and the values of enumerations against a known set. Eric indicated that this needs to be cleaned up. This story corresponds to the processing in Step 4 Subscription comparison on https://confluence.ec2.local/x/q4yeAQ
  # 1. NGCS shall prevent messages being placed on the valid message queue that have numeric data outside of the range of the base type for the data item.
  # 2. NGCS shall prevent messages being placed on the valid message queue that have enumeration data with values that are not legal values of the base type for the data item.
  # Note 2: This applies to all received parameters such as settings, summary data etc
  # Note 3: The values to use for validation are present at http://confluence.corp.resmed.org/x/N4Nj in the file "Validation Dictionary CPL.txt" and attached to this story.

  # ACCEPTANCE CRITERIA: (ECO-5884)
  # 1. The last erase date shall be received from Newport devices and stored.
  # Note 1: The "Erases" interface described at http://confluence.corp.resmed.org/display/CA/Wireless+Protocol should be used for this purpose

  # ACCEPTANCE CRITERIA: (ECO-5879)
  # Note 1: The purpose of this story is to change the settings received that update the settings stored for the day in ECO and that are shown on reports. As per https://confluence.ec2.local/x/MZKeAQ the intent is to receive therapy session settings using a "Val" prefix whereas when writing settings a "Set" prefix should be used.
  # 1. ECO shall update the settings for a day of data when it receives the settings from the therapy session from the device. Note 2: These will use the "Val" prefix rather than the "Set" prefix but otherwise be unchanged from those received currently. The "Val" settings are received in a separate message to the "Set" settings - see Note 4 for an example.
  # Note 3: Once this card is implemented then acknowledgment of wireless settings will not work until ECO-5880 is complete.
  # Note 4: Example CPAP "Val" settings POST to ECO is as follows:
  # POST /api/v1/therapy/settings HTTP/1.1
  # X-CamSerialNo: {serial number}
  # X-Hash: {hash}
  #
  # {
  # "FG.SerialNo": "{serial number}",
  # "SubscriptionId": "{uuid-D}",
  # "Date": "20130429",
  # "CollectTime": "20130430 140302",
  # "Val.Mode": "CPAP",
  # "CPAP.Val.Press": 12.2,
  # "CPAP.Val.StartPress": 8.0,
  # "CPAP.Val.EPR.EPREnable":"On",
  # "CPAP.Val.EPR.EPRType": "FullTime",
  # "CPAP.Val.EPR.Level": 2,
  # "CPAP.Val.Ramp.RampEnable": "Off",
  # "CPAP.Val.Ramp.RampTime": 0
  # }
  # Note 5: This full list of new "Val" settings to be received are as follows:
  # "Val.Mode"
  # "CPAP.Val.Press"
  # "CPAP.Val.StartPress"
  # "CPAP.Val.EPR.EPREnable"
  # "CPAP.Val.EPR.EPRType"
  # "CPAP.Val.EPR.Level"
  # "CPAP.Val.Ramp.RampEnable"
  # "CPAP.Val.Ramp.RampTime"
  # "AutoSet.Val.MinPress"
  # "AutoSet.Val.MaxPress"
  # "AutoSet.Val.StartPress"
  # "AutoSet.Val.EPR.EPREnable"
  # "AutoSet.Val.EPR.EPRType"
  # "AutoSet.Val.EPR.Level"
  # "AutoSet.Val.Ramp.RampEnable"
  # "AutoSet.Val.Ramp.RampTime"
  # "AutoSet.Val.Comfort"
  # "HerAuto.Val.MinPress"
  # "HerAuto.Val.MaxPress"
  # "HerAuto.Val.StartPress"
  # "HerAuto.Val.EPR.EPREnable"
  # "HerAuto.Val.EPR.EPRType"
  # "HerAuto.Val.EPR.Level"
  # "HerAuto.Val.Ramp.RampEnable"
  # "HerAuto.Val.Ramp.RampTime"
  # "Val.ClimateControl"
  # "Val.HumEnable"
  # "Val.HumLevel"
  # "Val.TempEnable"
  # "Val.Temp",
  # "Val.Tube",
  # "Val.Mask",
  # "Val.SmartStart"

  # ACCEPTANCE CRITERIA: (ECO-5880)
  # Note 1: Settings are being changed so that the 'Set" settings are only being sent to the cloud after a remote settings change operation as per discussions on page https://confluence.ec2.local/x/MZKeAQ
  #
  # 1. When current settings are received from a Newport device i.e. using the 'Set" prefix, that match the most recent settings request then ECO shall:
  #    1a. change the settings status to No Changes Pending;
  #    1b. display the updated settings on the Prescription page; and
  #    1c. log settings success.
  # Note 2: This matches the existing S9 behaviour when a settings confirmation or acknowledgement is received from Comm Server via CAL as per ECO-1574
  # Note 3: The receipt of current settings should not be used to update the settings for a day of data anymore. We do not want the current settings to appear on reports etc.
  # Note 4: This card is implementing the happy day case for settings acknowledgment - assuming that settings changes will be successful.

  # ACCEPTANCE CRITERIA: (ECO-5874)
  # Note 1: This story corresponds to part of the processing in Step 4 Subscription comparison on https://confluence.ec2.local/x/q4yeAQ
  # 1. Any messages containing data or settings received from Newport devices shall be prevented from being placed on the valid message queue if the message does not correspond to a known subscription.
  # 2. Any message containing data items that are not listed in the subscription shall be shall be prevented from being placed on the valid message queue.
  # 3. A configurable property shall be available that can disable or enable the validation in AC#1 and AC#2 above. Note 2: That is, when the validation is disabled then all messages would be placed on the valid message queue even if the message did not correspond to a known subscription.
  # Note 3: For reference testing if needed the data needed in the subscriptions for Newport CPL can be found at http://confluence.corp.resmed.org/x/N4Nj in "Subscriptions CPL.txt"

  # ACCEPTANCE CRITERIA: (ECO-6557)
  # Note 1: The purpose of this story is to allow some early integration testing with the FG and CAM teams.
  # The server shall receive wireless detailed data from Newport devices for a day (i.e. session).
  # Note 2: Protocol and model details:
  # The protocol including example exchange is specified at http://confluence.corp.resmed.org/display/CA/Night+profile+and+detailed+data
  # Note 3: Identify and subscription validation will be performed. Range checking will be provided by a later card.
  # Note 4: For an unused day the detailed data will not be posted at all.

  # ACCEPTANCE CRITERIA: (ECO-8198)
  # 1. When a device data is determined to be invalid additional headers will be added to the JMS message as follows:
  # 1a. The software versions of the flow generator, communication module, and humidifer will be made available
  # 1b. If the data failed due to the subscription, the subscription will be made available

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

  Background:
    Given the server receives the following manufacturing unit detail
      | resource                                                             |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg20070811223_cam20102141732_new.xml |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg88800000001_cam88810000001_new.xml |
    And the server waits for the device manufactured queue to be empty
    And the server should not produce device manufactured error

  @newport.validation.S0 @ignore.subscription @valid.against.subscription
  @ECO-5874.3
  Scenario Outline: Subscription validation turned off
    Given the following commands are run on the karaf console
      | commands                                                                                                                                                                |
      | config:edit ngcs.processing.validation;config:propset ngcs.processing.validation.subscription.active false; config:update; restart resmed.hi.ngcs.processing.validation |
    And the following subscriptions are loaded into NGCS
      | /data/subscription_<SubscriptionId>.json |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    When I send the following therapy summaries
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
      | THERAPY_SUMMARY | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | <JSON> |
    When the following commands are run on the karaf console
      | commands                                                                                                                                                               |
      | config:edit ngcs.processing.validation;config:propset ngcs.processing.validation.subscription.active true; config:update; restart resmed.hi.ngcs.processing.validation |
    And I send the following therapy summaries
      | json   |
      | <JSON> |
    And I should receive a server ok response
    Then the server should log a therapy summaries error with software version headers
      | softwareVersionJson   | hasSubscriptionJson   | ValidationVetoPoint     | ValidationFailureType | ValidationFailureReason      |
      | <softwareVersionJson> | <hasSubscriptionJson> | SUBSCRIPTION_VALIDATION | SUBSCRIPTION_FIELD    | Found unexpected field names |
    Examples:
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | softwareVersionJson                                                                                                       | hasSubscriptionJson |
      | 12A64E97-6E6F-4C18-A78D-7844A827BF28 | { "Val.Whatever": 1, "FG.SerialNo": "20070811223", "SubscriptionId":"12A64E97-6E6F-4C18-A78D-7844A827BF28", "Date":"1 day ago", "CollectTime":"today 010101", "Val.Mode":"AutoSet", "Val.Duration":600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.95": 5, "Val.Leak.Max": 5, "Val.TgtIPAP.50": 12.4, "Val.TgtIPAP.95": 13.0, "Val.TgtIPAP.Max": 14.8, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | yes                 |

  @newport.validation.S1 @summary @summary.usage
  @ECO-5110.1
  @ECO-5565.1
  @ECO-5628.1 @ECO-5628.2
  @ECO-5874.1 @ECO-5874.2
  Scenario Outline: Accept valid json messages for therapy summary
    # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_<SubscriptionId>.json |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    When I send the following therapy summaries
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
      | THERAPY_SUMMARY | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | <JSON> |
  @valid.against.subscription
  @therapy_summary.csv
    Examples: These are good json messages
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | 12A64E97-6E6F-4C18-A78D-7844A827BF28 | { "FG.SerialNo": "20070811223", "SubscriptionId":"12A64E97-6E6F-4C18-A78D-7844A827BF28", "Date":"1 day ago", "CollectTime":"today 010101", "Val.Mode":"AutoSet", "Val.Duration":600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 2.3, "Val.Leak.70" : 3.0, "Val.Leak.95": 4.3, "Val.Leak.Max": 5.0, "Val.TgtIPAP.50": 12.4, "Val.TgtIPAP.95": 13.0, "Val.TgtIPAP.Max": 14.8, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "EndCap",   "Val.HeatedTube": "15mm", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |

  @newport.validation.S2 @summary @summary.usage
  @ECO-5110.1
  @ECO-5565.1
  @ECO-5874.1 @ECO-5874.2
  @ECO-8198.1 @ECO-8198.1a @ECO-8198.1b
  Scenario Outline: Log invalid json messages for therapy summary
    # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_<SubscriptionId>.json |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    When I send the following therapy summaries
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the server should log a therapy summaries error with software version headers
      | softwareVersionJson   | hasSubscriptionJson   | ValidationVetoPoint   | ValidationFailureType   | ValidationFailureReason   |
      | <softwareVersionJson> | <hasSubscriptionJson> | <ValidationVetoPoint> | <ValidationFailureType> | <ValidationFailureReason> |
  @invalid.json
  @therapy_summary.csv
    Examples: These are bad json messages by way of malformation
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | softwareVersionJson                                                                                                       | hasSubscriptionJson | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason                                                                                                                                 |
      | 12A64E97-6E6F-4C18-A78D-7844A827BF28 | { "what?" "FG.SerialNo": "20070811223", "SubscriptionId":"12A64E97-6E6F-4C18-A78D-7844A827BF28", "Date":"1 day ago", "CollectTime":"today 010101", "Val.Mode":"AutoSet", "Val.Duration":600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.95": 7.3, "Val.Leak.Max": 12.3, "Val.TgtIPAP.50": 12.4, "Val.TgtIPAP.95": 13.0, "Val.TgtIPAP.Max": 14.8, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | no                  | IDENTITY_VALIDATION | IDENTITY_FIELD        | startsWith(com.fasterxml.jackson.core.JsonParseException: Unexpected character ('"' (code 34)): was expecting a colon to separate field name and value) |
  @valid.against.subscription
    Examples: These are bad json messages by way of an extra element
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | softwareVersionJson                                                                                                       | hasSubscriptionJson | ValidationVetoPoint     | ValidationFailureType | ValidationFailureReason      |
      | 12A64E97-6E6F-4C18-A78D-7844A827BF28 | { "Val.Whatever": 1, "FG.SerialNo": "20070811223", "SubscriptionId":"12A64E97-6E6F-4C18-A78D-7844A827BF28", "Date":"1 day ago", "CollectTime":"today 010101", "Val.Mode":"AutoSet", "Val.Duration":600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.95": 7.3, "Val.Leak.Max": 12.3, "Val.TgtIPAP.50": 12.4, "Val.TgtIPAP.95": 13.0, "Val.TgtIPAP.Max": 14.8, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | yes                 | SUBSCRIPTION_VALIDATION | SUBSCRIPTION_FIELD    | Found unexpected field names |
  @missing.fields
    Examples: These are bad json messages by way of missing required element
      | SubscriptionId                       | JSON                                                                                                                                                          | softwareVersionJson                                                                                                       | hasSubscriptionJson | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason                                                                                                                                                                                                                                                                                                                                |
      | 12A64E97-6E6F-4C18-A78D-7844A827BF28 | {                               "SubscriptionId":"12A64E97-6E6F-4C18-A78D-7844A827BF28", "Date":"1 day ago", "CollectTime":"today 010101", "Val.Duration":0 } | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | no                  | IDENTITY_VALIDATION | IDENTITY_FIELD        | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/identity-schema.json#","pointer":""},"instance":{"pointer":""},"domain":"validation","keyword":"required","message":"missing required property(ies)","required":["CollectTime","Date","FG.SerialNo","SubscriptionId"],"missing":["FG.SerialNo"]} ] }    |
  @invalid.against.subscription
    Examples: These are bad json messages by way of missing subscription
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | softwareVersionJson                                                                                                       | hasSubscriptionJson | ValidationVetoPoint     | ValidationFailureType | ValidationFailureReason |
      | 12A64E97-6E6F-4C18-A78D-7844A827BF28 | { "FG.SerialNo": "20070811223", "SubscriptionId":"8712D3B1-DF30-49DF-B117-A0BB48D8AFD2", "Date":"1 day ago", "CollectTime":"today 010101", "Val.Mode":"AutoSet", "Val.Duration":600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 40.0, "Val.Leak.95": 7.3, "Val.Leak.Max": 12.3, "Val.TgtIPAP.50": 12.4, "Val.TgtIPAP.95": 13.0, "Val.TgtIPAP.Max": 14.8, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "EndCap", "Val.HeatedTube": "15mm", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 }   | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | no                  | SUBSCRIPTION_VALIDATION | SUBSCRIPTION_FIELD    | Subscription not found  |

  @newport.validation.S3 @settings @settings.therapy
  @ECO-5110.1
  @ECO-5565.2
  @ECO-5628.1 @ECO-5628.2
  @ECO-5879.1
  @ECO-5874.1 @ECO-5874.2
  Scenario Outline: Accept valid json messages for therapy setting
    # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_<SubscriptionId>.json |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    When I send the following therapy settings
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
      | THERAPY_SETTING | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | <JSON> |
  @valid.against.subscription
  @therapy_setting.csv
    Examples: These are good json messages
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | 21C219CD-EB66-43E7-B677-50E858BB851B | { "FG.SerialNo": "20070811223", "SubscriptionId": "21C219CD-EB66-43E7-B677-50E858BB851B", "Date": "1  day ago", "CollectTime": "today 010101", "Val.Mode": "AutoSet", "AutoSet.Val.MinPress": 8.2, "AutoSet.Val.MaxPress": 14.2, "AutoSet.Val.StartPress": 10.2, "AutoSet.Val.EPR.EPREnable": "On", "AutoSet.Val.EPR.EPRType": "Ramp",  "AutoSet.Val.EPR.Level": 2, "AutoSet.Val.Ramp.RampEnable": "Auto", "AutoSet.Val.Ramp.RampTime":30, "AutoSet.Val.Comfort":"Off" } |

  @newport.validation.S4 @settings @settings.therapy
  @ECO-5110.1
  @ECO-5565.2
  @ECO-5879.1
  @ECO-5874.1 @ECO-5874.2
  @ECO-8198.1 @ECO-8198.1a @ECO-8198.1b
  Scenario Outline: Log invalid json messages for therapy setting
    # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_<SubscriptionId>.json |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    When I send the following therapy settings
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the server should log a therapy settings error with software version headers
      | softwareVersionJson   | hasSubscriptionJson   | ValidationVetoPoint   | ValidationFailureType   | ValidationFailureReason   |
      | <softwareVersionJson> | <hasSubscriptionJson> | <ValidationVetoPoint> | <ValidationFailureType> | <ValidationFailureReason> |
  @invalid.json
  @therapy_setting.csv
    Examples: These are bad json messages by way of being malformed
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | softwareVersionJson                                                                                                       | hasSubscriptionJson | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason                                                                                                                                 |
      | 21C219CD-EB66-43E7-B677-50E858BB851B | { "what?" "FG.SerialNo": "20070811223", "SubscriptionId": "21C219CD-EB66-43E7-B677-50E858BB851B", "Date": "1  day ago", "CollectTime": "today 010101", "Val.Mode": "AutoSet", "AutoSet.Val.MinPress": 8.2, "AutoSet.Val.MaxPress": 14.2, "AutoSet.Val.StartPress": 10.2, "AutoSet.Val.EPR.EPREnable": "On", "AutoSet.Val.EPR.EPRType": "Ramp",  "AutoSet.Val.EPR.Level": 2, "AutoSet.Val.Ramp.RampEnable": "Auto", "AutoSet.Val.Ramp.RampTime":30, "AutoSet.Val.Comfort":"Off" } | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | no                  | IDENTITY_VALIDATION | IDENTITY_FIELD        | startsWith(com.fasterxml.jackson.core.JsonParseException: Unexpected character ('"' (code 34)): was expecting a colon to separate field name and value) |

  @newport.validation.S5 @settings @settings.climate
  @ECO-5110.1 @ECO-5565.3
  @ECO-5628.1 @ECO-5628.2
  @ECO-5879.1
  @ECO-5874.1 @ECO-5874.2
  Scenario Outline: Accept valid json messages for climate setting
    # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_<SubscriptionId>.json |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    When I send the following climate settings
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
      | CLIMATE_SETTING | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | <JSON> |
  @valid.against.subscription
  @climate_setting.csv
    Examples: These are good json messages
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                  |
      | 301E6C6C-A3C3-44B9-99D4-171A99FE6BD5 | { "FG.SerialNo": "20070811223", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "1 day ago",  "CollectTime": "today 094703", "Val.ClimateControl": "Auto", "Val.HumEnable": "Off", "Val.HumLevel": 6, "Val.TempEnable": "Off", "Val.Temp": 25, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |

  @newport.validation.S6 @settings @settings.climate
  @ECO-5110.1 @ECO-5565.3
  @ECO-5879.1
  @ECO-5874.1 @ECO-5874.2
  @ECO-8198.1 @ECO-8198.1a
  Scenario Outline: Log invalid json messages for climate setting
    # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_<SubscriptionId>.json |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    When I send the following climate settings
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the server should log a climate settings error with software version headers
      | softwareVersionJson   | ValidationVetoPoint   | ValidationFailureType   | ValidationFailureReason   |
      | <softwareVersionJson> | <ValidationVetoPoint> | <ValidationFailureType> | <ValidationFailureReason> |
  @invalid.json
  @climate_setting.csv
    Examples: These are bad json messages by way of malforment
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                          | softwareVersionJson                                                                                                       | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason                                                                                                                                 |
      | 301E6C6C-A3C3-44B9-99D4-171A99FE6BD5 | { "what?" "FG.SerialNo": "20070811223", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "1 day ago",  "CollectTime": "today 094703", "Val.ClimateControl": "Auto", "Val.HumEnable": "Off", "Val.HumLevel": 6, "Val.TempEnable": "Off", "Val.Temp": 25, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | IDENTITY_VALIDATION | IDENTITY_FIELD        | startsWith(com.fasterxml.jackson.core.JsonParseException: Unexpected character ('"' (code 34)): was expecting a colon to separate field name and value) |

  @newport.validation.S7 @device.fault
  @ECO-5110.1 @ECO-5565.4
  @ECO-5628.1 @ECO-5628.2
  @ECO-5874.1 @ECO-5874.2
  Scenario Outline: Accept valid json messages for fault
    # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_<SubscriptionId>.json |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    When I send the following device faults
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType      | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
      | DEVICE_FAULT | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | <JSON> |
  @valid.against.subscription
  @device_fault.csv
    Examples: These are good json messages
      | SubscriptionId                       | JSON                                                                                                                                                                                                                          |
      | 40326F7E-FE53-4D4B-8D7A-51DCC68F1177 | { "FG.SerialNo": "20070811223", "SubscriptionId": "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "Date": "1 day ago", "CollectTime": "today 140302", "Fault.Device": [ ], "Fault.Humidifier": [ 3, 4 ], "Fault.HeatedTube": [ 10 ] } |

  @newport.validation.S8 @device.fault
  @ECO-5110.1 @ECO-5565.4
  @ECO-5874.1 @ECO-5874.2
  @ECO-8198.1 @ECO-8198.1a @ECO-8198.1b
  Scenario Outline: Log invalid json messages for fault
    # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_<SubscriptionId>.json |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    When I send the following device faults
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the server should log a device faults error with software version headers
      | softwareVersionJson   | hasSubscriptionJson   | ValidationVetoPoint   | ValidationFailureType   | ValidationFailureReason   |
      | <softwareVersionJson> | <hasSubscriptionJson> | <ValidationVetoPoint> | <ValidationFailureType> | <ValidationFailureReason> |
  @invalid.json
  @device_fault.csv
    Examples: These are bad json messages by way of an extra element
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                             | softwareVersionJson                                                                                                       | hasSubscriptionJson | ValidationVetoPoint     | ValidationFailureType | ValidationFailureReason      |
      | 40326F7E-FE53-4D4B-8D7A-51DCC68F1177 | { "Val.Whatever": 1, "FG.SerialNo": "20070811223", "SubscriptionId": "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "Date": "1 day ago", "CollectTime": "today 140302", "Fault.Device": [ ], "Fault.Humidifier": [ 3, 4 ], "Fault.HeatedTube": [ 10 ] } | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | yes                 | SUBSCRIPTION_VALIDATION | SUBSCRIPTION_FIELD    | Found unexpected field names |

  @newport.validation.S9 @device.registration
  @ECO-5110.1
  @ECO-5581.1
  Scenario Outline: Accept valid json messages for registrations
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    When I send the following registration
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the device is registered
    Examples: These are good json messages
      | JSON                                                                                                                                                                                                                                                                                                                                  |
      | { "FG": {"SerialNo": "20070811223", "Software": "FGABCDEFH", "MID": 36, "VID": 26, "PCBASerialNo":"1A345678", "ProductCode":"37001", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "20102141732", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |

  @newport.validation.S10 @device.registration
  @ECO-5110.1
  @ECO-5581.1
  Scenario Outline: Log invalid json messages for registrations
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    When I send the following registration
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the server should log a registration error
      | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason                                                                                                                                                                                                                                                                             |
      | MESSAGE_VALIDATION  | REGISTRATION          | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/registration-schema.json#","pointer":""},"instance":{"pointer":""},"domain":"validation","keyword":"additionalProperties","message":"additional properties are not allowed","unwanted":["MASK"]} ] } |
  @extra.fields
    Examples: These are bad json messages by way of an extra element
      | JSON                                                                                                                                                                                                                                                                                                                                                           |
      | { "MASK": { "Type": "Normal"}, "FG": {"SerialNo": "20070811223", "Software": "FGABCDEFH", "MID": 36, "VID": 26, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "20102141732", "Software": "CAMABCDEFH", "PCBASerialNo":"1A345678", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |

  @newport.validation.S11 @message.acknowledge
  @ECO-5110.1
  @ECO-5581.1
  Scenario Outline: Accept valid json messages for request acknowledgement
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                               |
      | { "FG": {"SerialNo": "88800000001", "Software": "SX566-0302", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And the server has the following <Operations> to be sent to devices
      | json   |
      | <JSON> |
    And I request my broker requests
    And I should receive a response code of "200"
    And I request the <Operation> with identifier "<UUID>"
    When I acknowledge the <Operation> with identifier "<UUID>"
      | json                                                               |
      | { "FG.SerialNo": "88800000001", <ACK_JSON>, "Status": "Received" } |
    Then I should receive a server ok response
    When I request my broker requests
    Then I should receive the following broker requests
      | json                                             |
      | { "FG.SerialNo": "88800000001", "Broker": [  ] } |
    Examples: These are good json messages
      | Operations       | Operation        | UUID                                 | ACK_JSON                                                 | JSON                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | climate settings | climate settings | 3588B987-3304-4D07-97A0-BEAC1A1D06D4 | "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4"     | { "FG.SerialNo": "88800000001", "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" }                                                                                                                                                                                           |
      | subscriptions    | subscription     | E0C70BA1-FEE3-4445-9FF1-AD9942643F42 | "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42" | { "FG.SerialNo": "88800000001", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | therapy settings | therapy settings | 0091D329-9352-40B0-B34B-D5571242BF0C | "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C"     | { "FG.SerialNo": "88800000001", "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" }                                                         |
      | upgrades         | upgrade          | B2AE8F06-1541-4616-AE6F-F9E4C079CC6E | "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E"      | { "FG.SerialNo": "88800000001", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" }                                                                                                                                                                                                                                                         |

  @newport.validation.S12 @message.acknowledge
  @ECO-5110.1
  @ECO-5581.1
  Scenario Outline: Log invalid json messages for request acknowledgement
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And the server has the following <Operations> to be sent to devices
      | json   |
      | <JSON> |
    And I request my broker requests
    And I should receive a response code of "200"
    And I request the <Operation> with identifier "<UUID>"
    When I acknowledge the <Operation> with identifier "<UUID>"
      | json                                                               |
      | { "FG.SerialNo": "88800000001", <ACK_JSON>, "Status": "Received" } |
    Then I should receive a server ok response
    And the server should log a message status error
      | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason   |
      | FIELD_VALIDATION    | MESSAGE_STATUS_FIELD  | <ValidationFailureReason> |
  @extra.fields
    Examples: These are bad json messages by way of an extra element
      | Operations       | Operation        | UUID                                 | ACK_JSON                                                                       | JSON                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | ValidationFailureReason   |
      | climate settings | climate settings | 3588B987-3304-4D07-97A0-BEAC1A1D06D4 | "Extra": "something", "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4"     | { "FG.SerialNo": "88800000001", "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" }                                                                                                                                                                                           | assertNotNull()           |
      | subscriptions    | subscription     | E0C70BA1-FEE3-4445-9FF1-AD9942643F42 | "Extra": "something", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42" | { "FG.SerialNo": "88800000001", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } | assertNotNull()           |
      | therapy settings | therapy settings | 0091D329-9352-40B0-B34B-D5571242BF0C | "Extra": "something", "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C"     | { "FG.SerialNo": "88800000001", "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" }                                                         | assertNotNull()           |
  @missing.fields
    Examples: These are bad json messages by way of a misspelled element
      | Operations | Operation | UUID                                 | ACK_JSON                                              | JSON                                                                                                                                                                                                           | ValidationFailureReason |
      | upgrades   | upgrade   | B2AE8F06-1541-4616-AE6F-F9E4C079CC6E | "MyUpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E" | { "FG.SerialNo": "88800000001", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } | assertNotNull()         |

  @newport.validation.S13 @summary @valid.against.subscription
  @ECO-5628.1 @ECO-5628.2
  @ECO-5874.1 @ECO-5874.2
  @ECO-8198.1 @ECO-8198.1a
  Scenario Outline: Field level validation for invalid therapy summary
    # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_<SubscriptionId>.json |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    When I send the following therapy summaries
      | json                                                                                                                                                              |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"<SubscriptionId>", "Date":"1 day ago", "CollectTime":"today 010101", "Val.Duration":600, <PropertyToValidate> } |
    Then I should receive a server ok response
    And the server should log a therapy summaries error with software version headers
      | softwareVersionJson                                                                                                       | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason   |
      | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | FIELD_VALIDATION    | THERAPY_SUMMARY_FIELD | <ValidationFailureReason> |
  @values.outside.range
  @therapy_summary_element.csv
    Examples: These are bad json property with numeric data outside the range or with invalid enum value
      | PropertyToValidate          | SubscriptionId                       | ValidationFailureReason                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | "Val.MaskOn" : [ -1, 1441 ] | 12A64E97-6E6F-4C18-A78D-7844A827BF28 | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/definitions.json#","pointer":"/definitions/minuteOfDayValue"},"instance":{"pointer":"/Val.MaskOn/0"},"domain":"validation","keyword":"minimum","message":"number is lower than the required minimum","minimum":0,"found":-1}, {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/definitions.json#","pointer":"/definitions/minuteOfDayValue"},"instance":{"pointer":"/Val.MaskOn/1"},"domain":"validation","keyword":"maximum","message":"number is greater than the required maximum","maximum":1440,"found":1441} ] }               |

  @newport.validation.S14 @settings @settings.therapy @valid.against.subscription
  @ECO-5628.1 @ECO-5628.2
  @ECO-5879.1
  @ECO-5874.1 @ECO-5874.2
  @ECO-8198.1 @ECO-8198.1a
  Scenario Outline: Field level validation for invalid therapy setting
    # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_<SubscriptionId>.json |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    When I send the following therapy settings
      | json                                                                                                                                           |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "<SubscriptionId>", "Date":"1 day ago", "CollectTime":"today 010101", <PropertyToValidate> } |
    Then I should receive a server ok response
    And the server should log a therapy settings error with software version headers
      | softwareVersionJson                                                                                                       | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason   |
      | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | FIELD_VALIDATION    | THERAPY_SETTING_FIELD | <ValidationFailureReason> |
  @values.outside.range
  @therapy_setting_element.csv
    Examples: AutoSet - These are bad json property with numeric data outside the range or with invalid enum value
      | PropertyToValidate                                         | SubscriptionId                       | ValidationFailureReason                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | "Val.Mode": "AutoSet", "AutoSet.Val.MinPress": -10.1       | 21C219CD-EB66-43E7-B677-50E858BB851B | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/definitions.json#","pointer":"/definitions/pressureValue"},"instance":{"pointer":"/AutoSet.Val.MinPress"},"domain":"validation","keyword":"minimum","message":"number is lower than the required minimum","minimum":-10,"found":-10.1} ] }                                                                                                                                                                                                                                                                                                                                                                        |

  @newport.validation.S15 @settings @settings.climate
  @ECO-5628.1 @ECO-5628.2
  @ECO-5874.1 @ECO-5874.2
  @ECO-8198.1 @ECO-8198.1a
  Scenario Outline: Field level validation for invalid climate setting
    # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_<SubscriptionId>.json |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    When I send the following climate settings
      | json                                                                                                                                           |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "<SubscriptionId>", "Date":"1 day ago", "CollectTime":"today 010101", <PropertyToValidate> } |
    Then I should receive a server ok response
    And the server should log a climate settings error with software version headers
      | softwareVersionJson                                                                                                       | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason   |
      | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | FIELD_VALIDATION    | CLIMATE_SETTING_FIELD | <ValidationFailureReason> |
  @values.outside.range
  @climate_setting_element.csv
    Examples: These are bad json properties with numeric data outside the range or with invalid enum value
      | PropertyToValidate          | SubscriptionId                       | ValidationFailureReason                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | "Set.ClimateControl": "On"  | 30B59434-BF4F-4788-9678-A00FF860C038 | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/definitions.json#","pointer":"/climateControl"},"instance":{"pointer":"/Set.ClimateControl"},"domain":"validation","keyword":"enum","message":"instance does not match any enum value","enum":["Auto","Manual"],"value":"On"} ] }                                                                                                                                                                                                                                                                                                                                                                      |

  @newport.validation.S16 @device.fault @valid.against.subscription
  @ECO-5628.1 @ECO-5628.2
  @ECO-5874.1 @ECO-5874.2
  @ECO-8198.1 @ECO-8198.1a
  Scenario Outline: Field level validation for invalid fault
    # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_<SubscriptionId>.json |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    When I send the following device faults
      | json                                                                                                                                          |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"<SubscriptionId>", "Date":"1 day ago", "CollectTime":"today 094703", <PropertyToValidate> } |
    Then I should receive a server ok response
    And the server should log a device faults error with software version headers
      | softwareVersionJson                                                                                                       | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason   |
      | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | FIELD_VALIDATION    | DEVICE_FAULT_FIELD    | <ValidationFailureReason> |
  @values.outside.range
  @device_fault_element.csv
    Examples: These are bad json properties with numeric data outside the range or with invalid enum value
      | PropertyToValidate                  | SubscriptionId                       | ValidationFailureReason                                                                                                                                                                                                                                                                                                                          |
      | "Fault.Device": 0                   | 40326F7E-FE53-4D4B-8D7A-51DCC68F1177 | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/definitions.json#","pointer":"/faultCodeArray"},"instance":{"pointer":"/Fault.Device"},"domain":"validation","keyword":"type","message":"instance type does not match any allowed primitive type","expected":["array"],"found":"integer"} ] }     |