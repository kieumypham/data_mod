@newport
@newport.validation.part2
@ECO-5110
@ECO-5565
@ECO-5628
@ECO-5884
@ECO-5880
@ECO-5874
@ECO-6557
@ECO-8198
@ECO-9545
@ECO-10713

Feature:
  (ECO-5110) As NGCS
  I want to validate the data posted from the device
  so that I can process them correctly.

  (ECO-5565) As a clinical user
  I only want data discarded if the duration is missing
  so that I do not have days of data missing.

  (ECO-5628) As ECO
  I want NGCS to prevent garbage data entering the cloud database
  to protect the integrity of the system

  (ECO-5884) As an clinical user
  I only want data copied to a patient since the device was last erased
  so that I do not see data for previous patients

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

  # ACCEPTANCE CRITERIA: (ECO-5628)
  # Note 1: NGCS currently checks the range of numeric items against a valid range and the values of enumerations against a known set. Eric indicated that this needs to be cleaned up. This story corresponds to the processing in Step 4 Subscription comparison on https://confluence.ec2.local/x/q4yeAQ
  # 1. NGCS shall prevent messages being placed on the valid message queue that have numeric data outside of the range of the base type for the data item.
  # 2. NGCS shall prevent messages being placed on the valid message queue that have enumeration data with values that are not legal values of the base type for the data item.
  # Note 2: This applies to all received parameters such as settings, summary data etc
  # Note 3: The values to use for validation are present at http://confluence.corp.resmed.org/x/N4Nj in the file "Validation Dictionary CPL.txt" and attached to this story.

  # ACCEPTANCE CRITERIA: (ECO-5884)
  # 1. The last erase date shall be received from Newport devices and stored.
  # Note 1: The "Erases" interface described at http://confluence.corp.resmed.org/display/CA/Wireless+Protocol should be used for this purpose

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

  @newport.validation.S17 @device.erasure @valid.against.subscription
  @ECO-5884.1
  @ECO-5874.1 @ECO-5874.2
  Scenario Outline: Accept valid json messages for erasure
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
    When I send the following device erasures
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
      | DEVICE_ERASURE | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | <JSON> |
  @valid.against.subscription
    Examples: These are good json messages
      | SubscriptionId                       | JSON                                                                                                                                                                           |
      | 51960EDB-EA97-4A50-A32C-EACF6239EBE3 | { "FG.SerialNo": "20070811223", "SubscriptionId": "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "Date": "1 day ago","CollectTime": "today 120000", "Val.LastEraseDate": "20140228" } |

  @newport.validation.S18 @device.erasure @invalid.against.subscription
  @ECO-5884.1
  @ECO-5874.1 @ECO-5874.2
  @ECO-8198.1 @ECO-8198.1a
  Scenario Outline: Log invalid json message for erasure
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
    When I send the following device erasures
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the server should log a device erasures error with software version headers
      | softwareVersionJson   | hasSubscriptionJson   | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason                                                                                                                                                                                                                                                                                                         |
      | <softwareVersionJson> | <hasSubscriptionJson> | FIELD_VALIDATION    | DEVICE_ERASURE_FIELD  | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/device-erasure-schema.json#","pointer":""},"instance":{"pointer":""},"domain":"validation","keyword":"required","message":"missing required property(ies)","required":["Val.LastEraseDate"],"missing":["Val.LastEraseDate"]} ] } |
  @missing.fields
    Examples: These are bad json messages by way of missing required element
      | SubscriptionId                       | JSON                                                                                                                                          | softwareVersionJson                                                                                                       | hasSubscriptionJson |
      | 51960EDB-EA97-4A50-A32C-EACF6239EBE3 | { "FG.SerialNo": "20070811223", "SubscriptionId": "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "Date": "1 day ago","CollectTime": "today 120000" } | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | no                  |

  @newport.validation.S19 @settings @settings.therapy @valid.against.subscription
  @ECO-5110.1
  @ECO-5565.2
  @ECO-5628.1 @ECO-5628.2
  @ECO-5880.1
  @ECO-5874.1 @ECO-5874.2
  Scenario Outline: Accept valid json messages for therapy setting acknowledgement
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
      | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
      | THERAPY_SETTING_ACKNOWLEDGMENT | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | <JSON> |
  @valid.against.subscription
  @therapy_setting.csv
    Examples: These are good json messages (acknowledgement)
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | 2896C763-FE94-4B3F-AD6C-305583FD4210 | { "FG.SerialNo": "20070811223", "SubscriptionId": "2896C763-FE94-4B3F-AD6C-305583FD4210", "Date": "1  day ago", "CollectTime": "today 010101", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 8.2, "AutoSet.Set.MaxPress": 14.2, "AutoSet.Set.StartPress": 10.2, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp",  "AutoSet.Set.EPR.Level": 2, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime":30, "AutoSet.Set.Comfort":"Off" } |

  @newport.validation.S20 @settings @settings.therapy @valid.against.subscription
  @ECO-5110.1
  @ECO-5565.2
  @ECO-5880.1
  @ECO-5874.1 @ECO-5874.2
  @ECO-8198.1 @ECO-8198.1a @ECO-8198.1b
  Scenario Outline: Log invalid json messages for therapy setting acknowledgement
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
    And the server should log a therapy settings acknowledgment error with software version headers
      | softwareVersionJson   | hasSubscriptionJson   | ValidationVetoPoint   | ValidationFailureType   | ValidationFailureReason   |
      | <softwareVersionJson> | <hasSubscriptionJson> | <ValidationVetoPoint> | <ValidationFailureType> | <ValidationFailureReason> |
  @invalid.against.subscription
  @therapy_setting.csv
    Examples: These are bad json messages by way of malforment
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | softwareVersionJson                                                                                                       | hasSubscriptionJson | ValidationVetoPoint    | ValidationFailureType | ValidationFailureReason                                                                                                                                 |
      | 2896C763-FE94-4B3F-AD6C-305583FD4210 | { "what?" "FG.SerialNo": "20070811223", "SubscriptionId": "2896C763-FE94-4B3F-AD6C-305583FD4210", "Date": "1  day ago", "CollectTime": "today 010101", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 8.2, "AutoSet.Set.MaxPress": 14.2, "AutoSet.Set.StartPress": 10.2, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp",  "AutoSet.Set.EPR.Level": 2, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime":30, "AutoSet.Set.Comfort":"Off" } | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | no                  | IDENTITY_VALIDATION    | IDENTITY_FIELD        | startsWith(com.fasterxml.jackson.core.JsonParseException: Unexpected character ('"' (code 34)): was expecting a colon to separate field name and value) |

  @newport.validation.S21 @settings @settings.therapy @valid.against.subscription
  @ECO-5628.1 @ECO-5628.2
  @ECO-5880.1
  @ECO-5874.1 @ECO-5874.2
  @ECO-8198.1 @ECO-8198.1a
  Scenario Outline: Field level validation for invalid therapy setting acknowledgement
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
    And the server should log a therapy settings acknowledgment error with software version headers
      | softwareVersionJson                                                                                                       | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason   |
      | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | FIELD_VALIDATION    | THERAPY_SETTING_FIELD | <ValidationFailureReason> |
  @values.outside.range
  @therapy_setting_element.csv
    Examples: AutoSet - These are bad json property with numeric data outside the range or with invalid enum value
      | PropertyToValidate                                         | SubscriptionId                       | ValidationFailureReason                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": -10.1       | 2896C763-FE94-4B3F-AD6C-305583FD4210 | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/definitions.json#","pointer":"/definitions/pressureValue"},"instance":{"pointer":"/AutoSet.Set.MinPress"},"domain":"validation","keyword":"minimum","message":"number is lower than the required minimum","minimum":-10,"found":-10.1} ] }                                                                                                                                                                                                                                                                                                                                                                        |

  @newport.validation.S22 @settings @settings.climate
  @ECO-5110.1
  @ECO-5565.3
  @ECO-5628.1 @ECO-5628.2
  @ECO-5880.1
  @ECO-5874.1 @ECO-5874.2
  Scenario Outline: Accept valid json messages for climate setting acknowledgement
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
      | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
      | CLIMATE_SETTING_ACKNOWLEDGMENT | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | <JSON> |
  @valid.against.subscription
  @climate_setting.csv
    Examples: These are good json messages
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                  |
      | 30B59434-BF4F-4788-9678-A00FF860C038 | { "FG.SerialNo": "20070811223", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "1 day ago",  "CollectTime": "today 094703", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |

  @newport.validation.S23 @settings @settings.climate @valid.against.subscription
  @ECO-5110.1
  @ECO-5565.3
  @ECO-5880.1
  @ECO-5874.1 @ECO-5874.2
  @ECO-8198.1 @ECO-8198.1a @ECO-8198.1b
  Scenario Outline: Log invalid json message for climate setting acknowledgement
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
    And the server should log a climate settings acknowledgment error with software version headers
      | softwareVersionJson   | hasSubscriptionJson   | ValidationVetoPoint   | ValidationFailureType   | ValidationFailureReason   |
      | <softwareVersionJson> | <hasSubscriptionJson> | <ValidationVetoPoint> | <ValidationFailureType> | <ValidationFailureReason> |
  @invalid.json
  @climate_setting.csv
    Examples: These are bad json messages by way of malforment
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                          | softwareVersionJson                                                                                                       | hasSubscriptionJson | ValidationVetoPoint  | ValidationFailureType | ValidationFailureReason                                                                                                                                 |
      | 30B59434-BF4F-4788-9678-A00FF860C038 | { "what?" "FG.SerialNo": "20070811223", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "1 day ago",  "CollectTime": "today 094703", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | no                  | IDENTITY_VALIDATION  | IDENTITY_FIELD        | startsWith(com.fasterxml.jackson.core.JsonParseException: Unexpected character ('"' (code 34)): was expecting a colon to separate field name and value) |

  @newport.validation.S24 @therapy.detail @therapy.detail.usage
  @ECO-6557.1
  Scenario Outline: Accept valid json messages for therapy detail
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
    When I send the following therapy details
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
      | THERAPY_DETAIL | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | <JSON> |
  @valid.against.subscription
  @therapy_detail.csv
    Examples: These are good json messages
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                               |
      | 018A5655-81C6-4888-A2AD-6480087BE3B7 | { "FG.SerialNo": "20070811223", "SubscriptionId":"018A5655-81C6-4888-A2AD-6480087BE3B7", "Date":"1 day ago", "CollectTime":"today 010101", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ 0, 0, 0 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 0, 0, 0 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } |

  @newport.validation.S25 @therapy.detail @therapy.detail.usage
  @ECO-6557.1
  @ECO-8198.1 @ECO-8198.1a
  Scenario Outline: Log invalid json messages for therapy detail
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
    When I send the following therapy details
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the server should log a therapy details error with software version headers
      | softwareVersionJson   | hasSubscriptionJson   | ValidationVetoPoint   | ValidationFailureType   | ValidationFailureReason   |
      | <softwareVersionJson> | <hasSubscriptionJson> | <ValidationVetoPoint> | <ValidationFailureType> | <ValidationFailureReason> |
  @invalid.json
  @therapy_detail.csv
    Examples: These are bad json messages by way of malforment
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                                       | softwareVersionJson                                                                                                       | hasSubscriptionJson | ValidationVetoPoint   | ValidationFailureType | ValidationFailureReason                                                                                                                                 |
      | 018A5655-81C6-4888-A2AD-6480087BE3B7 | { "what?" "FG.SerialNo": "20070811223", "SubscriptionId":"018A5655-81C6-4888-A2AD-6480087BE3B7", "Date":"1 day ago", "CollectTime":"today 010101", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ 0, 0, 0 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 0, 0, 0 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | no                  |  IDENTITY_VALIDATION  | IDENTITY_FIELD        | startsWith(com.fasterxml.jackson.core.JsonParseException: Unexpected character ('"' (code 34)): was expecting a colon to separate field name and value) |

  @newport.validation.S26 @therapy.detail @therapy.detail.usage @valid.against.subscription
  @ECO-8198.1 @ECO-8198.1a
  Scenario Outline: Field level validation for invalid therapy detail
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
    When I send the following therapy details
      | json                                                                                                                                          |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"<SubscriptionId>", "Date":"1 day ago", "CollectTime":"today 010101", <PropertyToValidate> } |
    Then I should receive a server ok response
    And the server should log a therapy details error with software version headers
      | softwareVersionJson                                                                                                       | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason   |
      | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | FIELD_VALIDATION    | THERAPY_DETAIL_FIELD  | <ValidationFailureReason> |
  @invalid.json
  @therapy_detail_element.csv
    Examples: These are bad json due to type/structure
      | PropertyToValidate                                                   | SubscriptionId                       | ValidationFailureReason                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | "Val.Leak.1m": 0                                                     | 018A5655-81C6-4888-A2AD-6480087BE3B7 | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/definitions.json#","pointer":"/therapyLeakSampleArray"},"instance":{"pointer":"/Val.Leak.1m"},"domain":"validation","keyword":"type","message":"instance type does not match any allowed primitive type","expected":["array"],"found":"integer"} ] }                                                                                                                                                                                                                                                                                  |

  @newport.validation.S27 @settings @settings.alarm
  @ECO-9545.3 @ECO-9545.4
  Scenario Outline: Accept valid json messages for alarm setting
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
    When I send the following alarm settings
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType       | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
      | ALARM_SETTING | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | <JSON> |
  @valid.against.subscription
  @alarm_setting.csv
    Examples: These are good json message
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | FDC84510-D85D-4E18-9994-DFCB78D5D794 | { "FG.SerialNo": "20070811223", "SubscriptionId": "FDC84510-D85D-4E18-9994-DFCB78D5D794", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "Low" } |

  @newport.validation.S28 @settings @settings.alarm
  @ECO-9545.3 @ECO-9545.4
  Scenario Outline: Log invalid json messages for alarm setting
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
    When I send the following alarm settings
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the server should log a alarm settings error with software version headers
      | softwareVersionJson   | hasSubscriptionJson   | ValidationVetoPoint   | ValidationFailureType   | ValidationFailureReason   |
      | <softwareVersionJson> | <hasSubscriptionJson> | <ValidationVetoPoint> | <ValidationFailureType> | <ValidationFailureReason> |
  @invalid.json
  @alarm_setting.csv
    Examples: These are bad json messages by way of malforment
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                                                                                                                             | softwareVersionJson                                                                                                       | hasSubscriptionJson | ValidationVetoPoint  | ValidationFailureType | ValidationFailureReason                                                                                                                                 |
      | FDC84510-D85D-4E18-9994-DFCB78D5D794 | { "what?" "FG.SerialNo": "20070811223", "SubscriptionId": "FDC84510-D85D-4E18-9994-DFCB78D5D794", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "High" } | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | no                  | IDENTITY_VALIDATION  | IDENTITY_FIELD        | startsWith(com.fasterxml.jackson.core.JsonParseException: Unexpected character ('"' (code 34)): was expecting a colon to separate field name and value) |

  @newport.validation.S29 @settings @settings.alarm @valid.against.subscription
  @ECO-9545.3 @ECO-9545.4
  Scenario Outline: Field level validation for invalid alarm setting
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
    When I send the following alarm settings
      | json                                                                                                                                                   |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "<SubscriptionId>", "Date": "3 days ago", "CollectTime": "2 days ago 140302", <PropertyToValidate> } |
    Then I should receive a server ok response
    And the server should log a alarm settings error with software version headers
      | softwareVersionJson                                                                                                       | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason   |
      | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | FIELD_VALIDATION    | ALARM_SETTING_FIELD   | <ValidationFailureReason> |
  @values.outside.range
  @alarm_setting_element.csv
    Examples: These are bad json property with numeric data outside the range or with invalid enum value
      | PropertyToValidate                        | SubscriptionId                       | ValidationFailureReason                                                                                                                                                                                                                                                                                                                                     |
      | "Val.LowMinuteVentAlarmEnable": "blah"    | FDC84510-D85D-4E18-9994-DFCB78D5D794 | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/definitions.json#","pointer":"/definitions/stateEnumeration"},"instance":{"pointer":"/Val.LowMinuteVentAlarmEnable"},"domain":"validation","keyword":"enum","message":"instance does not match any enum value","enum":["Off","On"],"value":"blah"} ] }       |

  @newport.validation.S30 @device @device.alarms
  @ECO-9545.1 @ECO-9545.2
  Scenario Outline: Accept valid json messages for device alarms
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
    When I send the following device alarms
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType      | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
      | DEVICE_ALARM | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | <JSON> |
  @valid.against.subscription
  @device_alarm.csv
    Examples: These are good json message
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                                         |
      | FDC84510-D85D-4E18-9995-FDBC78D5D796 | { "FG.SerialNo": "20070811223", "SubscriptionId": "FDC84510-D85D-4E18-9995-FDBC78D5D796", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.AlarmEvent": [ { "EndDateTime": "3 days agoT22:31:34", "Action": "Activate", "AlarmType": "ApneaAlarm", "AlarmCode": "30", "AlarmPriority": "Medium", "Threshold": { "ThresholdType": "ApneaAlarmThreshold" } } ] } |

  @newport.validation.S31 @device @device.alarms
  @ECO-9545.1 @ECO-9545.2
  Scenario Outline: Log invalid json messages for device alarms
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
    When I send the following device alarms
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the server should log a device alarms error with software version headers
      | softwareVersionJson   | hasSubscriptionJson   | ValidationVetoPoint   | ValidationFailureType   | ValidationFailureReason   |
      | <softwareVersionJson> | <hasSubscriptionJson> | <ValidationVetoPoint> | <ValidationFailureType> | <ValidationFailureReason> |
  @invalid.json
  @device_alarm.csv
    Examples: These are bad json messages by way of malforment
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                               | softwareVersionJson                                                                                                       | hasSubscriptionJson | ValidationVetoPoint  | ValidationFailureType | ValidationFailureReason                                                                                                                                 |
      | FDC84510-D85D-4E18-9995-FDBC78D5D796 | { "what?"  "FG.SerialNo": "20070811223", "SubscriptionId": "FDC84510-D85D-4E18-9995-FDBC78D5D796", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.AlarmEvent": [ { "EndDateTime": "3 days agoT22:31:34", "Action": "Activate", "AlarmType": "ApneaAlarm", "AlarmPriority": "Medium", "Threshold": { "ThresholdType": "ApneaAlarmThreshold" } } ] } | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | no                  | IDENTITY_VALIDATION  | IDENTITY_FIELD        | startsWith(com.fasterxml.jackson.core.JsonParseException: Unexpected character ('"' (code 34)): was expecting a colon to separate field name and value) |

  @newport.validation.S32 @device @device.alarms @valid.against.subscription
  @ECO-9545.1 @ECO-9545.2
  Scenario Outline: Field level validation for invalid device alarms
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
    When I send the following device alarms
      | json                                                                                                                                          |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"<SubscriptionId>", "Date":"1 day ago", "CollectTime":"today 010101", <PropertyToValidate> } |
    Then I should receive a server ok response
    And the server should log a device alarms error with software version headers
      | softwareVersionJson                                                                                                       | ValidationVetoPoint   | ValidationFailureType   | ValidationFailureReason   |
      | {"flowGenSoftwareVersion":"SX567-0100","commModuleSoftwareVersion":"SX558-0100","humidifierSoftwareVersion":"SX556-0100"} | <ValidationVetoPoint> | <ValidationFailureType> | <ValidationFailureReason> |
  @invalid.json
  @device_alarm_element.csv
    Examples: These are bad json due to type/structure
      | PropertyToValidate                                                                                                                                                                                                                                                                    | SubscriptionId                       | ValidationVetoPoint     | ValidationFailureType | ValidationFailureReason                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | "Val.AlarmEvent": [ { "EndDateTime": "3 days agoT22:31:34", "AlarmType": "ApneaAlarm", "Threshold": { "ThresholdType": "ApneaAlarmThreshold" } } ]                                                                                                                                    | FDC84510-D85D-4E18-9995-FDBC78D5D796 | FIELD_VALIDATION        | DEVICE_ALARM_FIELD    | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/definitions.json#","pointer":"/alarmEvent"},"instance":{"pointer":"/Val.AlarmEvent/0"},"domain":"validation","keyword":"required","message":"missing required property(ies)","required":["Action","AlarmType","EndDateTime","Threshold"],"missing":["Action"]} ] }                                                                                                                                                                                                                                                                                                                                                            |

  @newport.validation.S33
  @ECO-10713
  Scenario Outline: Rejects wrong Flowgen Serial Number format
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
    And the following device invalid therapy summaries events have been published
      | JMSType         | JMSXGroupID  | DeviceDataSource | flowGenSerialNumber | ValidationVetoPoint | json   | ValidationFailureType | ValidationFailureReason                                                                                                                                                                                                                                                                                                                         |
      | THERAPY_SUMMARY | 20070811223? | DEVICE           | 20070811223?        | IDENTITY_VALIDATION | <JSON> | IDENTITY_FIELD        | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/definitions.json#","pointer":"/definitions/resmedSerialNumber"},"instance":{"pointer":"/FG.SerialNo"},"domain":"validation","keyword":"pattern","message":"regex does not match input string","regex":"^[0-9]{11}$","string":"20070811223?"} ] } |
  @valid.against.subscription
    Examples: These are good json messages
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | 12A64E97-6E6F-4C18-A78D-7844A827BF28 | { "FG.SerialNo": "20070811223?", "SubscriptionId":"12A64E97-6E6F-4C18-A78D-7844A827BF28", "Date":"1 day ago", "CollectTime":"today 010101", "Val.Mode":"AutoSet", "Val.Duration":600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 2.3, "Val.Leak.70" : 3.0, "Val.Leak.95": 4.3, "Val.Leak.Max": 5.0, "Val.TgtIPAP.50": 12.4, "Val.TgtIPAP.95": 13.0, "Val.TgtIPAP.Max": 14.8, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "EndCap",   "Val.HeatedTube": "15mm", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |

  @newport.validation.S34
  @ECO-10713
  Scenario Outline: Rejects unknown Flowgen Serial Number
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
    And the following device invalid therapy summaries events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | flowGenSerialNumber | ValidationVetoPoint | json   | ValidationFailureType | ValidationFailureReason          |
      | THERAPY_SUMMARY | 20070811224 | DEVICE           | 20070811224         | IDENTITY_VALIDATION | <JSON> | IDENTITY_FIELD        | Missing or unknown serial number |
  @valid.against.subscription
    Examples: These are good json messages
      | SubscriptionId                       | JSON                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | 12A64E97-6E6F-4C18-A78D-7844A827BF28 | { "FG.SerialNo": "20070811224", "SubscriptionId":"12A64E97-6E6F-4C18-A78D-7844A827BF28", "Date":"1 day ago", "CollectTime":"today 010101", "Val.Mode":"AutoSet", "Val.Duration":600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 2.3, "Val.Leak.70" : 3.0, "Val.Leak.95": 4.3, "Val.Leak.Max": 5.0, "Val.TgtIPAP.50": 12.4, "Val.TgtIPAP.95": 13.0, "Val.TgtIPAP.Max": 14.8, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "EndCap",   "Val.HeatedTube": "15mm", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
