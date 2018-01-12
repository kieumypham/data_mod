@newport
@newport.upgrade
@newport.batch_upgrade.V2
@ECO-10207
@ECO-16410

Feature:
  (ECO-10207) As an Applications Support user
  I want to be able to upgrade a list of external CAMs
  so that upgrades can be made in the field if necessary

  (ECO-16410) As an Applications Support user
  I want to be able to upgrade a list of devices
  so that modifications to devices can be made in the field if necessary

#  ACCEPTANCE CRITERIA: (ECO-10207)
#  Note 1: This card will open up a test case for ECO-9855, where was not able to seed a brokered message, specific for CAM, following a production work flow.
#
#  1. An Applications Support user shall be able to specify a list of external CAMs to upgrade.
#  2. The list of devices to upgrade shall be able to be specified using a csv file. *Note:* It is acceptable for the csv file to be consumed by the same end point as created for ECO-4964, and NGCS can differentiate by the information provided. Ie - if device type is an external CAM or bridge, then expect to receive External CAM serial number. Otherwise, then flowGenSerialNo is required.
#  3. For each device to be upgraded the following shall be specifiable:
#  3a. External CAM serial number;
#  3b. Whether to upgrade the CAM or the Bridge;
#  3c. The file to be used to upgrade the device including the host, port and file path; and
#  3d. The size and CRC of the upgrade file.
#  4. It shall be possible to specify more than one upgrade of the same external CAM in the list.  Note 1: For example this could be updating the CAM and the bridge, or it could be two successive upgrades of the CAM.
#  5. For each external CAM upgrade in the upgrade list ECO shall create a broker request to go on the external CAM request queue (see ECO-9855) for the upgrade as per http://confluence.corp.resmed.org/display/CA/Requests
#  6. ECO shall notify the external CAM of a pending upgrade request by sending an SMS to the external CAM.
#  7. In cases where there is more than one upgrade of the same external CAM in the list then the order of the broker requests shall correspond to the order of application of the upgrades.
#  8. SMS retry mechanism shall operate as per ECO-5571 for requests that have been added for the external CAM.
#
#  Note 2: This page covers OTA upgrades for Newports https://confluence.ec2.local/display/ECO/Newport+OTA+upgrades and should be appended to cover the above.
#  Note 3: It is perfectly acceptable for the upgrade facilities to be provided using back-end services such as using sql interfaces or via a command line.
#  Note 4: As per ECO-5078, details of the upgrade including software versions of all upgraded device types should be available on request.

