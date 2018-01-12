@newport
@newport.registration.v2
@ECO-9421
@ECO-10394
@ECO-12819
@ECO-13276

Feature:

  (ECO-9421) As a user
  I want up to date information on devices
  so that I can manage and update them as required

  (ECO-10394) As a user
  I want up to date information on devices
  so that I can manage and update them as required

  (ECO-12819) As NGCS
  I want to store newly manufactured CAM units with a status of PROVISIONED instead of ACTIVE,
  so that NGCS can properly manage suspend state for CAMs.

  (ECO-13276) As the Machine Portal,
  I want to update a Suspended Cellular Module state to Activated when a message is received
  so that I known when the last communication occurred

  # ACCEPTANCE CRITERIA: (ECO-9421)
  #  *Note 1:* This story introduces a version 2 of the device registration service introduced in ECO-4775.  The difference with V1 is that the subscription information is separated from the CAM section.
  #
  #  1. The server shall receive and store device registration information from therapy devices using version 2 of the registration end point ie. v2.
  #  2. The registration v2 end point shall support devices with external CAMs ie. as registered via ECO-9414.
  #  3. The humidifier section of the v2 registration end point shall be optional.
  #  4. For the registration v2 end point ECO-6637 AC#1 shall apply both to devices with internal and external CAMs i.e maintain association of device to CAM.
  #  5. For the registration v2 end point ECO-6637 AC#2 and AC#3 shall only apply to devices with internal CAMs i.e scrapping and subscription details.
  #
  #  PUT  /api/v2/registrations/{A serial number}  HTTP/1.1
  #  X-CamSerialNo: {serial number}
  #  X-Hash: {hash}
  #
  #  {
  #  "FG": {
  #    "SerialNo": "{A serial number}",
  #    "Software": "{version}",
  #    "MID": {mid},
  #    "VID": {vid},
  #    "PCBASerialNo": "{serial number}",
  #    "ProductCode": "{product code}",
  #    "Configuration": "{version}"
  #  },
  #  "CAM": {
  #    "SerialNo": "{serial number}",
  #    "Software": "{version}",
  #    "PCBASerialNo": "{serial number}"
  #  },
  #  "Hum": {
  #    "Software": "{version}"
  #  },
  #  "Subscriptions": [
  #    "6F7B1BD9-0B74-493F-A1B3-6A3882272AA7",
  #    "F86CF4FC-1A70-4017-8AAF-09555A39BD80"
  #    ]
  #  }

  # ACCEPTANCE CRITERIA: (ECO-10394)
  #  Note: This story extends ECO-9421.
  #
  #  1. The FG PCBASerialNo element of the v2 Device Registration end point (see ECO-9421) shall be optional.
  #  2. The FG Configuration element of the v2 Device Registration end point (see ECO-9421) shall be optional.

  # ACCEPTANCE CRITERIA: (ECO-12819)
  # 1. For manufacture records with a status of NEW, NGCS shall store the Cellular Module status as PROVISIONED.
  # Note 1. For manufacture records with a status of UPDATE, NGCS shall not modify the status of the cellular modem.
  # Note 2. For manufacture records with a status of SCRAP, NGCS will change the cellular modem to SCRAP per ECO-7299.
  # 2. When a valid registration is seen the Cellular Module state will be changed to ACTIVE.
  # 2.a Activation of an Aeris device shall be recorded, including FG serial number, CAM serial number, date, time and Aeris response code.

  # ACCEPTANCE CRITERIA: (ECO-13276)
  # A Suspended Cellular Module will be updated to Activated when:
  # 1. A Registration is received
  # 2. An Alarm Setting is received
  # 3. A Climate Setting is received
  # 4. A Device Alarm is received
  # 5. A Device Erasure is received
  # 6. A Device Fault is received
  # 7. A Device Log is received
  # 8. A Settings Event is received
  # 9. A System Event is received
  # 10. A Therapy Detail is received
  # 11. A Therapy Setting is received
  # 12. A Therapy Summary is received

