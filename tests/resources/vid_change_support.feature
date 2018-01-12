@vid.change.support
@cancel.subscriptions
@newport.registration
@ECO-13748
@ECO-13735
@ECO-14800
@ECO-18103

Feature:

  (ECO-13748) As a clinical user
  I want to see updated therapy data items for a device that has been upgraded
  so that I can continue to monitor their therapy

  (ECO-13735) As NGCS
  I want to be able to notify others that a device's VID has changed
  so that the appropriate action can be taken

  (ECO-14800) As NGCS
  I want to send an appropriate response to the CAM when a change in MID is detected at registration.

  (ECO-18103) As NGCS
  I want to accept a registration containing a change in MID so that the CAM does not repeatedly re-register.

  # ACCEPTANCE CRITERIA: (ECO-13748)
  # 1. On VID change, NGCS shall cancel subscriptions for devices with an internal CAM.
  # 2. On VID change, NGCS shall cancel subscriptions for devices with an external CAM.

  # ACCEPTANCE CRITERIA: (ECO-13735)
  # 1. When a change in therapy device VID is detected at registration, a message shall be published with details of the change. This includes the serial number of the device and the previous and current value of the changed attribute. Note: Please use the DeviceConfigurationChanged topic.
  # [OBSOLETE] 2. When a change in therapy device MID is detected at registration:
  # [OBSOLETE] 2a. an HTTP 424 error response shall be sent to the CAM
  # [OBSOLETE] 2b. a message shall be published with details of the change. Note: Please use the InvalidRegistration queue.
  # Note: this applies to both internal and external CAM devices.

  # ACCEPTANCE CRITERIA: (ECO-14800)
  # Note 1: This card changes the response to the CAM when a MID change is detected. This obsoletes AC#2 of ECO-13735.
  # [OBSOLETE] 1. When a change in therapy device MID is detected at registration:
  # [OBSOLETE] 1a. an HTTP 403 error response shall be sent to the CAM
  # 1b. a message shall be published with details of the change. Note: Please use the InvalidRegistration queue.

  # ACCEPTANCE CRITERIA: (ECO-18103)
  # Note 1: This story obsoletes ECO-14800 and AC#2 of ECO-13735 so that registrations with MID changes are not rejected.
  # 1. When a change in therapy device MID is detected at registration a message shall be published with details of the change. Note: Please use the InvalidRegistration queue.



  @vid.change.support.S1
  @ECO-13748.1
  Scenario: Cancel subscriptions when there is a VID change detected in the device with an internal CAM and V1 registration.
    Given the server receives the following manufacturing unit detail
      | resource                                                                                                      |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg20070811223_cam20102141732_new.xml|
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 38, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    Then I should receive a response code of "200"
    And the server should get the following device configuration change
      | json                                                                                                                                                                                       |
      | { "serialNo": "20070811223", "mid": 36, "vid": 38, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": true, "previousVariantIdentifier": 26 } |
    When by requesting messages for FG "20070811223" with internal CAM I should eventually receive the following results in 10 seconds
      | URI Fixed Part         | Content Identifier                   |
      | /api/v1/subscriptions/ | 7B66913F-3BFE-4425-8A0F-6013C8565D7C |
      | /api/v1/subscriptions/ | C1609ADE-1A71-4C25-91F7-1AEAB5177530 |
    And I request the subscription with identifier "C1609ADE-1A71-4C25-91F7-1AEAB5177530"
    Then I should receive the following subscription
      | json                                                                                                       |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "C1609ADE-1A71-4C25-91F7-1AEAB5177530", "Cancel": true } |
    When I request the subscription with identifier "7B66913F-3BFE-4425-8A0F-6013C8565D7C"
    Then I should receive the following subscription
      | json                                                                                                       |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "7B66913F-3BFE-4425-8A0F-6013C8565D7C", "Cancel": true } |


  @vid.change.support.S2
  @ECO-13748.1
  Scenario: Cancel subscriptions when there is a VID change detected in the device with an internal CAM and V2 registration.
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
    Then I should receive a response code of "200"
    And the server should get the following device configuration change
      | json                                                                                                                                                                                       |
      | { "serialNo": "20000000005", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": true, "previousVariantIdentifier": 25 } |
    When by requesting messages for FG "20000000005" with internal CAM I should eventually receive the following results in 10 seconds
      | URI Fixed Part         | Content Identifier             |
      | /api/v1/subscriptions/ | E13FD8C4-EF82-43C2-20000000005 |
    And I request the subscription with identifier "E13FD8C4-EF82-43C2-20000000005"
    Then I should receive the following subscription
      | json                                                                                                 |
      | { "FG.SerialNo": "20000000005", "SubscriptionId": "E13FD8C4-EF82-43C2-20000000005", "Cancel": true } |


  @vid.change.support.S3
  @ECO-13748.2
  Scenario: Cancel subscriptions when there is a VID change detected in the device with an external CAM and V2 registration.
    Given the server completed bulk load the following devices and modules with status
      | jobFile                                                         | jobStatus        |
      | /data/manufacturing/batch_new_fg1000.xml                        | COMPLETE-SUCCESS |
      | /data/manufacturing/batch_new_cam10000000001_bdg22151763351.xml | COMPLETE-SUCCESS |
      | /data/manufacturing/batch_new_cam10000000003_bdg22151763361.xml | COMPLETE-SUCCESS |
    And the communication module "10000000001" uses mock Telco
    And the communication module "10000000003" uses mock Telco
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000003               | 10000000001                     |
    And I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G00001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": ["UUID-A", "UUID-B"]
    }
    """
    Then the server should get the following device configuration change
      | json                                                                                                                                                      |
      | { "serialNo": "10000000003", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false} |
    And a subscription batch holding following subscriptions is queued for device with serial number "10000000003"
      | /data/subscription_UUID1_10000000003.json |
      | /data/subscription_UUID2_10000000003.json |
    And I should eventually receive a call home SMS within 10 seconds
    And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 10 seconds
      | URI Fixed Part          | Content Identifier |
      | /api/v1/subscriptions/  | UUID-1             |
      | /api/v1/subscriptions/  | UUID-2             |
      | /api/v1/subscriptions/  | UUID-A             |
      | /api/v1/subscriptions/  | UUID-B             |
      | /api/v1/configurations/ | <ANY_UUID>         |
    When I request SUBSCRIPTION brokered requests for flow generator 10000000003
    Then I should receive all of the following subscriptions
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-1", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": true }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": { "Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.CSR", "Val.Leak.50", "Val.Leak.70", "Val.Leak.95", "Val.Leak.Max", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity", "Val.PatientHours", "Val.BlowPress.5", "Val.BlowPress.95", "Val.Flow.5", "Val.Flow.95", "Val.BlowFlow.50", "Val.HumTemp.50", "Val.HTubeTemp.50", "Val.HTubePow.50", "Val.HumPow.50", "Val.SpO2.50", "Val.SpO2.95", "Val.SpO2.Max", "Val.SpO2Thresh", "Val.SignalStrength", "Val.FlightMode" ] } |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-A", "Cancel": true}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-B", "Cancel": true}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
    And I acknowledge all brokered messages
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 28, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "SX588-0101", "PCBASerialNo":"13152G00001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
    Then I should receive a response code of "200"
    And the server should get the following device configuration change
      | json                                                                                                                                                                                       |
      | { "serialNo": "10000000003", "mid": 36, "vid": 28, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": true, "previousVariantIdentifier": 33 } |
    When I request SUBSCRIPTION brokered requests for flow generator 10000000003
    Then I should receive all of the following subscriptions
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-1", "Cancel": true} |
      | { "FG.SerialNo": "10000000003", "SubscriptionId": "UUID-2", "Cancel": true} |

  @vid.change.support.S4
  @ECO-18103.1
  @ECO-14800.1b
  Scenario: Register Newport device with an attempted MID change.  Verify that the MID does not change in DB, with a published message in InvalidRegistration queue acknowledging the change.
    Given devices with following properties have been manufactured
      | moduleSerial | authKey      | flowGenSerial | deviceNumber | mid | vid | telcoCarrierProvider | internalCommModule |productCode | pcbaSerialNo |
      | 20102141732  | 201913483157 | 20070811223   | 123          | 36  | 26  | MOCK                 | true               |9745        | 1A345678     |
    And the server waits for the device manufactured queue to be empty
    And the server should not produce device manufactured error
    And I am a device with the FlowGen serial number "20070811223"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "FGABCDEFH", "MID": 37, "VID": 26, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "20102141732", "Software": "CAMABCDEFH", "PCBASerialNo":"1A345678", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    Then I should receive a response code of "200"
    And NGCS has the following devices and modules
      | flowGenSerial | mid | vid | moduleSerial |
      | 20070811223   | 36  | 26  | 20102141732  |
    And the server should get the following invalid registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "FGABCDEFH", "MID": 37, "VID": 26, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "20102141732", "Software": "CAMABCDEFH", "PCBASerialNo":"1A345678", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |

  @vid.change.support.S5
  @ECO-13735.1
  Scenario: Register Newport device with an VID change.  Verify that the registration is successful and the an event is published on the DeviceConfigurationChanged topic
    Given devices with following properties have been manufactured
      | moduleSerial | authKey      | flowGenSerial | deviceNumber | mid | vid | telcoCarrierProvider | internalCommModule | productCode | pcbaSerialNo |
      | 20102141732  | 201913483157 | 20070811223   | 123          | 36  | 26  | MOCK                 | true               | 9745        | 1A345678     |
    And the server waits for the device manufactured queue to be empty
    And the server should not produce device manufactured error
    And I am a device with the FlowGen serial number "20070811223"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "FGABCDEFH", "MID": 36, "VID": 27, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "20102141732", "Software": "CAMABCDEFH", "PCBASerialNo":"1A345678", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    Then I should receive a response code of "200"
    And NGCS has the following devices and modules
      | flowGenSerial | mid | vid | moduleSerial |
      | 20070811223   | 36  | 27  | 20102141732  |
    And the server should get the following device configuration change
      | json                                                                                                                                                                                       |
      | { "serialNo": "20070811223", "mid": 36, "vid": 27, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": true, "previousVariantIdentifier": 26 } |

  @vid.change.support.S6
  @ECO-13735.1
  Scenario: Register Newport device using spare part cam  AND with a change of VID and check that the device configuration change publication is correct.
    Given the server receives the following manufacturing unit detail
      | resource                                                                  |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111114444_cam11111114444_new.xml      |
      | /data/manufacture/unit/detail/spare/unit_detail_cam11111111111_spare.xml  |
    And the server waits for the device manufactured queue to be empty
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 11111114444               | 11111114444                     |
    And I am a device with the FlowGen serial number "11111114444"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | { "FG": {"SerialNo": "11111114444", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "11111114444", "Software": "SX558-0100", "PCBASerialNo":"123123444", "Subscriptions": ["FDC84510-D85D-4E18-9994-DFBC78D5D793","39F012DF-3F85-4C89-BEC2-500391D1D110"] }, "Hum": {"Software": "SX556-0100"} } |
    Then I should receive a response code of "200"
    And NGCS has the following devices and modules
      | flowGenSerial | deviceNumber | mid | vid | buildDateTime        | npCapabilityViaCard | npCapabilityViaWireless | fgSoftware | fgBoot     | fgConfig                      | humSoftware | humBoot    | productCode | productName | regionId | fgPcbaSerialNo | moduleSerial | authKey                          | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan    | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions | camHostName  | camPortNo | camApn | camUriRegistration     | camUriBroker      | internalCam |
      | 11111114444   | 123          | 36  | 25  | 2013-10-16T11:36:55Z | true                | true                    | SX567-0100 | SX577-0100 | CX036-001-001-001-100-100-100 | SX556-0100  | SX537-0100 | 37001       | Newport X   | 1        | 34090044       | 11111114444  | 201913483157YREOYGLR4ZX6698KLYA2 | true      | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123444        | R379-702       | 01                |                  | 10.10.134.45 | 31266     | APN    | /api/v1/registrations/ | /api/v1/requests/ | true        |
    # Assign the device to bring cellular module into Active mode
    When the following devices have been assigned
      | serialNumber | mid | vid |
      | 11111114444  | 36  | 25  |
    Then I should eventually receive a wake up SMS within 10 seconds
    And the communication module with serial number "11111114444" should eventually have a status of "ACTIVE" within 5 seconds
    When I am reconditioned with communication module serial number "11111111111"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                          |
      | { "FG": {"SerialNo": "11111114444", "Software": "SX567-0100", "MID": 36, "VID": 27, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "11111111111", "Software": "SX558-0100", "PCBASerialNo":"123123111", "Subscriptions": [] }, "Hum": {"Software": "SX556-0100"} } |
    Then I should receive a response code of "200"
    And NGCS has the following devices and modules
      | flowGenSerial | deviceNumber | mid | vid | buildDateTime        | npCapabilityViaCard | npCapabilityViaWireless | fgSoftware | fgBoot     | fgConfig                      | humSoftware | humBoot    | productCode | productName | regionId | fgPcbaSerialNo | moduleSerial | authKey                          | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan    | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions | camHostName  | camPortNo | camApn | camUriRegistration     | camUriBroker      | internalCam |
      | 11111114444   | 123          | 36  | 27  | 2013-10-16T11:36:55Z | true                | true                    | SX567-0100 | SX577-0100 | CX036-001-001-001-100-100-100 | SX556-0100  | SX537-0100 | 37001       | Newport X   | 1        | 34090044       | 11111111111  | 201913483158KFAPM0T3V8LJVDMXJWQ6 | true      | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123111        | R379-702       | 01                |                  | 10.10.134.45 | 31266     | APN    | /api/v1/registrations/ | /api/v1/requests/ | true        |
    And NGCS has the following modules
      | moduleSerial | authKey                          | status   | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan    | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | telcoNetworkGsmMSISDN | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions                                                          | camHostName  | camPortNo | camUriRegistration     | camUriBroker      | internalCam |
      | 11111111111  | 201913483158KFAPM0T3V8LJVDMXJWQ6 | ACTIVE   | true      | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 123456789012345       | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123111        | R379-702       | 01                |                                                                           | 10.10.134.45 | 31266     | /api/v1/registrations/ | /api/v1/requests/ | true        |
      | 11111114444  | 201913483157YREOYGLR4ZX6698KLYA2 | SCRAPPED | true      | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 123456789012345       | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123444        | R379-702       | 01                | FDC84510-D85D-4E18-9994-DFBC78D5D793,39F012DF-3F85-4C89-BEC2-500391D1D110 | 10.10.134.45 | 31266     | /api/v1/registrations/ | /api/v1/requests/ | true        |
    And the server should get the following device configuration change
      | json                                                                                                                                                                                              |
      | { "serialNo": "11111114444", "mid": 36, "vid": 27, "communicationModuleMode": "ACTIVE", "updateSubscriptionsRequired": true, "variantIdentifierChanged": true, "previousVariantIdentifier": 25  } |

  @vid.change.support.S7
  @ECO-13735.1
  Scenario: Registration of device with a VID change and external CAM with V2 registration
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
      | flowGenSerial | appVersion | mid | vid | fgpcb                           | prodCode | confVersion                   | moduleSerial | camVersion | campcb      | humVersion |
      | 10000000003   | SX567-0100 | 36  | 33  | (90)R370-7224(91)P3(21)41030010 | 37001    | CX036-001-001-001-100-100-100 | 10000000001  | CAMABCDEFH | 13152G00001 | HUMABCDEFH |
    And the server should get the following device configuration change
      | json                                                                                                                                                      |
      | { "serialNo": "10000000003", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false} |
    When I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": ["6F7B1BD9-0B74-493F-A1B3-6A3882272AA7", "F86CF4FC-1A70-4017-8AAF-09555A39BD80"]
    }
    """
    Then I should receive a response code of "200"
    And NGCS sends this registration information to the HI Cloud API
      | flowGenSerial | appVersion | mid | vid | fgpcb                           | prodCode | confVersion                   | moduleSerial | camVersion | campcb      | humVersion |
      | 10000000003   | SX567-0100 | 36  | 25  | (90)R370-7224(91)P3(21)41030010 | 37001    | CX036-001-001-001-100-100-100 | 10000000001  | CAMABCDEFH | 13152G00001 | HUMABCDEFH |
    And the server should get the following device configuration change
      | json                                                                                                                                                                                       |
      | { "serialNo": "10000000003", "mid": 36, "vid": 25, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": true, "previousVariantIdentifier": 33 } |


  @vid.change.support.S8
  @ECO-13735.1
  Scenario: Registration of device with external CAM and change in VID when the device is registered with V2 registration and is switched from  one cambridge to another
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
    Then the server should get the following device configuration change
      | json                                                                                                                                                      |
      | { "serialNo": "10000000003", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false} |
    When I have changed connection to CAM with serial number "10000000002" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000002", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00002"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": ["6F7B1BD9-0B74-493F-A1B3-6A3882272AA7", "F86CF4FC-1A70-4017-8AAF-09555A39BD80"]
    }
    """
    Then NGCS sends this registration information to the HI Cloud API
      | flowGenSerial | appVersion | mid | vid | fgpcb                           | prodCode | confVersion                   | moduleSerial | camVersion | campcb      | humVersion |
      | 10000000003   | SX567-0100 | 36  | 25  | (90)R370-7224(91)P3(21)41030010 | 37001    | CX036-001-001-001-100-100-100 | 10000000002  | CAMABCDEFH | 13152G00002 | HUMABCDEFH |
    And the server should get the following device configuration change
      | json                                                                                                                                                                                             |
      | { "serialNo": "10000000003", "mid": 36, "vid": 25, "communicationModuleMode": "ACTIVE", "updateSubscriptionsRequired": true, "variantIdentifierChanged": true, "previousVariantIdentifier": 33 } |


  @vid.change.support.S9
  @ECO-13735.1
  Scenario: Registration of device with external CAM and change in VID when the Cambridge is switched from  one device to another, with V2 registration
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
    Then the server should get the following device configuration change
      | json                                                                                                                                                      |
      | { "serialNo": "10000000003", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false} |
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
    Then the server should get the following device configuration change
      | json                                                                                                                                                      |
      | { "serialNo": "10000000004", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false} |
    When I am a device with the FlowGen serial number "10000000003"
    And I have been connected with CAM with serial number "10000000001" with authentication key "MzYxMDAwMDAwMDAwNjEwMDAwMDAwMDA3"
    And I send the following version 2 registration
    """
    {
      "FG":{"SerialNo": "10000000003", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030010",
            "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100"},
      "CAM": {"SerialNo": "10000000001", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001"},
      "Subscriptions": []
    }
    """
    Then the server should get the following device configuration change
      | json                                                                                                                                                                                       |
      | { "serialNo": "10000000003", "mid": 36, "vid": 25, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": true, "previousVariantIdentifier": 33 } |