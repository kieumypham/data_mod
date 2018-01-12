@newport
@newport.upgrade
@newport.batch_upgrade
@newport.batch_upgrade.V1
@ECO-4964
@ECO-5077
@ECO-5078
@ECO-5581

Feature:
  (ECO-4964) As an Applications Support user
  I want to be able to upgrade a list of devices
  so that modifications to devices can be made in the field if necessary.

  (ECO-5077) As an Applications Support user
  I want to be able to upgrade a list of devices
  so that modifications to devices can be made in the field if necessary.

  (ECO-5078) As an Applications Support user
  I want to be able to view a list of devices and their status
  so that I can track the firmware upgrade process.

  (ECO-5581) As ECO
  I want to be able to receive CAM subscriptions on registration
  so that registration operations do not fail

  # ACCEPTANCE CRITERIA: (ECO-4964)
  # 1. An Applications Support user shall be able to specify a list of devices to upgrade.
  # 2. The list of devices to upgrade shall be able to be specified using a csv file.
  # 3. For each device to be upgraded the following shall be specifiable:
  # 3a. Device serial number;
  # 3b. Whether to upgrade the device, the CAM or the Humidifier;
  # 3c. The file to be used to upgrade the device including the host, port and file path; and
  # 3d. The size and CRC of the upgrade file.
  # 4. It shall be possible to specify more than one upgrade of the same device in the list. Note 1: For example this could be updating the FG and CAM, or it could be two successive upgrades of the FG.
  # 5. For each device upgrade in the upgrade list ECO shall create a broker request for the upgrade as per http://confluence.corp.resmed.org/display/CA/Request
  # 6. ECO shall notify the device of a pending upgrade request by sending an SMS to the device.
  # 7. ECO shall allow the device, CAM or humidifier to be upgraded as per http://confluence.corp.resmed.org/display/CA/OTA+Software+Upgrade
  # 8. In cases where there is more than one upgrade of the same device in the list then the order of the broker requests shall correspond to the order of application of the upgrades.
  # Note 2: A confluence page will be written to describe how to perform an upgrade
  # Note 3: It is perfectly acceptable for the upgrade facilities to be provided using back-end services such as using sql interfaces or via a command line.

  # ACCEPTANCE CRITERIA: (ECO-5077)
  # 1. The user shall be informed of whether each upgrade request is accepted or rejected. Note 2: Accepting means ECO accepting to attempt the upgrade.
  # 2. An upgrade request shall be rejected as per AC#6 if the syntax of the request cannot be interpreted successfully.
  # 3. An upgrade request shall be rejected as per AC#6 if the device serial number is not a known Newport device.
  # 4. If a device reports a failed upgrade then ECO shall remove any pending upgrade requests for that device from the request broker.

  # ACCEPTANCE CRITERIA: (ECO-5078)
  # 1. An Applications Support user shall be able to determine the upgrade status for each device including the following:
  # 1a. Whether the file is reported as being downloaded including the server date/time
  # 1b. Whether a download/upgrade failure was reported including any error code and the the server date/time
  # 1c. The current versions of software on the device from the most recent registation including the server date/time
  # Note 1: It is NOT acceptable to use log files to determine upgrade status as this will need to be able to be done in bulk and the progress regularly checked.

  # ACCEPTANCE CRITERIA: (ECO-5581)
  # 1. CAM subscription information during Registration should be able to be received as per http://confluence.corp.resmed.org/x/YwGz
  #
  # Note 1: It is not necessary at this stage to do anything with the CAM subscription information. The important thing is to prevent all registrations failing.

  Background:
    Given the server receives the following manufacturing unit detail
      | resource                                                             |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg88800000001_cam88810000001_new.xml |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg88800000002_cam88800000002_new.xml|
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
      | 88800000002               | 88800000002                     |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "SX567-0302", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And I am a device with the FlowGen serial number "88800000002"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000002", "Software": "SX567-0302", "MID": 26, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88800000002", "Software": "CAMABCDEFH", "PCBASerialNo":"2A3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And I pause for 5 seconds

  @ECO-4964.1 @ECO-4964.2
  @ECO-4964.3 @ECO-4964.3a @ECO-4964.3b @ECO-4964.3c @ECO-4964.3d
  @ECO-4964.4 @ECO-4964.5 @ECO-4964.6 @ECO-4964.8
  @newport.batch_upgrade.S1
  Scenario: Batch upgrades - clean case multiple upgrades
    When the following OTA-CSV job file is submitted on V1 upgrade api
      | deviceType | flowGenSerialNo | imageUrl                                        | fileSize | fileCrc |
      | FG         | 88800000001     | http://localhost:5050/upgrades/fg-1203-2201.bin | 9876     | C7D2    |
      | CAM        | 88800000001     | http://localhost:5050/upgrades/cam44542.bin     | 456      | AA4F    |
      | FG         | 88800000002     | http://localhost:5050/upgrades/fg-1203-2201.bin | 9876     | C7D2    |
    Then I should receive a successful OTA job submission result
    And I verify that there is ONE Upgrade Job and three Upgrade Job tasks
    And eventually a call home SMS is sent for "each" device within 7 seconds
    And each device receives in order a corresponding upgrade task from the message broker

  @ECO-5077.1 @ECO-5077.2
  @newport.batch_upgrade.S2
  Scenario: Batch upgrades - OTA-CSV job file with bad syntax
    When the following OTA-CSV job file with bad syntax is submitted on V1 interface
      | deviceType | flowGenSerialNo | imageUrl                                        | fileSize | fileCrc |
      | FG         | 88800000001     | http://localhost:5050/upgrades/fg-1203-2201.bin | 9876     | C7D2    |
      | CAM        | 88800000001     | http://localhost:5050/upgrades/cam44542.bin     | 456      | AA4F    |
      | FG         | 88800000002     | http://localhost:5050/upgrades/fg-1203-2201.bin | 9876     | C7D2    |
    Then I should receive a failed OTA job submission result

  @ECO-5077.1 @ECO-5077.3
  @newport.batch_upgrade.S3
  Scenario: Batch upgrades - OTA-CSV job file with unknown device serial
    When the following OTA-CSV job file is submitted on V1 upgrade api
      | deviceType | flowGenSerialNo | imageUrl                                        | fileSize | fileCrc |
      | FG         | 88800000099     | http://localhost:5050/upgrades/fg-1203-2201.bin | 9876     | C7D2    |
      | CAM        | 88800000099     | http://localhost:5050/upgrades/cam44542.bin     | 456      | AA4F    |
      | FG         | 88800000099     | http://localhost:5050/upgrades/fg-1203-2201.bin | 9876     | C7D2    |
    Then I should receive a successful OTA job submission result
    And eventually all upgrade job tasks for FlowGen "88800000099" should be REJECTED

  @ECO-5077.4
  @ECO-8464
  @newport.batch_upgrade.S4
  Scenario Outline: Failed upgrade is removed from message broker without removing other types of requests
    And I am a device with the FlowGen serial number "88800000001"
    And devices with following properties have been manufactured
      | moduleSerial | authKey      | flowGenSerial | deviceNumber | mid | vid | pcbaSerialNo | internalCommModule  |
      | 31213252843  | 312023494168 | 31181922334   | 124          | 36  | 26  | 124124124    | true                |
    And the server waits for the device manufactured queue to be empty
    And the server should not produce device manufactured error
    And the server has the following upgrades to be sent to devices
      | json                                                                                                                                                                                 |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D3", "Type": "Hum", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/hum-1203-2201.bin", "Size": 1098, "CRC": "F0D9" } |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D9", "Type": "FG", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin", "Size": 9876, "CRC": "C7D2" }   |
    And the server has the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "7E293B00-9396-48A8-945E-A61712BAD67E", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max",                                                        "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "02ea52a6-b826-4749-ae9b-8c5fbc7d43c5",  "ServicePoint": "/api/v1/erasures",         "Trigger": { "Collect": [ "HALO" ], "OnlyOnChange": true }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                          |
      | { "FG.SerialNo": "31181922334", "SubscriptionId": "3E05F22E-F1B1-4BA4-A89D-01398C41F775", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.TgtIPAP.50", "Val.TgtIPAP.95", "Val.TgtIPAP.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
    And the server has the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                           |
      | { "FG.SerialNo": "88800000001", "SettingsId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7", "Set.Mode": "CPAP", "CPAP.Set.Press": 14.0, "CPAP.Set.StartPress": 8.0, "CPAP.Set.EPR.EPREnable": "On", "CPAP.Set.EPR.EPRType": "FullTime", "CPAP.Set.EPR.Level": 2, "CPAP.Set.Ramp.RampEnable": "On", "CPAP.Set.Ramp.RampTime": 30 }                                                                                    |
      | { "FG.SerialNo": "31181922334", "SettingsId": "9E66F8DA-0428-4FFE-B035-766DAB96621C", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" } |
    When I acknowledge the upgrade with content identifier "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D3"
      | json                                                                              |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D3", "Status": "Received" } |
    And I acknowledge the upgrade with content identifier "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D3"
      | json                                                                             |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D3", "Status": "<Error>" } |
    Then by requesting messages for FG "88800000001" by myself I should eventually receive the following results in 20 seconds
      | URI Fixed Part            | Content Identifier                   |
      | /api/v1/subscriptions/    | 7E293B00-9396-48A8-945E-A61712BAD67E |
      | /api/v1/subscriptions/    | 02ea52a6-b826-4749-ae9b-8c5fbc7d43c5 |
      | /api/v1/therapy/settings/ | DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7 |
    And I should receive a response code of "200"
    Examples:
      | Error                      |
      | RequestFailure             |
      | DownloadFailure            |
      | StorageFailure             |
      | ChecksumFailure            |
      | UpgradeFailure             |
      | ThreeFailedUpgradeAttempts |
      | UpgradeAbandoned           |

  @ECO-5077.4
  @newport.batch_upgrade.S5
  Scenario Outline: Failed upgrade is removed from message broker
    And I am a device with the FlowGen serial number "88800000001"
    And the server has the following upgrades to be sent to devices
      | json                                                                                                                                                                                 |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D3", "Type": "Hum", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/hum-1203-2201.bin", "Size": 1098, "CRC": "F0D9" } |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D9", "Type": "FG", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin", "Size": 9876, "CRC": "C7D2" }   |
    When I acknowledge the upgrade with content identifier "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D3"
      | json                                                        |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D3" } |
    And I acknowledge the upgrade with content identifier "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D3"
      | json                                                                             |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D3", "Status": "<Error>" } |
    And I request my broker requests
    Then I should receive the following broker requests
      | json                                             |
      | { "FG.SerialNo": "88800000001", "Broker": [  ] } |
    And I should receive a response code of "200"
    Examples:
      | Error                      |
      | RequestFailure             |
      | DownloadFailure            |
      | StorageFailure             |
      | ChecksumFailure            |
      | UpgradeFailure             |
      | ThreeFailedUpgradeAttempts |
      | UpgradeAbandoned           |

  @ECO-5077.3 @ECO-5078.1
  @newport.batch_upgrade.S6
  Scenario: FG Serial is not recognized.
    When the following OTA-CSV job file is submitted on V1 upgrade api
      | deviceType | flowGenSerialNo | imageUrl                                        | fileSize | fileCrc |
      | FG         | 88800000001     | http://localhost:5050/upgrades/fg-1203-2201.bin | 9876     | C7D2    |
      | FG         | 88800000003     | http://localhost:5050/upgrades/fg-1203-2201.bin | 9876     | C7D2    |
      | CAM        | 88800000001     | http://localhost:5050/upgrades/cam44542.bin     | 456      | AA4F    |
      | FG         | 88800000002     | http://localhost:5050/upgrades/fg-1203-2201.bin | 9876     | C7D2    |
    Then eventually a call home SMS is sent for "88800000001" device within 7 seconds
    And eventually a call home SMS is sent for "88800000002" device within 7 seconds
    When the OTA-CSV job status on V1 interface is checked
    Then the following upgrade report status is returned for V1 interface
      | DEVICE_TYPE | FLOW_GEN_SERIAL_NO  | TASK_STATUS |
      | FG          | 88800000001         | ACCEPTED    |
      | CAM         | 88800000001         | ACCEPTED    |
      | FG          | 88800000002         | ACCEPTED    |
      | FG          | 88800000003         | REJECTED    |

  @ECO-5078.1 @ECO-5078.1a @ECO-5078.1b, @ECO-5078.1c
  @newport.batch_upgrade.S7
  @ECO-5581.1
  Scenario Outline: Device software, registration time, upgrade status, acknowledged time and any error code are reported
    When the following OTA-CSV job file is submitted on V1 upgrade api
      | deviceType | flowGenSerialNo | imageUrl                                        | fileSize | fileCrc |
      | FG         | 88800000001     | http://localhost:5050/upgrades/fg-1203-2201.bin | 9876     | C7D2    |
      | CAM        | 88800000001     | http://localhost:5050/upgrades/cam44542.bin     | 456      | AA4F    |
      | FG         | 88800000002     | http://localhost:5050/upgrades/fg-1203-2201.bin | 9876     | C7D2    |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000002               | 88800000002                     |
    And I am a device with the FlowGen serial number "88800000002"
    Then eventually 1 upgrade task will be created within 10 seconds
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000002", "Software": "FGABCDEFH", "MID": 26, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88800000002", "Software": "CAMABCDEFH", "PCBASerialNo":"2A3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And I reported the upgrade request of flow generator as being "<UpgradeStatus>" and "<HttpResponseCode>"
    And the OTA-CSV job status on V1 interface is checked
    Then the following upgrade report status is returned for V1 interface
      | DEVICE_TYPE | FLOW_GEN_SERIAL_NO  | TASKS_TATUS | UPGRADE_STATUS  | ACKNOWLEDGED_TIME | HTTP_RESPONSE_CODE | SOFTWARE   | REGISTERED_TIME |
      | FG          | 88800000001         | ACCEPTED    |                 |                   |                    | SX567-0302 |                 |
      | CAM         | 88800000001         | ACCEPTED    |                 |                   |                    | CAMABCDEFH | NOT_NULL        |
      | FG          | 88800000002         | ACCEPTED    | <UpgradeStatus> | NOT_NULL          | <HttpResponseCode> | FGABCDEFH  | FGABCDEFH       |
    Examples:
      | UpgradeStatus              | HttpResponseCode |
      | Received                   |                  |
      | RequestFailure             |                  |
      | DownloadFailure            | 500              |
      | StorageFailure             |                  |
      | ChecksumFailure            |                  |
      | UpgradeFailure             |                  |
      | ThreeFailedUpgradeAttempts |                  |
      | UpgradeAbandoned           |                  |

  @ECO-5078.1 @ECO-5078.1a @ECO-5078.1b, @ECO-5078.1c
  @newport.batch_upgrade.S8
  @ECO-5581.1
  Scenario: Device software version status is shown with successful case
    When the following OTA-CSV job file is submitted on V1 upgrade api
      | deviceType | flowGenSerialNo | imageUrl                                        | fileSize | fileCrc |
      | FG         | 88800000001     | http://localhost:5050/upgrades/fg-1203-2201.bin | 9876     | C7D2    |
    And I am a device with the FlowGen serial number "88800000001"
    Then eventually 1 upgrade task will be created within 10 seconds
    When I reported the upgrade request of flow generator as being "Downloaded" and ""
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                            |
      | { "FG": {"SerialNo": "88800000001", "Software": "FGZZZZZZ", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And the OTA-CSV job status on V1 interface is checked
    Then the following upgrade report status is returned for V1 interface
      | DEVICE_TYPE | FLOW_GEN_SERIAL_NO  | TASKS_TATUS | UPGRADE_STATUS  | ACKNOWLEDGED_TIME | HTTP_RESPONSE_CODE  | SOFTWARE    | REGISTERED_TIME |
      | FG          | 88800000001         | ACCEPTED    | Downloaded      | NOT_NULL          |                     | FGZZZZZZ    | NOT_NULL        |