###########################################################
#                      EXTERNAL CAM                       #
###########################################################

@newport.registration.v2.S1
@ECO-9421.1 @ECO-9421.2
@ECO-12819.1 @ECO-12819.2
Scenario: Registration of device and external CAM, first time for FG as well as for CAM
  Given the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_cam1000_bdg2215.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the communication module "10000000001" uses mock Telco
  And the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_fg1000.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the following units are cached for local use
    | flowGeneratorSerialNumber |
    | 10000000003               |
  And I am a device with the FlowGen serial number "10000000003"
  And the communication module with serial number "10000000001" should have a status of "PROVISIONED"
  When I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
  And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": ["6F7B1BD9-0B74-493F-A1B3-6A3882272AA7", "F86CF4FC-1A70-4017-8AAF-09555A39BD80"]
    }
    """
  Then NGCS sends this registration information to the HI Cloud API
    | flowGenSerial | appVersion | mid | vid | fgpcb                            | prodCode  | confVersion                   | moduleSerial | camVersion | campcb      | humVersion |
    | 10000000003   | SX567-0100 | 36  | 33  | (90)R370-7224(91)P3(21)41030010  | 37001     | CX036-001-001-001-100-100-100 | 10000000001  | CAMABCDEFH | 13152G00001 | HUMABCDEFH |
  And 1 count of registration history where flow generator has an paired communication module has been added
  And the communication module with serial number "10000000001" should eventually have a status of "ACTIVE" within 5 seconds

@newport.registration.v2.S2
@ECO-9421.1 @ECO-9421.2 @ECO-9421.3 @ECO-9421.4
Scenario: Registration of device and external CAM, first time for FG, but not the first time for the CAM
  Given the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_cam1000_bdg2215.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_fg1000.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the following units are cached for local use
    | flowGeneratorSerialNumber |
    | 10000000003               |
    | 10000000004               |
  And I am a device with the FlowGen serial number "10000000003"
  When I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
  And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001"},
      "Subscriptions": []
    }
    """
  Then 1 count of registration history where flow generator has an paired communication module has been added
  When I am a device with the FlowGen serial number "10000000004"
  And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
  And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000004", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030011",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
  Then 1 count of registration history where flow generator has an paired communication module has been added
  And NGCS sends this registration information to the HI Cloud API
    | flowGenSerial | appVersion | mid | vid | fgpcb                            | prodCode  | confVersion                   | moduleSerial | camVersion | campcb      | humVersion |
    | 10000000004   | SX567-0100 | 36  | 33  | (90)R370-7224(91)P3(21)41030011  | 37001     | CX036-001-001-001-100-100-100 | 10000000001  | CAMABCDEFH | 13152G00001 | HUMABCDEFH |
  When I am a device with the FlowGen serial number "10000000003"
  Then I should not be paired with any communication module
  And 1 count of registration history where flow generator has no paired communication module is found

