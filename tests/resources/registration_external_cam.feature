@newport
@newport.registration.external.cam
@ECO-9414
@ECO-12819

Feature:

  (ECO-9414) As a user
   I want up to date information on devices
  so that I can manage and update them as required
  (ECO-12819) As NGCS
   I want to store newly manufactured CAM units with a status of PROVISIONED instead of ACTIVE,
   so that NGCS can properly manage suspend state for CAMs.

  # ACCEPTANCE CRITERIA: (ECO-9414)
  #  Note1: This story builds on ECO-4775 which created the registration end point for S10 devices. This story is to create a new end point
  #  for CAMBridge registration.
  #  1. The server shall provide a registration end point for external CAMs to register without their connected device.
  #  Note: Also known as CAMBridge. An external CAM is identified through the mfg post node "internal=false", refer to ECO-5391 AC 1t.
  #  2. Connection authentication from external CAMs with bridges on this end point shall be performed as per ECO-4832.
  #  3. Registration history for each device as per AC#1 shall be stored.
  #
  #  Note2: The CAMBridge will also be sending registration messages for a connected Astral or Stellar and these will go
  #  to the existing registration end point for devices as per AC2 above and is covered in ECO-9421.
  #  Note3: The CAMBridge will always send its registration message for CAMBridge information alone first, followed by a
  #  registration message for a connected Astral/Stellar (if one is connected).
  #  Note4: A separate story will cover adding error scenarios to this end point to ensure it gracefully rejects CAM
  #  registration attempts with included device information.
  #  Note5: The example provided below contains the key fields for a CAMBridge device, there is likely to be further information
  #  added to this registration message that will be captured in a future card, likely specific to the bridge information.
  #
  #  PUT /api/v1/registrations/cams/<CAMSerialNo> HTTP/1.1
  #  X-CamSerialNo: <CAMSerialNo>
  #  X-Hash: <Hash>
  #
  #  {
  #  "Bridge" :
  #    { "Software": "SXABCDEFG",
  #      "MID": 51,
  #      "VID": 1,
  #      "ProductCode": "54263",
  #      "PCBASerialNo":"1A345678"
  #    },
  #  "CAM" :
  #    { "SerialNo": "12345678901",
  #      "Software": "SXABCDEFG",
  #      "PCBASerialNo":"1A345678"
  #    }
  #  }

  # ACCEPTANCE CRITERIA: (ECO-12819)
  # 1. For manufacture records with a status of NEW, NGCS shall store the Cellular Module status as PROVISIONED.
  # Note 1. For manufacture records with a status of UPDATE, NGCS shall not modify the status of the cellular modem.
  # Note 2. For manufacture records with a status of SCRAP, NGCS will change the cellular modem to SCRAP per ECO-7299.
  # 2. When a valid registration is seen the Cellular Module state will be changed to ACTIVE.
  # 2.a Activation of an Aeris device shall be recorded, including FG serial number, CAM serial number, date, time and Aeris response code.

   Background:

  @newport.registration.external.cam.S1
  @ECO-9414.1, @ECO-9414.2, @ECO-9414.3
  @ECO-12819.1 @ECO-12819.2
   Scenario: Register CAMBridge (by itself, no flow generator at this stage)
      Given the server bulk load the following devices and modules
         | /data/manufacturing/batch_new_cam10000000001_bdg22151763341.xml |
      And manufacture verify the status of the job
         | status           |
         | COMPLETE-SUCCESS |
      And I am an external CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
      And the communication module with serial number "10000000001" should have a status of "PROVISIONED"
      When I send the following external cam registration
         | json                                                                                                                                                                                                     |
         | {"Bridge" :{"Software": "BRIDGE_SW","MID": 51,"VID": 1,"ProductCode": "54263","PCBASerialNo":"22151763341"}, "CAM" :{"SerialNo": "10000000001","Software": "CAM_SOFTWARE","PCBASerialNo":"13152G00001"}} |
      Then the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software      |
         | 10000000001 | 13152G00001  | ACTIVE             | ACTIVE             | VODAFONE             | CAM_SOFTWARE  |
      And the server has the following bridge modules
         | pcbaSerialNo | software   | mid | vid | productCode |
         | 22151763341  | BRIDGE_SW  | 51  | 1   | 54263       |
      And the server has logged an external cam registration
      And the communication module with serial number "10000000001" should eventually have a status of "ACTIVE" within 5 seconds

  @newport.registration.external.cam.S2
  @ECO-9414.1
   Scenario: Register CAMBridge where json message failed schema validation
      Given the server bulk load the following devices and modules
         | /data/manufacturing/batch_new_cam10000000001_bdg22151763341.xml |
      And manufacture verify the status of the job
         | status           |
         | COMPLETE-SUCCESS |
      And I am an external CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    # Expect the json below to fail validation due to missing the required attribute "MID"
    When I send the following external cam registration
         | json                                                                                                                                                                                         |
         | {"Bridge" :{"Software": "BRIDGE_SW", "VID": 1,"ProductCode": "54263","PCBASerialNo":"1A345678"}, "CAM" :{"SerialNo": "10000000001","Software": "CAM_SOFTWARE","PCBASerialNo":"13152G00001"}} |
      Then I should receive a server ok response
      And the server should log a registration error
        | ValidationVetoPoint       | ValidationFailureType        | ValidationFailureReason                                                                                                                                                                                                                                                                                                                                                          |
        | MESSAGE_VALIDATION        | REGISTRATION_CELLULAR_MODULE | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/registration-ext-cam-schema.json#","pointer":"/properties/Bridge"},"instance":{"pointer":"/Bridge"},"domain":"validation","keyword":"required","message":"missing required property(ies)","required":["MID","PCBASerialNo","ProductCode","Software","VID"],"missing":["MID"]} ] } |
    And the server has not logged an external cam registration

  @newport.registration.external.cam.S3
  @ECO-17244
  Scenario: Register CAMBridge (by itself, no flow generator at this stage) where CAM pcba serial number changed
    Given the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_cam10000000001_bdg22151763341.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And I am an external CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    And the communication module with serial number "10000000001" should have a status of "PROVISIONED"
    When I send the following external cam registration
      | json                                                                                                                                                                                                  |
      | {"Bridge" :{"Software": "BRIDGE_SW","MID": 51,"VID": 1,"ProductCode": "54263","PCBASerialNo":"22151763341"}, "CAM" :{"SerialNo": "10000000001","Software": "CAM_SOFTWARE","PCBASerialNo":"1A345678"}} |
    Then the server has the following comm modules
      | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software      |
      | 10000000001 | 13152G00001  | ACTIVE             | ACTIVE             | VODAFONE             | CAM_SOFTWARE  |
    And the server has the following bridge modules
      | pcbaSerialNo | software   | mid | vid | productCode |
      | 22151763341  | BRIDGE_SW  | 51  | 1   | 54263       |
    And the server has logged an external cam registration
    And the communication module with serial number "10000000001" should eventually have a status of "ACTIVE" within 5 seconds
    And the server should get the following invalid registration with warning ATTEMPTED_CAM_PCBA_CHANGE
      | json |
      | {"Bridge" :{"Software": "BRIDGE_SW","MID": 51,"VID": 1,"ProductCode": "54263","PCBASerialNo":"22151763341"}, "CAM" :{"SerialNo": "10000000001","Software": "CAM_SOFTWARE","PCBASerialNo":"1A345678"}} |