#  ACCEPTANCE CRITERIA: (ECO-16410)
#  Note 1: Over-the-Air Firmware Upgrade request management is implemented by ECO-4964 and ECO-10207. This card expands on that implementation to allow the specification and sending of a SHA-256 hash of the firmware file as a security enhancement. No previous ACs will be altered or obsoleted.
#  1. An Application Support user shall be able to specify a firmware file hash value in the list of components to upgrade through a Comma Separated Value (CSV) file
#  Note 2: The firmware hash will be provided as a part of the cellular module software release from the CAM team. The server will simply accept the value and pass to the cellular module.
#  Note 3: The CRC will continue to be accepted and delivered to the cellular module. Older software versions will continue to use CRC. Newer software versions will ignore CRC and use the hash instead
#  2. For each component upgrade, the server shall create an upgrade brokered request that includes the firmware file hash value
#  Note 4: The JSON property name will be "FileHash256". An example looks like:
#  {
#  "FG.SerialNo" : "12345678901",
#  "UpgradeId" : "771DAF70-6E55-4346-A3BF-DB7E9B85B07B",
#  "Size" : 1052,
#  "FilePath" : "/fake/cam_upgrade.ota",
#  "Port" : "8080",
#  "Host" : "example.com",
#  "CRC" : "12EF",
#  "FileHash256" : "abcdefghijklmnopqrstuvwxyz0123456789ABCDEF=="
#  }
#  3. The server shall accept the upgrade status "HashMismatch" from the cellular module and treat as an upgrade failure
#  Note 5: https://confluence.ec2.local/display/NGCS/Over-the-Air+%28OTA%29+Firmware+Upgrade will be updated to reflect the enhancements


  Background:
    Given the server receives the following manufacturing unit detail
      | resource                                                            |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg88800000002_cam88800000002_new.xml|
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg88800000001_cam88810000001_new.xml |
    And the server waits for the device manufactured queue to be empty
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000002               | 88800000002                     |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000002"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000002", "Software": "SX567-0302", "MID": 26, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88800000002", "Software": "CAMABCDEFH", "PCBASerialNo":"2A3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "SX566-0302", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And the server bulk load the following devices and modules
      | /data/manufacturing/unit_detail_new_cam10000000001_fg_bdg22151763351.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the communication module "10000000001" uses mock Telco
    And the server bulk load the following devices and modules
      | /data/manufacturing/unit_detail_001_10000000003_new_camless.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And I am an external CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following external cam registration
      | json                                                                                                                                                                                                        |
      | {"Bridge" :{"Software": "SX-Bridge-Old","MID": 40,"VID": 46,"ProductCode": "28317","PCBASerialNo":"22151763351"}, "CAM" :{"SerialNo": "10000000001","Software": "SX588-0101","PCBASerialNo":"13152G00001"}} |
    And I request my broker requests for external CAM
    Then I should receive the following broker requests for external CAM
      | json                                            |
      | { "CAM.SerialNo": "10000000001", "Broker": [] } |
    And the server waits for all related device registration queues to be empty

  @newport.batch_upgrade.V2.S1
  @ECO-10207.1 @ECO-10207.2
  @ECO-10207.3a @ECO-10207.3b @ECO-10207.3c @ECO-10207.3d
  @ECO-10207.4 @ECO-10207.5 @ECO-10207.6
  @ECO-10207.7
  @ECO-10207.8
  @ECO-16410.1 @ECO-16410.2
  Scenario: Bulk upgrade job on V2 api
    When the following OTA-CSV job file is submitted on V2 upgrade api
      | deviceType | serialNo    | imageUrl                                         | fileSize | fileCrc | fileHash                                     |
      | EXT_CAM    | 10000000001 | http://localhost:5050/upgrades/ext_cam_SX111.bin | 456      | AA4F    | filehashijklmnopqrstuvwxyz0123456789ABCDEAA= |
      | BRIDGE     | 10000000001 | http://localhost:5050/upgrades/bridge_SX222.bin  | 789      | FFED    | abcd123456klmnopqrstuvwxyz0123456789ABCDEAA= |
      | FG         | 88800000001 | http://localhost:5050/upgrades/fg_SX333.bin      | 9876     | C7D2    | abcdefghijklmno456stuvwxyz012345678912345wA= |
      | CAM        | 88800000001 | http://localhost:5050/upgrades/cam_SX444.bin     | 456      | AA4F    | filehashijklmnopqrstuvwxyz0123456789ABCDEAA= |
      | FG         | 88800000001 | http://localhost:5050/upgrades/fg_SX555.bin      | 7777     | ABCD    | abcd123456klmnopqrstuvwxyz0123456789ABCDEAA= |
      | CAM        | 88800000001 | http://localhost:5050/upgrades/cam_SX666.bin     | 555      | BCDE    | abcdefghijklmno456stuvwxyz012345678912345wA= |
      | FG         | 88800000002 | http://localhost:5050/upgrades/fg_SX777.bin      | 9876     | C7D2    | filehashijklmnopqrstuvwxyz0123456789ABCDEAA= |
    # And I am an AppSupport personnel
    Then I should receive a successful OTA job submission result
    And eventually a call home SMS is sent for "each" device within 7 seconds
    # Check the CAM before it is connected to an FG
    Given I am an external CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I request my broker requests for external CAM
    Then I can get the following upgrade requests as listed in order
      | json                                                                                                                                                                                                                                                      |
      | { "CAM.SerialNo": "10000000001", "UpgradeId": "<ANY_UUID>", "Type": "EXT_CAM", "Host": "localhost", "Port": 5050, "FilePath": "/upgrades/ext_cam_SX111.bin", "Size": 456, "CRC": "AA4F", "FileHash256" : "filehashijklmnopqrstuvwxyz0123456789ABCDEAA=" } |
      | { "CAM.SerialNo": "10000000001", "UpgradeId": "<ANY_UUID>", "Type": "BRIDGE", "Host": "localhost", "Port": 5050, "FilePath": "/upgrades/bridge_SX222.bin", "Size": 789, "CRC": "FFED", "FileHash256" : "abcd123456klmnopqrstuvwxyz0123456789ABCDEAA=" }   |
    Given I am a device with the FlowGen serial number "88800000001"
    When I request my broker requests
    Then I can get the following upgrade requests as listed in order
      | json                                                                                                                                                                                                                                             |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "<ANY_UUID>", "Type": "FG", "Host": "localhost", "Port": 5050, "FilePath": "/upgrades/fg_SX333.bin", "Size": 9876, "CRC": "C7D2", "FileHash256" : "abcdefghijklmno456stuvwxyz012345678912345wA=" }  |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "<ANY_UUID>", "Type": "CAM", "Host": "localhost", "Port": 5050, "FilePath": "/upgrades/cam_SX444.bin", "Size": 456, "CRC": "AA4F", "FileHash256" : "filehashijklmnopqrstuvwxyz0123456789ABCDEAA=" } |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "<ANY_UUID>", "Type": "FG", "Host": "localhost", "Port": 5050, "FilePath": "/upgrades/fg_SX555.bin", "Size": 7777, "CRC": "ABCD", "FileHash256" : "abcd123456klmnopqrstuvwxyz0123456789ABCDEAA=" }  |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "<ANY_UUID>", "Type": "CAM", "Host": "localhost", "Port": 5050, "FilePath": "/upgrades/cam_SX666.bin", "Size": 555, "CRC": "BCDE", "FileHash256" : "abcdefghijklmno456stuvwxyz012345678912345wA=" } |

  @newport.batch_upgrade.V2.S2
  @ECO-10207.3a @ECO-10207.3b @ECO-10207.3c @ECO-10207.3d
  @ECO-10207.8 @ECO-16410.1
  Scenario Outline: Bad serial numbers (either communication module or flow generator) are found in the job.
    When the following OTA-CSV job file is submitted on V2 upgrade api
      | deviceType | serialNo           | imageUrl                                         | fileSize | fileCrc | fileHash                                     |
      | EXT_CAM    | <BadCam>           | http://localhost:5050/upgrades/ext_cam_SX111.bin | 456      | AA4F    | filehashijklmnopqrstuvwxyz0123456789ABCDEAA= |
      | BRIDGE     | 10000000001        | http://localhost:5050/upgrades/bridge_SX222.bin  | 789      | FFED    | abcd123456klmnopqrstuvwxyz0123456789ABCDEAA= |
      | FG         | <BadFlowGenerator> | http://localhost:5050/upgrades/fg_SX555.bin      | 9876     | C7D2    | abcdefghijklmno456stuvwxyz012345678912345wA= |
      | FG         | 88800000001        | http://localhost:5050/upgrades/fg_SX333.bin      | 9876     | C7D2    | filehashijklmnopqrstuvwxyz0123456789ABCDEAA= |
      | CAM        | 88800000001        | http://localhost:5050/upgrades/cam_SX444.bin     | 456      | AA4F    | abcd123456klmnopqrstuvwxyz0123456789ABCDEAA= |
    Then eventually a call home SMS is sent for "10000000001" device within 7 seconds
    And eventually a call home SMS is sent for "88800000001" device within 7 seconds
    When the OTA-CSV job status on V2 interface is checked
    Then the following upgrade report status is returned for V2 interface
      | DEVICE_TYPE | SERIAL_NO          | IMAGE_URL                                        | FILE_SIZE | FILE_CRC | FILE_HASH                                    | TASK_STATUS |
      | EXT_CAM     | <BadCam>           | http://localhost:5050/upgrades/ext_cam_SX111.bin | 456       | AA4F     | filehashijklmnopqrstuvwxyz0123456789ABCDEAA= | REJECTED    |
      | BRIDGE      | 10000000001        | http://localhost:5050/upgrades/bridge_SX222.bin  | 789       | FFED     | abcd123456klmnopqrstuvwxyz0123456789ABCDEAA= | ACCEPTED    |
      | FG          | 88800000001        | http://localhost:5050/upgrades/fg_SX333.bin      | 9876      | C7D2     | filehashijklmnopqrstuvwxyz0123456789ABCDEAA= | ACCEPTED    |
      | CAM         | 88800000001        | http://localhost:5050/upgrades/cam_SX444.bin     | 456       | AA4F     | abcd123456klmnopqrstuvwxyz0123456789ABCDEAA= | ACCEPTED    |
      | FG          | <BadFlowGenerator> | http://localhost:5050/upgrades/fg_SX555.bin      | 9876      | C7D2     | abcdefghijklmno456stuvwxyz012345678912345wA= | REJECTED    |
    # Individual upgrade task that has been rejected shall NOT result in an upgrade broker message
    Given I am an external CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I request my broker requests for external CAM
    Then I can get the following upgrade requests as listed in order
      | json                                                                                                                                                                                                                                                     |
      | { "CAM.SerialNo": "10000000001", "UpgradeId": "<ANY_UUID>", "Type": "BRIDGE", "Host": "localhost", "Port": 5050, "FilePath": "/upgrades/bridge_SX222.bin", "Size": 789, "CRC": "FFED", "FileHash256" : "abcd123456klmnopqrstuvwxyz0123456789ABCDEAA="  } |
    Given I am a device with the FlowGen serial number "88800000001"
    When I request my broker requests
    Then I can get the following upgrade requests as listed in order
      | json                                                                                                                                                                                                                                             |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "<ANY_UUID>", "Type": "FG", "Host": "localhost", "Port": 5050, "FilePath": "/upgrades/fg_SX333.bin", "Size": 9876, "CRC": "C7D2", "FileHash256" : "filehashijklmnopqrstuvwxyz0123456789ABCDEAA=" }  |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "<ANY_UUID>", "Type": "CAM", "Host": "localhost", "Port": 5050, "FilePath": "/upgrades/cam_SX444.bin", "Size": 456, "CRC": "AA4F", "FileHash256" : "abcd123456klmnopqrstuvwxyz0123456789ABCDEAA=" } |
    Examples:
      | BadCam      | BadFlowGenerator |
      | 10000000009 | 88800000005      |

  @newport.batch_upgrade.V2.S3
  @ECO-10207.1 @ECO-10207.2
  @ECO-10207.8 @ECO-16410.1
  Scenario: Batch upgrades - OTA-CSV job file with bad syntax
    When the following OTA-CSV job file with bad syntax is submitted on V2 interface
      | deviceType | flowGenSerialNo | camSerialNo | imageUrl                                         | fileSize | fileCrc | fileHash                                     |
      | FG         | 88800000001     |             | http://localhost:5050/upgrades/fg_SX111.bin      | 9876     | C7D2    | filehashijklmnopqrstuvwxyz0123456789ABCDEAA= |
      | EXT_CAM    |                 | 10000000001 | http://localhost:5050/upgrades/ext_cam_SX222.bin | 456      | AA4F    | abcdefghijklmno456stuvwxyz012345678912345wA= |
    Then I should receive a failed OTA job submission result

  @newport.batch_upgrade.V2.S4
  @ECO-10207.4 @ECO-10207.5 @ECO-10207.6
  @ECO-16410.1 @ECO-16410.2 @ECO-16410.3
  Scenario Outline: Removal of acknowledged upgrades from message broker
    When the server is given the following configurations to be sent to devices
      | json                                                                                                                                                                                                                                     |
      | {"CAM.SerialNo": "10000000001", "ConfigurationId": "12345678-43d8-44f9-a283-b114a184b4AB", "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/cams/", "REGO-URI": "/v1/registrations/" } |
    # Note: the second upgrade message would not be expected in production
    # NGCS will still deliver the message to CAM which should eventually reject the task
    And the server has the following upgrades to be sent to devices
      | json                                                                                                                                                                                                                                                           |
      | {"CAM.SerialNo": "10000000001", "UpgradeId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D9", "Type": "EXT_CAM", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/EXT_CAM_SX123.bin",  "Size": 9876, "CRC": "C7D2", "FileHash256" : "filehashijklmnopqrstuvwxyz0123456789ABCDEAA=" } |
      | {"CAM.SerialNo": "10000000001", "UpgradeId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/FG_SX123.bin", "Size": 9876, "CRC": "C7D2", "FileHash256" : "abcd123456klmnopqrstuvwxyz0123456789ABCDEAA=" }           |
    Given I am an external CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I acknowledge the upgrade with content identifier "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D9"
      | json                                                                                    |
      | { "CAM.SerialNo": "10000000001", "UpgradeId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D9", "Status": "Received" } |
    And I acknowledge the upgrade with content identifier "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7"
      | json                                                                                                 |
      | { "CAM.SerialNo": "10000000001", "UpgradeId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7", "Status": "<StatusUpdateFromCam>" } |
    When I request my broker requests for external CAM
    Then I should receive the following broker requests for external CAM
      | json                                                                                                    |
      | {"CAM.SerialNo":"10000000001","Broker":["/api/v1/configurations/12345678-43d8-44f9-a283-b114a184b4AB"]} |
    And I should receive a response code of "200"
    Examples:
      | StatusUpdateFromCam         |
      | RequestFailure              |
      | DownloadFailure             |
      | StorageFailure              |
      | ChecksumFailure             |
      | UpgradeFailure              |
      | ThreeFailedUpgradeAttempts  |
      | UpgradeAbandoned            |
      | Received                    |
      | Downloaded                  |
      | InvalidCamSerialNo          |
      | InvalidFgSerialNo           |
      | HashMismatch                |

  @newport.batch_upgrade.V2.S5
  @ECO-10207.3a @ECO-10207.3b @ECO-10207.3c @ECO-10207.3d
  @ECO-16410.1 @ECO-16410.2
  Scenario Outline: Report of upgrade job to include device software, registration time, upgrade status, acknowledged time and any error code
    Given I pause for 20 seconds
    When the following OTA-CSV job file is submitted on V2 upgrade api
      | deviceType | serialNo    | imageUrl                                         | fileSize | fileCrc | fileHash                                     |
      | EXT_CAM    | 10000000001 | http://localhost:5050/upgrades/ext_cam_SX111.bin | 456      | AA4F    | filehashijklmnopqrstuvwxyz0123456789ABCDEAA= |
      | BRIDGE     | 10000000001 | http://localhost:5050/upgrades/bridge_SX222.bin  | 789      | FFED    | abcd123456klmnopqrstuvwxyz0123456789ABCDEAA= |
      | FG         | 88800000001 | http://localhost:5050/upgrades/fg_SX333.bin      | 9876     | C7D2    | abcdefghijklmno456stuvwxyz012345678912345wA= |
      | CAM        | 88800000001 | http://localhost:5050/upgrades/cam_SX444.bin     | 456      | AA4F    | filehashijklmnopqrstuvwxyz0123456789ABCDEAA= |
      | FG         | <BadFgNo>   | http://localhost:5050/upgrades/fg_SX555.bin      | 7777     | ABCD    | abcd123456klmnopqrstuvwxyz0123456789ABCDEAA= |
    Then I should receive a successful OTA job submission result
    And eventually a call home SMS is sent for "10000000001" device within 7 seconds
    And eventually a call home SMS is sent for "88800000001" device within 7 seconds
    Given I am an external CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    And I reported the upgrade request of communication module as being "<CamUpgradeStatus>" and "<CamHttpResponse>"
    When the OTA-CSV job status on V2 interface is checked
    Then the following upgrade report status is returned for V2 interface
      | DEVICE_TYPE | SERIAL_NO   | TASKS_TATUS | UPGRADE_STATUS     | ACKNOWLEDGED_TIME | HTTP_RESPONSE_CODE | SOFTWARE       | REGISTERED_TIME | fileHash                                     |
      | EXT_CAM     | 10000000001 | ACCEPTED    | <CamUpgradeStatus> | NOT_NULL          | <CamHttpResponse>  | SX588-0101     | NOT_NULL        | filehashijklmnopqrstuvwxyz0123456789ABCDEAA= |
      | BRIDGE      | 10000000001 | ACCEPTED    | <CamUpgradeStatus> | NOT_NULL          | <CamHttpResponse>  | SX-Bridge-Old  | NOT_NULL        | abcd123456klmnopqrstuvwxyz0123456789ABCDEAA= |
      | FG          | 88800000001 | ACCEPTED    |                    |                   |                    | SX566-0302     | NOT_NULL        | abcdefghijklmno456stuvwxyz012345678912345wA= |
      | CAM         | 88800000001 | ACCEPTED    |                    |                   |                    | CAMABCDEFH     | NOT_NULL        | filehashijklmnopqrstuvwxyz0123456789ABCDEAA= |
      | FG          | <BadFgNo>   | REJECTED    |                    |                   |                    |                |                 | abcd123456klmnopqrstuvwxyz0123456789ABCDEAA= |
    # External CAM has gone through upgrade and sends renewing registration info with new SW version
    Given I send the following external cam registration
      | json                                                                                                                                                                                                         |
      | {"Bridge" :{"Software": "SX-Bridge-New","MID": 40,"VID": 46,"ProductCode": "28317","PCBASerialNo":"22151763351"}, "CAM" :{"SerialNo": "10000000001","Software": "CAM-SX02000","PCBASerialNo":"13152G00001"}} |
    Given I am a device with the FlowGen serial number "88800000001"
    And I reported the upgrade request of flow generator as being "<FgUpgradeStatus>" and "<FgHttpResponse>"
    When the OTA-CSV job status on V2 interface is checked
    # New EXT_CAM software is reflected as well as FG upgrade status
    Then the following upgrade report status is returned for V2 interface
      | DEVICE_TYPE | SERIAL_NO   | TASKS_TATUS | UPGRADE_STATUS     | ACKNOWLEDGED_TIME | HTTP_RESPONSE_CODE | SOFTWARE            | REGISTERED_TIME |
      | EXT_CAM     | 10000000001 | ACCEPTED    | <CamUpgradeStatus> | NOT_NULL          | <CamHttpResponse>  | CAM-SX02000         | NOT_NULL        |
      | BRIDGE      | 10000000001 | ACCEPTED    | <CamUpgradeStatus> | NOT_NULL          | <CamHttpResponse>  | SX-Bridge-New       | NOT_NULL        |
      | FG          | 88800000001 | ACCEPTED    | <FgUpgradeStatus>  | NOT_NULL          | <FgHttpResponse>   | SX566-0302          | NOT_NULL        |
      | CAM         | 88800000001 | ACCEPTED    | <FgUpgradeStatus>  | NOT_NULL          | <FgHttpResponse>   | CAMABCDEFH          | NOT_NULL        |
      | FG          | <BadFgNo>   | REJECTED    |                    |                   |                    |                     |                 |
    Examples:
      | CamUpgradeStatus | CamHttpResponse | BadFgNo    | FgUpgradeStatus  | FgHttpResponse |
      | DownloadFailure  | 500             | 9999999911 | Received         |                |
      | Received         |                 | 2223334445 | UpgradeAbandoned | 500            |