@newport.registration.v2.S3
@ECO-9421.1 @ECO-9421.2 @ECO-9421.5
@ECO-12819.1 @ECO-12819.2
Scenario: Registration of FG and external CAM, first time for CAM, but not the first time for the FG
  Given the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_cam1000_bdg2215.xml |
  Then manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the communication module "10000000001" uses mock Telco
  And the communication module "10000000002" uses mock Telco
  And the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_fg1000.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the following units are cached for local use
    | flowGeneratorSerialNumber |
    | 10000000003               |
  And the communication module with serial number "10000000001" should have a status of "PROVISIONED"
  And I am a device with the FlowGen serial number "10000000003"
  When I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
  And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
  Then 1 count of registration history where flow generator has an paired communication module has been added
  And the communication module with serial number "10000000001" should eventually have a status of "ACTIVE" within 5 seconds
  When I have changed connection to CAM with serial number "10000000002" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
  And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000002", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00002"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": ["6F7B1BD9-0B74-493F-A1B3-6A3882272AA7", "F86CF4FC-1A70-4017-8AAF-09555A39BD80"]
    }
    """
  Then 2 count of registration history where flow generator has an paired communication module have been added
  And NGCS sends this registration information to the HI Cloud API
    | flowGenSerial | appVersion | mid | vid | fgpcb                            | prodCode  | confVersion                   | moduleSerial | camVersion | campcb      | humVersion |
    | 10000000003   | SX567-0100 | 36  | 33  | (90)R370-7224(91)P3(21)41030010  | 37001     | CX036-001-001-001-100-100-100 | 10000000002  | CAMABCDEFH | 13152G00002 | HUMABCDEFH |
  And the communication module with serial number "10000000001" should not be paired with any flow generator
  And the communication module with serial number "10000000001" should eventually have a status of "ACTIVE" within 5 seconds
  And the server should not log a device discarded notification error

@newport.registration.v2.S4
@ECO-9421.1 @ECO-9421.2
@ECO-12819.1 @ECO-12819.2
Scenario: Registration of FG and external CAM, neither first time for CAM, nor for the FG
  Given the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_cam1000_bdg2215.xml |
  Then manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the communication module "10000000001" uses mock Telco
  And the communication module "10000000002" uses mock Telco
  And the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_fg1000.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the following units are cached for local use
    | flowGeneratorSerialNumber |
    | 10000000003               |
    | 10000000004               |
  And the communication module with serial number "10000000001" should have a status of "PROVISIONED"
  And the communication module with serial number "10000000002" should have a status of "PROVISIONED"
  And I am a device with the FlowGen serial number "10000000003"
  When I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
  And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": ["6F7B1BD9-0B74-493F-A1B3-6A3882272AA7", "F86CF4FC-1A70-4017-8AAF-09555A39BD80"]
    }
    """
  Then 1 count of registration history where flow generator has an paired communication module has been added
  And the communication module with serial number "10000000001" should eventually have a status of "ACTIVE" within 5 seconds
  When I am a device with the FlowGen serial number "10000000004"
  And I have been connected with CAM with serial number "10000000002" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
  And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000004", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030011",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000002", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00002"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": ["6F7B1BD9-0B74-493F-A1B3-6A3882272AA7", "F86CF4FC-1A70-4017-8AAF-09555A39BD80"]
    }
    """
  Then 1 count of registration history where flow generator has an paired communication module has been added
  And the communication module with serial number "10000000002" should eventually have a status of "ACTIVE" within 3 seconds
  When I am a device with the FlowGen serial number "10000000003"
  And I have changed connection to CAM with serial number "10000000002" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
  And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000002", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00002"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": ["6F7B1BD9-0B74-493F-A1B3-6A3882272AA7", "F86CF4FC-1A70-4017-8AAF-09555A39BD80"]
    }
    """
  Then NGCS sends this registration information to the HI Cloud API
    | flowGenSerial | appVersion | mid | vid | fgpcb                            | prodCode  | confVersion                   | moduleSerial | camVersion | campcb      | humVersion |
    | 10000000003   | SX567-0100 | 36  | 33  | (90)R370-7224(91)P3(21)41030010  | 37001     | CX036-001-001-001-100-100-100 | 10000000002  | CAMABCDEFH | 13152G00002 | HUMABCDEFH |
  And 2 count of registration history where flow generator has an paired communication module have been added

# external cam already associated

###########################################################
#                      INTERNAL CAM                       #
###########################################################

