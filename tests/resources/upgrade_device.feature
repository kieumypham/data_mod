@newport
@newport.upgrade
@ECO-4953

Feature:
  (ECO-4953) As an application support user
  I want to be able to upgrade the software on the therapy device
  In order that software problems can be addressed or new features added

  # ACCEPTANCE CRITERIA: (ECO-4953)
  # 1. The server shall allow a firmware upgrade request to be provided to a device.
  # 2. The server shall provide the size of the file and the CRC 16 of the file as part of the upgrade request. Note: This information does not need to be calculated by the server - it will be determined off-line.
  # Note 1: Protocol details at http://confluence.corp.resmed.org/display/CA/Software+Upgrade+-+new
  # Note 2: Example message is as follows:
  # GET /api/v1/upgrades/<uuid-A> HTTP/1.1
  # Accept: application/json
  #
  # HTTP/1.1 200 OK
  # Host: rtcs.us
  # Content-Length: 183
  # Content-Type: application/json
  #
  # {
  # "FG.SerialNo": "12345678901",
  # "UpgradeId": <uuid-A>,
  # "Type": "FG",
  # "Host": "10.1.1.1",
  # "Port": "80",
  # "FilePath": "/upgrade/sx1203-2201.bin",
  # "CRC": "C7D2",
  # "Size":12345
  # }
  # where <uuid-A> could be 6ba7b810-9dad-11d1-80b4-00c04fd430c8

  Background:
    Given the server receives the following manufacturing unit detail
      | resource                                                             |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg20070811223_cam20102141732_new.xml |
    And the server should not produce device manufactured error
    And the cached device list and cached responses are cleared
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |

  @newport.upgrade.S1 @newport.upgrade.flow_gen
  @ECO-4953.1 @ECO-4953.2
  Scenario: Device receives the correct upgrade for the upgrade request that the device requests.
    And the server has the following upgrades to be sent to devices
      | json                                                                                                                                                                                                           |
      | { "FG.SerialNo": "20070811223", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
      | { "FG.SerialNo": "20070811223", "UpgradeId": "DE6D76CF-36EB-4894-9041-EA8918762730", "Type": "CAM", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/cam-1203-2201.bin", "Size": 5432, "CRC": "A300" } |
      | { "FG.SerialNo": "20070811223", "UpgradeId": "354B66AF-6AB5-48F9-9091-9254E4A24A82", "Type": "Hum", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/hum-1203-2201.bin", "Size": 1098, "CRC": "F0D9" } |
    When I request the upgrade with identifier "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E"
    Then I should receive the following upgrade
      | json                                                                                                                                                                                                           |
      | { "FG.SerialNo": "20070811223", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |

  @newport.upgrade.S2 @newport.upgrade.cam
  @ECO-4953.1 @ECO-4953.2
  Scenario: Device receives the correct upgrade for the upgrade request that the device requests.
    And the server has the following upgrades to be sent to devices
      | json                                                                                                                                                                                                           |
      | { "FG.SerialNo": "20070811223", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
      | { "FG.SerialNo": "20070811223", "UpgradeId": "DE6D76CF-36EB-4894-9041-EA8918762730", "Type": "CAM", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/cam-1203-2201.bin", "Size": 5432, "CRC": "A300" } |
      | { "FG.SerialNo": "20070811223", "UpgradeId": "354B66AF-6AB5-48F9-9091-9254E4A24A82", "Type": "Hum", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/hum-1203-2201.bin", "Size": 1098, "CRC": "F0D9" } |
    When I request the upgrade with identifier "DE6D76CF-36EB-4894-9041-EA8918762730"
    Then I should receive the following upgrade
      | json                                                                                                                                                                                                           |
      | { "FG.SerialNo": "20070811223", "UpgradeId": "DE6D76CF-36EB-4894-9041-EA8918762730", "Type": "CAM", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/cam-1203-2201.bin", "Size": 5432, "CRC": "A300" } |

  @newport.upgrade.S3 @newport.upgrade.humidifier
  @ECO-4953.1 @ECO-4953.2
  Scenario: Device receives the correct upgrade for the upgrade request that the device requests.
    And the server has the following upgrades to be sent to devices
      | json                                                                                                                                                                                                           |
      | { "FG.SerialNo": "20070811223", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
      | { "FG.SerialNo": "20070811223", "UpgradeId": "DE6D76CF-36EB-4894-9041-EA8918762730", "Type": "CAM", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/cam-1203-2201.bin", "Size": 5432, "CRC": "A300" } |
      | { "FG.SerialNo": "20070811223", "UpgradeId": "354B66AF-6AB5-48F9-9091-9254E4A24A82", "Type": "Hum", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/hum-1203-2201.bin", "Size": 1098, "CRC": "F0D9" } |
    When I request the upgrade with identifier "354B66AF-6AB5-48F9-9091-9254E4A24A82"
    Then I should receive the following upgrade
      | json                                                                                                                                                                                                           |
      | { "FG.SerialNo": "20070811223", "UpgradeId": "354B66AF-6AB5-48F9-9091-9254E4A24A82", "Type": "Hum", "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/hum-1203-2201.bin", "Size": 1098, "CRC": "F0D9" } |

