@newport
@newport.pairing
@ECO-10070

Feature:

  (ECO-10070) As ECO
  I want to receive pairing messages indicating connectivity between an external CAM and a device
  so that I can keep records up to date

# ACCEPTANCE CRITERIA: (ECO-10070)
#  1. The server shall receive external CAM and device pairing information from therapy devices using version 2 of the registration end point ie. v2.
#  2. A pairing message shall be identified by registration content only including the FG and External CAM serial numbers and omission of other registration information.
#  *For example:*
#  {code}
#  PUT  /api/v2/registrations/{A serial number}  HTTP/1.1
#  X-CamSerialNo: {serial number}
#  X-Hash: {hash}
#
#  {
#  "FG": {
#  "SerialNo": "{A serial number}"
#  },
#  "CAM": {
#  "SerialNo": "{serial number}"
#  }
#  }
#  {code}
#  3. If the device's (FG) last registration was not with the provided external CAM then an error (HTTP424) shall be returned. *Note:* This will force the external CAM to go back through its registration cycle.
#  4. If the device's (FG) last registration was with the provided external CAM then a success response (HTTP200) shall be returned. *Note:* This will allow the external CAM to proceed without registering.
#
#  *Note1:* Error conditions on this interface will be handled separately.

  Background:
    Given the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_fg2000_cam2000.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    When the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_fg1090_cam1090.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    When the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_fg1000.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    When the server bulk load the following devices and modules
      | /data/manufacturing/unit_detail_new_cam10000000001_bdg22151763351.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    When the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_cam10000000002_bdg22151763341.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |

  @newport.pairing.S1
  @ECO-10070.1 @ECO-10070.2 @ECO-10070.4
  Scenario: Received pairing message from registered communication module with its currently paired flow generator.
    Given the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 10000000003               |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G10001"},
      "Subscriptions": []
    }
    """
    Then 1 count of registration history where flow generator has an paired communication module has been added
    And the communication module with serial number "10000000001" should be paired with the flow generator with serial number "10000000003"
    When I send the following pairing message
    """
    {"FG":{"SerialNo": "10000000003"}, "CAM": {"SerialNo": "10000000001"}}
    """
    Then 1 count of registration history where flow generator has an paired communication module is found
    And I should receive a response code of "200"
    # Verifying pairing is preserved (unchanged from last registration)
    And the communication module with serial number "10000000001" should be paired with the flow generator with serial number "10000000003"
    And the server should not log an invalid registration

  @newport.pairing.S2
  @ECO-10070.1 @ECO-10070.2 @ECO-10070.3
  Scenario: Received pairing message from registered communication module with a flow generator not currently paired.
    Given the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 10000000003               |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
  """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G10001"},
      "Subscriptions": []
    }
    """
    Then the communication module with serial number "10000000001" should be paired with the flow generator with serial number "10000000003"
    When I send the following pairing message
  """
    {"FG":{"SerialNo": "10000000004"}, "CAM": {"SerialNo": "10000000001"}}
  """
    Then I should receive a response code of "424"
    # Verifying pairing is preserved (unchanged from last registration and undamaged from unsuccessful pairing)
    And the communication module with serial number "10000000001" should be paired with the flow generator with serial number "10000000003"

  @newport.pairing.S3
  @ECO-10070.1 @ECO-10070.2 @ECO-10070.3
  Scenario: Received pairing message from non-registered communication module and flow generator
    Given the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 10000000003               |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following pairing message
  """
    {"FG":{"SerialNo": "10000000003"}, "CAM": {"SerialNo": "10000000001"}}
  """
    Then I should receive a response code of "424"
    And the communication module with serial number "10000000001" should not be paired with any flow generator

  @newport.pairing.S4
  @ECO-10070.1 @ECO-10070.2 @ECO-10070.3
  Scenario: Received pairing message from previously registered and paired communication module and flow generator
    Given the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 10000000003               |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G10001"},
      "Subscriptions": []
    }
    """
    Then 1 count of registration history where flow generator has an paired communication module has been added
    Given the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 10000000004               |
    And I am a device with the FlowGen serial number "10000000004"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000004", "Software": "SX567-0100", "MID": 36, "VID": 33, "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G10001"},
      "Subscriptions": []
    }
    """
    Then 1 count of registration history where flow generator has an paired communication module has been added
    When I send the following pairing message
  """
    {"FG":{"SerialNo": "10000000003"}, "CAM": {"SerialNo": "10000000001"}}
  """
    Then I should receive a response code of "424"
    # Verify that existing pairing is not damaged after unsuccessful pairing message
    And the communication module with serial number "10000000001" should be paired with the flow generator with serial number "10000000004"

  @newport.pairing.S5
  @ECO-10070.1 @ECO-10070.2
  Scenario: Received message that fails schema validation for both V1, V2 registrations as well as pairing
    Given the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 10000000003               |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G10001"}
    }
    """
    Then 0 count of registration history where flow generator has an paired communication module has been added
    And I should receive a response code of "200"
    And the communication module with serial number "10000000001" should not be paired with any flow generator
    Then the server should get the following invalid registration
      | json                                                                                                                          |
      | {"FG":{"SerialNo": "10000000003"},"CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G10001"}} |

  @newport.pairing.S6
  @ECO-10070.1 @ECO-10070.2 @ECO-10070.4
  Scenario: Received pairing message from paired and registered flow generator with internal communication module.
    Given the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 20000000005               |
    And I am a device with the FlowGen serial number "20000000005"
    And I have been connected with CAM with serial number "20000000006" with authentication key "MzYxMDAwMDAwMDAwMTEwMDAwMDAwMDAx"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "20000000005", "Software": "SX567-0100", "MID": 36, "VID": 25, "ProductCode":"37001"},
      "CAM": {"SerialNo": "20000000006", "Software": "SX558-0100", "PCBASerialNo":"23152G00005"},
      "Subscriptions": []
    }
    """
    Then 1 count of registration history where flow generator has an paired communication module has been added
    And I should receive a response code of "200"
    When I send the following pairing message
    """
    {
      "FG":{"SerialNo": "20000000005"}, "CAM": {"SerialNo": "20000000006"}
    }
    """
    Then 1 count of registration history where flow generator has an paired communication module has been added
    And I should receive a response code of "200"

  @newport.pairing.S7
  @ECO-10070.1 @ECO-10070.2 @ECO-10070.3
  Scenario: Received pairing message from paired but not yet registered flow generator with internal communication module
    Given the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 10900000002               |
    And I am a device with the FlowGen serial number "10900000002"
    When I have been connected with CAM with serial number "10900000002" with authentication key "MzYxMDAwMDAwMDAwMjEwMDAwMDAwMDAy"
    Then the communication module with serial number "10900000002" should be paired with the flow generator with serial number "10900000002"
    When I send the following pairing message
  """
  {
    "FG":{"SerialNo": "10900000002"}, "CAM": {"SerialNo": "10900000002"}
  }
  """
    Then 0 count of registration history where flow generator has an paired communication module has been added
    And I should receive a response code of "424"