@newport.registration.v2.S5
@ECO-9421.1 @ECO-9421.2
Scenario: Registration of device with internal CAM, using v2 interface, first time for FG and for CAM
  Given the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_fg2000_cam2000.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the following units are cached for local use
    | flowGeneratorSerialNumber |
    | 20000000005               |
  And I am a device with the FlowGen serial number "20000000005"
  When I have been connected with CAM with serial number "20000000006" with authentication key "MzYxMDAwMDAwMDAwMTEwMDAwMDAwMDAx"
  And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "20000000005", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "20000000006", "Software": "CAMABCDEFH", "PCBASerialNo":"23152G00005"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
  Then NGCS sends this registration information to the HI Cloud API
    | flowGenSerial | appVersion | mid | vid | fgpcb                            | prodCode  | confVersion                   | moduleSerial | camVersion | campcb      | humVersion |
    | 20000000005   | SX567-0100 | 36  | 33  | (90)R370-7224(91)P3(21)41030010  | 37001     | CX036-001-001-001-100-100-100 | 20000000006  | CAMABCDEFH | 23152G00005 | HUMABCDEFH |
  And 1 count of registration history where flow generator has an paired communication module has been added

@newport.registration.v2.S6
@ECO-9421.1 @ECO-9421.2
Scenario: Registration of device with internal CAM, using v2 interface, reconditioning FG with a replacement CAM
  Given the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_fg2000_cam2000.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_cam1000.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the following units are cached for local use
    | flowGeneratorSerialNumber |
    | 20000000005               |
  And I am a device with the FlowGen serial number "20000000005"
  When I have been connected with CAM with serial number "20000000006" with authentication key "MzYxMDAwMDAwMDAwMTEwMDAwMDAwMDAx"
  And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "20000000005", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "20000000006", "Software": "CAMABCDEFH", "PCBASerialNo":"23152G00005"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
  Then 1 count of registration history where flow generator has an paired communication module has been added
  When I have changed connection to CAM with serial number "10000000005" with authentication key "123456789DAwMDAwNTEwMDAwMDAwMDA1"
  And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "20000000005", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000005", "Software": "REPLACEMENT", "PCBASerialNo":"13152G00005"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
  Then NGCS sends this registration information to the HI Cloud API
    | flowGenSerial | appVersion | mid | vid | fgpcb                            | prodCode  | confVersion                   | moduleSerial | camVersion  | campcb      | humVersion |
    | 20000000005   | SX567-0100 | 36  | 25  | (90)R370-7224(91)P3(21)41030010  | 37001     | CX036-001-001-001-100-100-100 | 10000000005  | REPLACEMENT | 13152G00005 | HUMABCDEFH |
  And 2 count of registration history where flow generator has an paired communication module have been added
  And the communication module with serial number "20000000006" should have a status of "SCRAPPED"
  And the server should get the following device configuration change
    | json                                                                                                                                                            |
    | { "serialNo": "20000000005", "mid": 36, "vid": 25, "communicationModuleMode": "ACTIVE", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false} |

@newport.registration.v2.S7
@ECO-9421.1 @ECO-9421.2
Scenario: Registration of device with internal CAM, using v2 interface, with an invalid replacement CAM (already associated)
  Given the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_fg9000_cam9000.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the following units are cached for local use
    | flowGeneratorSerialNumber |
    | 90000000055               |
    | 90000000077               |
  And I am a device with the FlowGen serial number "90000000055"
  When I have been connected with CAM with serial number "90000000055" with authentication key "MzYxMDAwMDAwMDAwMTEwMDAwMDAwMD55"
  And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "90000000055", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030055",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "90000000055", "Software": "CAMABCDEFH", "PCBASerialNo":"23152G00055"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
  Then 1 count of registration history where flow generator has an paired communication module has been added
  When I am a device with the FlowGen serial number "90000000077"
  And I have been connected with CAM with serial number "90000000077" with authentication key "MzYxMDAwMDAwMDAwMTEwMDAwMDAwMD77"
  And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "90000000077", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030077",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "90000000077", "Software": "CAMABCDEFH", "PCBASerialNo":"23152G00077"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
  Then 1 count of registration history where flow generator has an paired communication module has been added
  When I am a device with the FlowGen serial number "90000000055"
  And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "90000000055", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030055",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "90000000077", "Software": "CAMABCDEFH", "PCBASerialNo":"23152G00077"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
  Then the server should log a registration error
    | ValidationVetoPoint       | ValidationFailureType | ValidationFailureReason  |
    | REPLACEMENT_PAIRED        |                       |                          |
  And the communication module with serial number "90000000055" should eventually have a status of "ACTIVE" within 5 seconds
  And the communication module with serial number "90000000055" should be paired with the flow generator with serial number "90000000055"
  And the communication module with serial number "90000000077" should eventually have a status of "ACTIVE" within 5 seconds
  And the communication module with serial number "90000000077" should be paired with the flow generator with serial number "90000000077"

