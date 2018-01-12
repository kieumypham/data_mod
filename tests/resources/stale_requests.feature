@stale.requests.on.registration
@ECO-9864

Feature:
  (ECO-9864) As ECO
  I want to clear previously generated requests for a CAMBridge
  so that I only send new current requests to the device

# ACCEPTANCE CRITERIA: (ECO-9864)
#  1. On receipt of a registration message for an external CAM with a device, any subscription requests or LAST post
#  requests previously generated for that device that were not acknowledged shall be cancelled.
#  *Note:* This is to avoid having multiple subscriptions and LAST post requests in the queue for the FG.

  @stale.requests.on.registration.S1
  @ECO-9864.1
  Scenario: Managing pre-existing subscriptions and last post date in device + external cam registration
    Given the server completed bulk load the following devices and modules with status
      | jobFile                                                                  | jobStatus        |
      | /data/manufacturing/unit_detail_new_cam10000000001_fg_bdg22151763351.xml | COMPLETE-SUCCESS |
      | /data/manufacturing/unit_detail_new_cam10000000003_fg_bdg22151763361.xml | COMPLETE-SUCCESS |
      | /data/manufacturing/unit_detail_001_10000000003_new_camless.xml          | COMPLETE-SUCCESS |
    And the communication module "10000000001" uses mock Telco
    And the communication module "10000000003" uses mock Telco
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000001                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    And the server is given the following configurations to be sent to devices
      | json                                                                                                                                                                                                                                                             |
      | { "FG.SerialNo": "10000000003", "CAM.SerialNo": "10000000001", "ConfigurationId": "962cc963-43d8-44f9-a283-b114a184b4", "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/", "REGO-URI": "/v1/registrations/" } |
    And the server has the following upgrades to be sent to devices
      | json                                                                                                                                                                                                                                           |
      | { "FG.SerialNo": "10000000003", "CAM.SerialNo": "10000000001", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "CAM",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
      | { "FG.SerialNo": "10000000003", "CAM.SerialNo": "10000000001", "UpgradeId": "80302685-93BA-494F-AFFD-B27AEC759635", "Type": "CAM",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin", "Size": 9876, "CRC": "C7D2" }  |
    # First registration of the device
    When I send the following version 2 registration
      """
      {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G00001"},
      "Subscriptions": []
      }
      """
    Then the server should get the following device configuration change
      | json                                                                                                                                                      |
      | { "serialNo": "10000000003", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false} |
    And a subscription batch holding following subscriptions is queued for device with serial number "10000000003"
      | /data/subscription_E0C70BA1-FEE3-4445-9FF1-AD9942640000_10000000003.json |
      | /data/subscription_E0C70BA1-FEE3-4445-9FF1-AD9942641111_10000000003.json |
    Then by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 7 seconds
      | URI Fixed Part          | Content Identifier                   |
      | /api/v1/subscriptions/  | E0C70BA1-FEE3-4445-9FF1-AD9942640000 |
      | /api/v1/subscriptions/  | E0C70BA1-FEE3-4445-9FF1-AD9942641111 |
      | /api/v1/upgrades/       | B2AE8F06-1541-4616-AE6F-F9E4C079CC6E |
      | /api/v1/upgrades/       | 80302685-93BA-494F-AFFD-B27AEC759635 |
      | /api/v1/configurations/ | <ANY_UUID>                           |
      | /api/v1/configurations/ | <ANY_UUID>                           |
    Given the cached device list and cached responses are cleared
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000003                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000003" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    # Second registration of same device, where previous subscriptions and last post date exist
    When I send the following version 2 registration
      """
      {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000003", "Software": "SX588-0101", "PCBASerialNo":"13152G00003"},
      "Subscriptions": []
      }
      """
    Then the server should not log a device configuration change
    # Previous subscriptions and last post date must have been cancelled properly, or else there would be 2 more subscriptions and 1 more last post date
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 7 seconds
      | URI Fixed Part          | Content Identifier                   |
      | /api/v1/subscriptions/  | E0C70BA1-FEE3-4445-9FF1-AD9942640000 |
      | /api/v1/subscriptions/  | E0C70BA1-FEE3-4445-9FF1-AD9942641111 |
      | /api/v1/upgrades/       | B2AE8F06-1541-4616-AE6F-F9E4C079CC6E |
      | /api/v1/upgrades/       | 80302685-93BA-494F-AFFD-B27AEC759635 |
      | /api/v1/configurations/ | <ANY_UUID>                           |
      | /api/v1/configurations/ | <ANY_UUID>                           |

  @stale.requests.on.registration.S2
  @ECO-9864.1
  Scenario: Managing pre-existing subscriptions in device + internal cam registration
    Given the server completed bulk load the following devices and modules with status
      | jobFile                                          | jobStatus        |
      | /data/manufacturing/batch_new_fg4000_cam4000.xml | COMPLETE-SUCCESS |
      | /data/manufacturing/batch_new_cam1000.xml        | COMPLETE-SUCCESS |
    And the communication module "40000000001" uses mock Telco
    And the communication module "10000000005" uses mock Telco
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 40000000001               | 40000000001                     |
    And I am a device with the FlowGen serial number "40000000001"
    And I have been connected with CAM with serial number "40000000001" with authentication key "MzYxMDAwMDAwMDAwMTEwMDAwMDAwMDAx"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                                                     |
      | { "FG": {"SerialNo": "40000000001", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030008", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "40000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G00001", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And a subscription batch holding following subscriptions is queued for device with serial number "40000000001"
      | /data/subscription_UUID1_40000000001.json |
      | /data/subscription_UUID2_40000000001.json |
    Then by requesting messages for FG "40000000001" by myself I should eventually receive the following results in 10 seconds
      | URI Fixed Part            | Content Identifier  |
      | /api/v1/subscriptions/    | UUID-1              |
      | /api/v1/subscriptions/    | UUID-2              |
    # Second registration of same flow generator with a spared CAM
    Given the cached device list and cached responses are cleared
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 40000000001               | 10000000005                     |
    And I am a device with the FlowGen serial number "40000000001"
    And I have been connected with CAM with serial number "10000000005" with authentication key "123456789DAwMDAwNTEwMDAwMDAwMDA1"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                                                     |
      | { "FG": {"SerialNo": "40000000001", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030008", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "10000000005", "Software": "SX588-0101", "PCBASerialNo":"13152G00005", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    Then by requesting messages for FG "40000000001" by myself I should eventually receive the following results in 10 seconds
      | URI Fixed Part            | Content Identifier  |
      | /api/v1/subscriptions/    | UUID-1              |
      | /api/v1/subscriptions/    | UUID-2              |