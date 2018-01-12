@newport
@acknowledge.requests
@ECO-4833
@ECO-5581
@ECO-5884
@ECO-6467

Feature:
  (ECO-4833) As a clinician,
  I would like requests to be removed from the request broker when they are received by the device
  so they do not get delivered a second time

  (ECO-5581) As ECO
  I want to be able to receive CAM subscriptions on registration
  so that registration operations do not fail

  (ECO-5884) As an clinical user
  I only want data copied to a patient since the device was last erased
  so that I do not see data for previous patients

  (ECO-6467) Allow non-"Received" status to be persisted

  # ACCEPTANCE CRITERIA: (ECO-4833)
  # 1. When the device acknowledges a subscription request then that request shall be removed from the request broker.
  # 2. When the device acknowledges a settings change request then that request shall be removed from the request broker.
  # 3. When the device acknowledges a software upgrade request then that request shall be removed from the request broker.
  # Note 1: Protocol details: See subscription, settings, software upgrade etc at http://confluence.corp.resmed.org/display/CA/Wireless+Protocol+-+new
  #
  # PUT /api/v1/subscriptions/{uuid-D}/status HTTP/1.1
  # X-CamSerialNo: {serial number}
  # X-Hash: {hash}
  # {
  # "FG.SerialNo": "{serial number}",
  # "SubscriptionId": "{uuid-D}",
  # "Status": "(Received|*Failure)"
  # }

  # ACCEPTANCE CRITERIA: (ECO-5581)
  # 1. CAM subscription information during Registration should be able to be received as per http://confluence.corp.resmed.org/x/YwGz
  #
  # Note 1: It is not necessary at this stage to do anything with the CAM subscription information. The important thing is to prevent all registrations failing.

  # ACCEPTANCE CRITERIA: (ECO-5884)
  # 1. The last erase date shall be received from Newport devices and stored.
  # Note 1: The "Erases" interface described at http://confluence.corp.resmed.org/display/CA/Wireless+Protocol should be used for this purpose

  # ACCEPTANCE CRITERIA: (ECO-6467)
  # Currently, NGCS Newport will reject any status message from a CAM where the "Status" property is not "Received". This task is to relax the JSON Schema validation:
  # In definitions.json
  # Modify acknowledgementStatus to be a string of no more than 50 characters
  # Remove configurationAcknowledgementStatus
  # In message-status-schema.json, change configurationAcknowledgementStatus to acknowledgementStatus
  # Sanitize status value before inserting into the DB to prevent SQL injection attacks

  @acknowledge.requests.S1
  @ECO-4833.1 @ECO-4833.2 @ECO-4833.3
  @ECO-5581.1
  @ECO-5884.1
  Scenario Outline: Happy case, device acknowledges the retrieved message
    Given devices with following properties have been manufactured
      | moduleSerial | authKey      | flowGenSerial | deviceNumber | mid | vid | regionId | internalCommModule | productCode | pcbaSerialNo |
      | 20102141732  | 201913483157 | 20070811223   | 123          | 36  | 26  | 1        | true               | 9745        | 1A345678     |
    And the server waits for the device manufactured queue to be empty
    And the server should not produce device manufactured error
    And I am a device with the FlowGen serial number "20070811223"
    And the server has the following <MgtAPI> to be sent to devices
      | json          |
      | <RequestBody> |
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "FGABCDEFH", "MID": 36, "VID": 26, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "20102141732", "Software": "CAMABCDEFH", "PCBASerialNo":"1A345678", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And by requesting messages for FG "20070811223" with internal CAM I should eventually receive the following results in 5 seconds
      | URI Fixed Part     | Content Identifier |
      | <UriFixedPart>     | <UUID>             |
    When I acknowledge the <RequestType> with content identifier "<UUID>"
      | json                                                             |
      | { "FG.SerialNo": "20070811223", <AckKey>, "Status": "Received" } |
    Then I should receive a response code of "200"
    When I request my broker requests
    Then I should receive the following broker requests
      | json                                             |
      | { "FG.SerialNo": "20070811223", "Broker": [  ] } |
    Examples:
      | UriFixedPart              | MgtAPI           | RequestType      | UUID           | AckKey                         | RequestBody                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | /api/v1/upgrades/         | upgrades         | upgrade          | MyUpgrade      | "UpgradeId": "MyUpgrade"       | { "FG.SerialNo": "20070811223", "UpgradeId": "MyUpgrade", "Type": "Hum", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/hum-1203-2201.bin", "Size": 1098, "CRC": "F0D9" }                                                                                                                                                                                                                                                          |
      | /api/v1/subscriptions/    | subscriptions    | subscription     | SummaryCPAP    | "SubscriptionId":"SummaryCPAP" | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryCPAP", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | /api/v1/subscriptions/    | subscriptions    | subscription     | MyFaults       | "SubscriptionId":"MyFaults"    | { "FG.SerialNo": "20070811223", "SubscriptionId":"MyFaults", "ServicePoint":"/api/v1/faults", "Trigger":{ "Collect":[ "HALO", "Now" ], "OnlyOnChange":true }, "Data":[ "Fault.Device", "Fault.Humidifier", "Fault.HeatedTube" ] }                                                                                                                                                                                                            |
      | /api/v1/subscriptions/    | subscriptions    | subscription     | MyClimate      | "SubscriptionId": "MyClimate"  | { "FG.SerialNo": "20070811223", "SubscriptionId": "MyClimate", "ServicePoint": "/api/v1/climate/settings", "Trigger": { "Collect": [ "HALO", "Now" ], "OnlyOnChange": true }, "Data": [ "Val.ClimateControl", "Val.HumEnable", "Val.HumLevel", "Val.TempEnable", "Val.Temp", "Val.Tube", "Val.Mask", "Val.SmartStart" ] }                                                                                                                    |
      | /api/v1/therapy/settings/ | therapy settings | therapy settings | CPAPSettings01 | "SettingsId": "CPAPSettings01" | { "FG.SerialNo": "20070811223", "SettingsId": "CPAPSettings01","Set.Mode": "CPAP","CPAP.Set.Press":14.0,"CPAP.Set.StartPress":8.0,"CPAP.Set.EPR.EPREnable":"On","CPAP.Set.EPR.EPRType":"FullTime","CPAP.Set.EPR.Level":2,"CPAP.Set.Ramp.RampEnable":"On","CPAP.Set.Ramp.RampTime":30 }                                                                                                                                                       |
      | /api/v1/subscriptions/    | subscriptions    | subscription     | MyErasure      | "SubscriptionId": "MyErasure"  | { "FG.SerialNo": "20070811223", "SubscriptionId": "MyErasure", "ServicePoint": "/api/v1/erasures",         "Trigger": { "Collect": [ "HALO" ], "OnlyOnChange": true }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                     |

  @acknowledge.requests.S2
  @ECO-6467
  Scenario Outline: Device acknowledges the retrieved message
    Given the server receives the following manufacturing unit detail
      | resource                                                            |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111114444_cam11111114444_new.xml |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 11111114444               | 11111114444                     |
    And I am a device with the FlowGen serial number "11111114444"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "11111114444", "Software": "FGABCDEFH", "MID": 36, "VID": 25, "PCBASerialNo":"1A345678", "ProductCode":"37001", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "11111114444", "Software": "CAMABCDEFH", "PCBASerialNo":"123123444", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And I pause for 2 seconds
    And the server has the following <MgtAPI> to be sent to devices
      | json                                                                           |
      | { "FG.SerialNo": "11111114444", "<IdentifierKey>": "<UUID>", <RequestDetail> } |
    And by requesting messages for FG "11111114444" with internal CAM I should eventually receive the following results in 5 seconds
      | URI Fixed Part     | Content Identifier |
      | <UriFixedPart>     | <UUID>             |
    When I acknowledge the <RequestType> with content identifier "<UUID>"
      | json                                                                                |
      | { "FG.SerialNo": "11111114444", "<IdentifierKey>": "<UUID>", "Status": "<Status>" } |
    Then I should receive a response code of "200"
    When I request my broker requests
    Then I should receive the following broker requests
      | json                                             |
      | { "FG.SerialNo": "11111114444", "Broker": [  ] } |
    Examples: Received status, removes request from broker
      | UriFixedPart              | Status   | MgtAPI           | RequestType      | IdentifierKey   | UUID                                 | RequestDetail                                                                                                                                                                                                                                                                                                                                                              |
      | /api/v1/configurations/   | Received | configurations   | configuration    | ConfigurationId | 765938C3-11AE-4625-B093-E5AE757640DA | "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/", "REGO-URI": "/v1/registrations/"                                                                                                                                                                                                                                     |
      | /api/v1/subscriptions/    | Received | subscriptions    | subscription     | SubscriptionId  | 018A5655-81C6-4888-A2AD-6480087BE3B7 | "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] |
      | /api/v1/therapy/settings/ | Received | therapy settings | therapy settings | SettingsId      | 2DB630F3-6339-41BF-9FC6-872FEA7D8668 | "Set.Mode": "CPAP","CPAP.Set.Press":14.0,"CPAP.Set.StartPress":8.0,"CPAP.Set.EPR.EPREnable":"On","CPAP.Set.EPR.EPRType":"FullTime","CPAP.Set.EPR.Level":2,"CPAP.Set.Ramp.RampEnable":"On","CPAP.Set.Ramp.RampTime":30                                                                                                                                                      |
      | /api/v1/upgrades/         | Received | upgrades         | upgrade          | UpgradeId       | 87537B4B-FC37-4B52-868C-0A5B941C8B78 | "Type": "Hum", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/hum-1203-2201.bin", "Size": 1098, "CRC": "F0D9"                                                                                                                                                                                                                                                    |
    Examples: Non-Received status, removes request from broker
      | UriFixedPart              | Status                   | MgtAPI           | RequestType      | IdentifierKey   | UUID                                 | RequestDetail                                                                                                                                                                                                                                                                                                                                                              |
      | /api/v1/configurations/   | 9IDontUnderstand         | configurations   | configuration    | ConfigurationId | 765938C3-11AE-4625-B093-E5AE757640DA | "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/", "REGO-URI": "/v1/registrations/"                                                                                                                                                                                                                                     |
      | /api/v1/subscriptions/    | SubscriptionTypeNotKnown | subscriptions    | subscription     | SubscriptionId  | 018A5655-81C6-4888-A2AD-6480087BE3B7 | "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] |
      | /api/v1/therapy/settings/ | AnyStatusIWantToGive007  | therapy settings | therapy settings | SettingsId      | 2DB630F3-6339-41BF-9FC6-872FEA7D8668 | "Set.Mode": "CPAP","CPAP.Set.Press":14.0,"CPAP.Set.StartPress":8.0,"CPAP.Set.EPR.EPREnable":"On","CPAP.Set.EPR.EPRType":"FullTime","CPAP.Set.EPR.Level":2,"CPAP.Set.Ramp.RampEnable":"On","CPAP.Set.Ramp.RampTime":30                                                                                                                                                      |
    Examples: Upgrade status, removes request from broker
      | UriFixedPart      | Status                     | MgtAPI   | RequestType | IdentifierKey | UUID                                 | RequestDetail                                                                                                           |
      | /api/v1/upgrades/ | Downloaded                 | upgrades | upgrade     | UpgradeId     | 87537B4B-FC37-4B52-868C-0A5B941C8B78 | "Type": "Hum", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/hum-1203-2201.bin", "Size": 1098, "CRC": "F0D9" |
      | /api/v1/upgrades/ | RequestFailure             | upgrades | upgrade     | UpgradeId     | 87537B4B-FC37-4B52-868C-0A5B941C8B78 | "Type": "Hum", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/hum-1203-2201.bin", "Size": 1098, "CRC": "F0D9" |
      | /api/v1/upgrades/ | DownloadFailure            | upgrades | upgrade     | UpgradeId     | 87537B4B-FC37-4B52-868C-0A5B941C8B78 | "Type": "Hum", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/hum-1203-2201.bin", "Size": 1098, "CRC": "F0D9" |
      | /api/v1/upgrades/ | StorageFailure             | upgrades | upgrade     | UpgradeId     | 87537B4B-FC37-4B52-868C-0A5B941C8B78 | "Type": "Hum", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/hum-1203-2201.bin", "Size": 1098, "CRC": "F0D9" |
      | /api/v1/upgrades/ | ChecksumFailure            | upgrades | upgrade     | UpgradeId     | 87537B4B-FC37-4B52-868C-0A5B941C8B78 | "Type": "Hum", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/hum-1203-2201.bin", "Size": 1098, "CRC": "F0D9" |
      | /api/v1/upgrades/ | UpgradeFailure             | upgrades | upgrade     | UpgradeId     | 87537B4B-FC37-4B52-868C-0A5B941C8B78 | "Type": "Hum", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/hum-1203-2201.bin", "Size": 1098, "CRC": "F0D9" |
      | /api/v1/upgrades/ | ThreeFailedUpgradeAttempts | upgrades | upgrade     | UpgradeId     | 87537B4B-FC37-4B52-868C-0A5B941C8B78 | "Type": "Hum", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/hum-1203-2201.bin", "Size": 1098, "CRC": "F0D9" |
      | /api/v1/upgrades/ | UpgradeAbandoned           | upgrades | upgrade     | UpgradeId     | 87537B4B-FC37-4B52-868C-0A5B941C8B78 | "Type": "Hum", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/hum-1203-2201.bin", "Size": 1098, "CRC": "F0D9" |

  @acknowledge.requests.S3
  @ECO-4833.1 @ECO-4833.2 @ECO-4833.3
  @ECO-5581.1
  @ECO-5884.1
  Scenario: Device acknowledges the retrieved subscriptions with "Received" status
    Given the server receives the following manufacturing unit detail
      | resource                                                             |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg88800000001_cam88810000001_new.xml |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And the server has the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                     |
      | { "FG.SerialNo": "88800000001", "SubscriptionId":"SummaryCPAP","ServicePoint":"/api/v1/therapy/summaries","Trigger":"HALO","Schedule":{"StartDate":"01/01/2014","EndDate":null},"Data":["Val.Mode","Val.Duration","Val.MaskOn","Val.MaskOff","Val.What.Ever"]}                                                           |
      | { "FG.SerialNo": "88800000001", "SubscriptionId":"MyFaults", "ServicePoint":"/api/v1/faults", "Trigger":{ "Collect":[ "HALO", "Now" ], "OnlyOnChange":true }, "Data":[ "Fault.Device", "Fault.Humidifier", "Fault.HeatedTube" ] }                                                                                        |
      | { "FG.SerialNo": "88800000001", "SubscriptionId":"MyClimate", "ServicePoint": "/api/v1/climate/settings", "Trigger": { "Collect": [ "HALO", "Now" ], "OnlyOnChange": true }, "Data": [ "Val.ClimateControl", "Val.HumEnable", "Val.HumLevel", "Val.TempEnable", "Val.Temp", "Val.Tube", "Val.Mask", "Val.SmartStart" ] } |
      | { "FG.SerialNo": "88800000001", "SubscriptionId":"MyErasure", "ServicePoint": "/api/v1/erasures",         "Trigger": { "Collect": [ "HALO" ], "OnlyOnChange": true }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                  |
    Then by requesting messages for FG "88800000001" by myself I should eventually receive the following results in 30 seconds
      | URI Fixed Part         | Content Identifier |
      | /api/v1/subscriptions/ | SummaryCPAP        |
      | /api/v1/subscriptions/ | MyFaults           |
      | /api/v1/subscriptions/ | MyClimate          |
      | /api/v1/subscriptions/ | MyErasure          |
    When I request SUBSCRIPTION brokered requests for flow generator 88800000001
    Then I should receive all of the following subscriptions
      | { "FG.SerialNo": "88800000001", "SubscriptionId":"SummaryCPAP","ServicePoint":"/api/v1/therapy/summaries","Trigger":"HALO","Schedule":{"StartDate":"01/01/2014","EndDate":null},"Data":["Val.Mode","Val.Duration","Val.MaskOn","Val.MaskOff","Val.What.Ever"]}                                                           |
      | { "FG.SerialNo": "88800000001", "SubscriptionId":"MyFaults", "ServicePoint":"/api/v1/faults", "Trigger":{ "Collect":[ "HALO", "Now" ], "OnlyOnChange":true }, "Data":[ "Fault.Device", "Fault.Humidifier", "Fault.HeatedTube" ] }                                                                                        |
      | { "FG.SerialNo": "88800000001", "SubscriptionId":"MyClimate", "ServicePoint": "/api/v1/climate/settings", "Trigger": { "Collect": [ "HALO", "Now" ], "OnlyOnChange": true }, "Data": [ "Val.ClimateControl", "Val.HumEnable", "Val.HumLevel", "Val.TempEnable", "Val.Temp", "Val.Tube", "Val.Mask", "Val.SmartStart" ] } |
      | { "FG.SerialNo": "88800000001", "SubscriptionId":"MyErasure", "ServicePoint": "/api/v1/erasures",         "Trigger": { "Collect": [ "HALO" ], "OnlyOnChange": true }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                  |
    When I acknowledge the subscription with content identifier "SummaryCPAP"
      | json                                                                                    |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "SummaryCPAP", "Status": "Received" } |
    And I acknowledge the subscription with content identifier "MyFaults"
      | json                                                                                 |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "MyFaults", "Status": "Received" } |
    Then I should receive a response code of "200"
    And by requesting messages for FG "88800000001" by myself I should eventually receive the following results in 10 seconds
      | URI Fixed Part         | Content Identifier |
      | /api/v1/subscriptions/ | MyClimate          |
      | /api/v1/subscriptions/ | MyErasure          |
    When I acknowledge the subscription with content identifier "MyClimate"
      | json                                                                                  |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "MyClimate", "Status": "Received" } |
    And I acknowledge the subscription with content identifier "MyErasure"
      | json                                                                                  |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "MyErasure", "Status": "Received" } |
    Then I should receive a response code of "200"
    When I request my broker requests
    Then I should receive the following broker requests
      | json                                             |
      | { "FG.SerialNo": "88800000001", "Broker": [  ] } |

  @acknowledge.requests.S4
  @ECO-6467
  Scenario: Device acknowledges the retrieved subscriptions with status, which is not equal to "Received"
    Given the cached device list and cached responses are cleared
    Given the server receives the following manufacturing unit detail
      | resource                                                             |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg88800000001_cam88810000001_new.xml |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And the server has the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                      |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "SummaryCPAP","ServicePoint":"/api/v1/therapy/summaries","Trigger":"HALO","Schedule":{"StartDate":"01/01/2014","EndDate":null},"Data":["Val.Mode","Val.Duration","Val.MaskOn","Val.MaskOff","Val.What.Ever"]}                                                           |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "MyFaults", "ServicePoint":"/api/v1/faults", "Trigger":{ "Collect":[ "HALO", "Now" ], "OnlyOnChange":true }, "Data":[ "Fault.Device", "Fault.Humidifier", "Fault.HeatedTube" ] }                                                                                        |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "MyClimate", "ServicePoint": "/api/v1/climate/settings", "Trigger": { "Collect": [ "HALO", "Now" ], "OnlyOnChange": true }, "Data": [ "Val.ClimateControl", "Val.HumEnable", "Val.HumLevel", "Val.TempEnable", "Val.Temp", "Val.Tube", "Val.Mask", "Val.SmartStart" ] } |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "MyErasure", "ServicePoint": "/api/v1/erasures",         "Trigger": { "Collect": [ "HALO" ], "OnlyOnChange": true }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                  |
    And by requesting messages for FG "88800000001" by myself I should eventually receive the following results in 10 seconds
      | URI Fixed Part         | Content Identifier |
      | /api/v1/subscriptions/ | SummaryCPAP        |
      | /api/v1/subscriptions/ | MyFaults           |
      | /api/v1/subscriptions/ | MyClimate          |
      | /api/v1/subscriptions/ | MyErasure          |
    When I request SUBSCRIPTION brokered requests for flow generator 88800000001
    Then I should receive all of the following subscriptions
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "SummaryCPAP","ServicePoint":"/api/v1/therapy/summaries","Trigger":"HALO","Schedule":{"StartDate":"01/01/2014","EndDate":null},"Data":["Val.Mode","Val.Duration","Val.MaskOn","Val.MaskOff","Val.What.Ever"]}                                                           |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "MyFaults", "ServicePoint":"/api/v1/faults", "Trigger":{ "Collect":[ "HALO", "Now" ], "OnlyOnChange":true }, "Data":[ "Fault.Device", "Fault.Humidifier", "Fault.HeatedTube" ] }                                                                                        |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "MyClimate", "ServicePoint": "/api/v1/climate/settings", "Trigger": { "Collect": [ "HALO", "Now" ], "OnlyOnChange": true }, "Data": [ "Val.ClimateControl", "Val.HumEnable", "Val.HumLevel", "Val.TempEnable", "Val.Temp", "Val.Tube", "Val.Mask", "Val.SmartStart" ] } |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "MyErasure", "ServicePoint": "/api/v1/erasures",         "Trigger": { "Collect": [ "HALO" ], "OnlyOnChange": true }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                  |
    When I acknowledge the subscription with content identifier "SummaryCPAP"
      | json                                                                                    |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "SummaryCPAP", "Status": "Received" } |
    And I acknowledge the subscription with content identifier "MyFaults"
      | json                                                                                 |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "MyFaults", "Status": "NotKnown" } |
    Then I should receive a response code of "200"
    And by requesting messages for FG "88800000001" by myself I should eventually receive the following results in 10 seconds
      | URI Fixed Part         | Content Identifier |
      | /api/v1/subscriptions/ | MyClimate          |
      | /api/v1/subscriptions/ | MyErasure          |
    When I acknowledge the subscription with content identifier "MyClimate"
      | json                                                                                  |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "MyClimate", "Status": "Received" } |
    And I acknowledge the subscription with content identifier "MyErasure"
      | json                                                                                          |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "MyErasure", "Status": "NotUnderstanding" } |
    Then I should receive a response code of "200"
    When I request my broker requests
    Then I should receive the following broker requests
      | json                                             |
      | { "FG.SerialNo": "88800000001", "Broker": [  ] } |