###########################################################
#                       MIXED CAMs                        #
###########################################################

@newport.registration.v2.S8
@ECO-9421.1
Scenario: Internal CAM should not be able to replace external CAM for FG
  Given the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_fg1000.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_cam1000_bdg2215.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_cam1000.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the following units are cached for local use
    | flowGeneratorSerialNumber |
    | 10000000003               |
  And I am a device with the FlowGen serial number "10000000003"
  When I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
  And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
  Then 1 count of registration history where flow generator has an paired communication module has been added
  And I have been connected with CAM with serial number "10000000005" with authentication key "123456789DAwMDAwNTEwMDAwMDAwMDA1"
  When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000005", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00005"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
  # This is only to verify the count stays at 1
  Then 1 count of registration history where flow generator has an paired communication module has been added
  Then the server should log a registration error
    | ValidationVetoPoint       | ValidationFailureType | ValidationFailureReason  |
    | INCOMPATIBLE_TYPE         |                       |                          |
  And the communication module with serial number "10000000001" should eventually have a status of "ACTIVE" within 5 seconds
  And the communication module with serial number "10000000001" should be paired with the flow generator with serial number "10000000003"
  And the communication module with serial number "10000000005" should not be paired with any flow generator
  When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
    Then I should receive a server Unauthorized response
    And the server should log a registration error
    | ValidationVetoPoint   | ValidationFailureType         | ValidationFailureReason                                                                 |
    | AUTHORIZATION         | CELLULAR_MODULE_SERIAL_NUMBER | Authorizing cellular module serial number does not match the one from the message body. |

@newport.registration.v2.S9
@ECO-9421.1
Scenario: External CAM should not be able to replace internal CAM for FG
  Given the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_fg9000_cam9000.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_cam1000_bdg2215.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the following units are cached for local use
    | flowGeneratorSerialNumber |
    | 90000000055               |
  And I am a device with the FlowGen serial number "90000000055"
  When I have been connected with CAM with serial number "90000000055" with authentication key "MzYxMDAwMDAwMDAwMTEwMDAwMDAwMD55"
  And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "90000000055", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030055",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "90000000055", "Software": "CAMABCDEFH", "PCBASerialNo":"23152G00055"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
  Then 1 count of registration history where flow generator has an paired communication module has been added
  And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
  When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "90000000055", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030055",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
  # This is only to verify the count stays at 1
  Then 1 count of registration history where flow generator has an paired communication module has been added
  And the server should log a registration error
    | ValidationVetoPoint       | ValidationFailureType | ValidationFailureReason  |
    | INCOMPATIBLE_TYPE         |                       |                          |
  And the communication module with serial number "90000000055" should be paired with the flow generator with serial number "90000000055"
  And the communication module with serial number "90000000055" should eventually have a status of "ACTIVE" within 5 seconds
  And the communication module with serial number "10000000001" should not be paired with any flow generator
  When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "90000000055", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030055",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "90000000055", "Software": "CAMABCDEFH", "PCBASerialNo":"23152G00055"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
    Then I should receive a server Unauthorized response
    And the server should log a registration error
    | ValidationVetoPoint   | ValidationFailureType         | ValidationFailureReason                                                                 |
    | AUTHORIZATION         | CELLULAR_MODULE_SERIAL_NUMBER | Authorizing cellular module serial number does not match the one from the message body. |

##################################################################
# EXTERNAL CAM WITH FEW VARIATIONS OF REGISTRATION JSON CONTENTS #
##################################################################

@newport.registration.v2.S10
@ECO-10394.1
Scenario: Registration of device and external CAM, where FG "PCBASerialNo" is not included in JSON
  Given the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_cam1000_bdg2215.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the communication module "10000000001" uses mock Telco
  And the communication module "10000000002" uses mock Telco
  And the server bulk load the following devices and modules
    | /data/manufacturing/batch_new_fg1000.xml |
  And manufacture verify the status of the job
    | status           |
    | COMPLETE-SUCCESS |
  And the following units are cached for local use
    | flowGeneratorSerialNumber |
    | 10000000003               |
  And I am a device with the FlowGen serial number "10000000003"
  When I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
  And I send the following version 2 registration
  """
  {
    "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33,
          "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
    "CAM": {"SerialNo": "10000000001", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001"},
    "Hum": {"Software": "HUMABCDEFH"},
    "Subscriptions": ["6F7B1BD9-0B74-493F-A1B3-6A3882272AA7", "F86CF4FC-1A70-4017-8AAF-09555A39BD80"]
  }
  """
  Then NGCS sends this registration information to the HI Cloud API
    | flowGenSerial | appVersion | mid | vid | fgpcb                            | prodCode  | confVersion                   | moduleSerial | camVersion | campcb      | humVersion |
    | 10000000003   | SX567-0100 | 36  | 33  |                                  | 37001     | CX036-001-001-001-100-100-100 | 10000000001  | CAMABCDEFH | 13152G00001 | HUMABCDEFH |
  And 1 count of registration history where flow generator has an paired communication module has been added

  @newport.registration.v2.S11
  @ECO-10394.2
  Scenario: Registration of device and external CAM, where FG "Configuration" is not included in JSON
    Given the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_cam1000_bdg2215.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the communication module "10000000001" uses mock Telco
    And the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_fg1000.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 10000000003               |
    And I am a device with the FlowGen serial number "10000000003"
    When I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    And I send the following version 2 registration
  """
  {
    "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
          "ProductCode":"37001"},
    "CAM": {"SerialNo": "10000000001", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001"},
    "Hum": {"Software": "HUMABCDEFH"},
    "Subscriptions": ["6F7B1BD9-0B74-493F-A1B3-6A3882272AA7", "F86CF4FC-1A70-4017-8AAF-09555A39BD80"]
  }
  """
    Then NGCS sends this registration information to the HI Cloud API
      | flowGenSerial | appVersion | mid | vid | fgpcb                            | prodCode  | confVersion | moduleSerial | camVersion | campcb      | humVersion |
      | 10000000003   | SX567-0100 | 36  | 33  | (90)R370-7224(91)P3(21)41030010  | 37001     |             | 10000000001  | CAMABCDEFH | 13152G00001 | HUMABCDEFH |
    And 1 count of registration history where flow generator has an paired communication module has been added

  @newport.registration.v2.S12
  @ECO-10394.1 @ECO-10394.2
  Scenario: Registration of device and external CAM, where neither FG "PCBASerialNo" nor "Configuration" included in JSON
    Given the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_cam1000_bdg2215.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the communication module "10000000001" uses mock Telco
    And the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_fg1000.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 10000000003               |
    And I am a device with the FlowGen serial number "10000000003"
    When I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33,
            "ProductCode":"37001"},
      "CAM": {"SerialNo": "10000000001", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": ["6F7B1BD9-0B74-493F-A1B3-6A3882272AA7", "F86CF4FC-1A70-4017-8AAF-09555A39BD80"]
    }
    """
    Then NGCS sends this registration information to the HI Cloud API
      | flowGenSerial | appVersion | mid | vid | fgpcb | prodCode  | confVersion | moduleSerial | camVersion | campcb      | humVersion |
      | 10000000003   | SX567-0100 | 36  | 33  |       | 37001     |             | 10000000001  | CAMABCDEFH | 13152G00001 | HUMABCDEFH |
    And 1 count of registration history where flow generator has an paired communication module has been added

  @newport.registration.v2.S13
  @ECO-13276.1
  Scenario: Registration v2 event from a suspended device should change status to active
    Given the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_cam1000_bdg2215.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the communication module "10000000001" uses mock Telco
    And the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_fg1000.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 10000000003               |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    And the communication module with serial number "10000000001" has suspended status for 1 days
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": ["6F7B1BD9-0B74-493F-A1B3-6A3882272AA7", "F86CF4FC-1A70-4017-8AAF-09555A39BD80"]
    }
    """
    Then the communication module with serial number "10000000001" should eventually have a status of "ACTIVE" within 5 seconds

###########################################################
#          REGISTRATION WITH UNEXPECTED VALUES            #
###########################################################

  @newport.registration.v2.S14
  @ECO-17244
  Scenario: Registration of device and external CAM, first time for FG as well as for CAM, where CAM pcba serial changed
    Given the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_cam1000_bdg2215.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the communication module "10000000001" uses mock Telco
    And the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_fg1000.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 10000000003               |
    And I am a device with the FlowGen serial number "10000000003"
    And the communication module with serial number "10000000001" should have a status of "PROVISIONED"
    When I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"1A345678"},
      "Hum": {"Software": "SX556-0100"},
      "Subscriptions": ["6F7B1BD9-0B74-493F-A1B3-6A3882272AA7", "F86CF4FC-1A70-4017-8AAF-09555A39BD80"]
    }
    """
    Then NGCS sends this registration information to the HI Cloud API
      | flowGenSerial | appVersion | mid | vid | fgpcb                            | prodCode  | confVersion                   | moduleSerial | camVersion | campcb      | humVersion |
      | 10000000003   | SX567-0100 | 36  | 33  | (90)R370-7224(91)P3(21)41030010  | 37001     | CX036-001-001-001-100-100-100 | 10000000001  | SX588-0101 | 13152G00001 | SX556-0100 |
    And 1 count of registration history where flow generator has an paired communication module has been added
    And the communication module with serial number "10000000001" should eventually have a status of "ACTIVE" within 5 seconds
    And the server should get the following invalid registration with warning ATTEMPTED_CAM_PCBA_CHANGE
      | json |
      | {"FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"}, "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"1A345678"}, "Hum": {"Software": "SX556-0100"}, "Subscriptions": ["6F7B1BD9-0B74-493F-A1B3-6A3882272AA7", "F86CF4FC-1A70-4017-8AAF-09555A39BD80"]} |

  @newport.registration.v2.S15
  @ECO-17244
  Scenario: Registration of device with internal CAM, using v2 interface, first time for FG and for CAM, where CAM pcba serial changed
    Given the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_fg2000_cam2000.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 20000000005               |
    And I am a device with the FlowGen serial number "20000000005"
    When I have been connected with CAM with serial number "20000000006" with authentication key "MzYxMDAwMDAwMDAwMTEwMDAwMDAwMDAx"
    And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "20000000005", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "20000000006", "Software": "SX558-0100", "PCBASerialNo":"2A345678"},
      "Hum": {"Software": "SX556-0100"},
      "Subscriptions": []
    }
    """
    Then NGCS sends this registration information to the HI Cloud API
      | flowGenSerial | appVersion | mid | vid | fgpcb                            | prodCode  | confVersion                   | moduleSerial | camVersion | campcb      | humVersion |
      | 20000000005   | SX567-0100 | 36  | 33  | (90)R370-7224(91)P3(21)41030010  | 37001     | CX036-001-001-001-100-100-100 | 20000000006  | SX558-0100 | 23152G00005 | SX556-0100 |
    And 1 count of registration history where flow generator has an paired communication module has been added
    And the server should get the following invalid registration with warning ATTEMPTED_CAM_PCBA_CHANGE
      | json |
      | {"FG":{"SerialNo": "20000000005", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"}, "CAM": {"SerialNo": "20000000006", "Software": "SX558-0100", "PCBASerialNo":"2A345678"}, "Hum": {"Software": "SX556-0100"}, "Subscriptions": []} |

  @newport.registration.v2.S16
  @ECO-17244
  Scenario: Registration of device and external CAM, first time for FG as well as for CAM, where FG product code changed
    Given the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_cam1000_bdg2215.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the communication module "10000000001" uses mock Telco
    And the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_fg1000.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 10000000003               |
    And I am a device with the FlowGen serial number "10000000003"
    And the communication module with serial number "10000000001" should have a status of "PROVISIONED"
    When I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"99001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G00001"},
      "Hum": {"Software": "SX556-0100"},
      "Subscriptions": ["6F7B1BD9-0B74-493F-A1B3-6A3882272AA7", "F86CF4FC-1A70-4017-8AAF-09555A39BD80"]
    }
    """
    Then NGCS sends this registration information to the HI Cloud API
      | flowGenSerial | appVersion | mid | vid | fgpcb                            | prodCode  | confVersion                   | moduleSerial | camVersion | campcb      | humVersion |
      | 10000000003   | SX567-0100 | 36  | 33  | (90)R370-7224(91)P3(21)41030010  | 37001     | CX036-001-001-001-100-100-100 | 10000000001  | SX588-0101 | 13152G00001 | SX556-0100 |
    And 1 count of registration history where flow generator has an paired communication module has been added
    And the communication module with serial number "10000000001" should eventually have a status of "ACTIVE" within 5 seconds
    And the server should get the following invalid registration with warning ATTEMPTED_PRODUCT_CODE_CHANGE
      | json |
      | {"FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010", "ProductCode":"99001", "Configuration": "CX036-001-001-001-100-100-100"}, "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G00001"}, "Hum": {"Software": "SX556-0100"}, "Subscriptions": ["6F7B1BD9-0B74-493F-A1B3-6A3882272AA7", "F86CF4FC-1A70-4017-8AAF-09555A39BD80"]} |

  @newport.registration.v2.S17
  @ECO-17244
  Scenario: Registration of device with internal CAM, using v2 interface, first time for FG and for CAM, where FG product code changed
    Given the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_fg2000_cam2000.xml |
    And manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 20000000005               |
    And I am a device with the FlowGen serial number "20000000005"
    When I have been connected with CAM with serial number "20000000006" with authentication key "MzYxMDAwMDAwMDAwMTEwMDAwMDAwMDAx"
    And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "20000000005", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"99001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "20000000006", "Software": "SX558-0100", "PCBASerialNo":"23152G00005"},
      "Hum": {"Software": "SX556-0100"},
      "Subscriptions": []
    }
    """
    Then NGCS sends this registration information to the HI Cloud API
      | flowGenSerial | appVersion | mid | vid | fgpcb                            | prodCode  | confVersion                   | moduleSerial | camVersion | campcb      | humVersion |
      | 20000000005   | SX567-0100 | 36  | 33  | (90)R370-7224(91)P3(21)41030010  | 37001     | CX036-001-001-001-100-100-100 | 20000000006  | SX558-0100 | 23152G00005 | SX556-0100 |
    And 1 count of registration history where flow generator has an paired communication module has been added
    And the server should get the following invalid registration with warning ATTEMPTED_PRODUCT_CODE_CHANGE
      | json |
      | {"FG":{"SerialNo": "20000000005", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010", "ProductCode":"99001", "Configuration": "CX036-001-001-001-100-100-100"}, "CAM": {"SerialNo": "20000000006", "Software": "SX558-0100", "PCBASerialNo":"23152G00005"}, "Hum": {"Software": "SX556-0100"}, "Subscriptions": []} |