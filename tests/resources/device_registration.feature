@newport
@newport.registration
@ECO-4775
@ECO-5581
@ECO-6637
@ECO-6091
@ECO-8220
@ECO-10358
@ECO-12459
@ECO-12819
@ECO-13276
@ECO-13565


Feature:

  (ECO-4775) As a user
  I want up to date information on devices
  so that I can manage and update them as required

  (ECO-5581) As ECO
  I want to be able to receive CAM subscriptions on registration
  so that registration operations do not fail

  (ECO-6637) As a technical support officer
  I want a replaced CAM to be reflected within EasyCare Online
  so that I can service therapy devices cost effectively

  (ECO-6091) As ECO
  I want to ensure that a CAM is restored correctly to its silent state after field service
  so that patient privacy is protected.

  (ECO-8220) A Newport unit with a replacement CAM is unable to register

  (ECO-10358) As ECO
  I want to generate subscriptions for a CAMBridge device customised to its connected flow generator
  so that the device can talk to ECO

  (ECO-12819) As NGCS
  I want to store newly manufactured CAM units with a status of PROVISIONED instead of ACTIVE,
  so that NGCS can properly manage suspend state for CAMs.

  (ECO-13276) As the Machine Portal,
  I want to update a Suspended Cellular Module state to Activated when a message is received
  so that I known when the last communication occurred

  (ECO-13565) As Product Support
  I want to be able to use a FG serial number to determine whether an Aeris-connected device has been suspended or is active,
  so that I can avoid a more tedious lookup based on CAM serial numbe.

# ACCEPTANCE CRITERIA: (ECO-4775)
# 1. The server shall receive the device registration information from S10 devices.
# 2. The server shall forward the device identification and associated registration information to an HI Cloud API.
# Note 2: Protocol details:
# The protocol is specified at http://confluence.corp.resmed.org/display/CA/Registrations+-+new
# Note 3: Example registration JSON is as follows:
# PUT /api/v1/registrations HTTP/1.1
# Host: rtcs.us
# Content-Length: 315
# Content-Type: application/json
# {
# "FG":
# {"SerialNo": "12345678901",
# "Software": "SXABCDEFG",
# "MID": 26,
# "VID": 33,
# "PCBASerialNo":"1A345678",
# "ProductCode":"9745",
# "Configuration": "CX-ABC-123-DEF-456"
# },
# "CAM":
# {"SerialNo": "12345678901",
# "Software": "SXABCDEFG",
# "PCBASerialNo":"1A345678"
# }
# "Hum":
# {"Software": "SXABCDEFG"}
# }

# ACCEPTANCE CRITERIA: (ECO-5581)
# 1. CAM subscription information during Registration should be able to be received as per http://confluence.corp.resmed.org/x/YwGz
#
# Note 1: It is not necessary at this stage to do anything with the CAM subscription information. The important thing is to prevent all registrations failing.

# ACCEPTANCE CRITERIA: (ECO-6637)
# Note 1: This story handles the assignment when a Newport device is serviced and given a new CAM. Scrapping the device with the telco and loading subscriptions will be done in separate cards.
# 1. When a device registration is received and the CAM serial number is different to the association previously recorded in EasyCare Online, then ECO shall update the association of the Flow Gen to the new CAM. Note: Assumes new CAM has been manufactured (CAM Spare Part) and ECO has awareness of it.
# 2. The old CAM shall be marked as scrapped. Note: This will just be a database flag. Another card will communicate with the telco providers to scrap the device there.
# 3. A notification shall be sent to the subscriptions manager that the new CAM is attached to the Flow Generator, with
# 3a. the FG MID
# 3b. the FG VID
# 3c. the FG Serial Number
# Note 2: The intent in sending this notification is for the subscriptions manager to generate subscriptions for this device and send them to the request broker; this will be handled in ECO-5555. It is expected that the MID and VID of the attached flow generator is sent in the notification

# ACCEPTANCE CRITERIA: (ECO-6091)
# 1. When a device registration is received and the CAM serial number is different to the association previously recorded in EasyCare Online, then ECO shall return the device to silent state if the old CAM on the device is currently in silent state.
# Note 1: The intent of this story is the following. During field service, a CAM spare part may replace the CAM on a device. CAM spare parts are expected to be shipped with Silent state turned off. However, if the patient's device was in silent state before the field service, we would like to restore the device to silent state after field service.

# ACCEPTANCE CRITERIA: (ECO-8220)
# Defect where "replacement" CAM already has subscriptions results in error

# ACCEPTANCE CRITERIA: (ECO-10358)
#  1. When an external CAM registers with a device (ie. as per ECO-9421) with a registration message containing existing subscriptions, and there are subscriptions already held in AirView for
#  that device that do not match then:
#  1a. The subscriptions held by the CAMBridge for the device shall be cancelled. *Note:* Refer to http://confluence.corp.resmed.org/display/CA/Subscription.
#  [Obsolete] 1b. The subscriptions for the device held by AirView shall be sent to the CAMBridge through the existing communications protocol. Note: This card will cover getting the subscriptions
#  onto the request broker. SMS, etc, is handled elsewhere.
#  2. The subscriptions shall be sent to the external CAM for the device prior to the sending of the Last Post Date, refer to ECO-9653.
#
#  *Note1:* If the subscriptions sent by the CAMBridge for the device *do* match, then no subscriptions are required to be sent to the device, and processing can skip to
#  Last Post being sent to the device as per ECO-9653.
#  *Note2:* This card invalidates https://jira.ec2.local/browse/ECO-9843. In ECO-9843, subscriptions shall be sent to the device as long as AirView holds subscriptions
#  for the device. After this new change (optimization) subscriptions are sent from server to device only when they do not match those reported in registration JSON message.

# ACCEPTANCE CRITERIA: (ECO-12459)
# Note 1: This story extends ECO-10358 to prevent cancelled subscriptions from being sent to the CAMBridge.
# 1. The subscriptions for the device held by AirView that are not cancelled and/or not blocked shall be sent to the CAMBridge through the existing
# communications protocol.  Note: This supersedes -ECO-10358- AC1b where all subscriptions are sent to the CAMBridge.

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

# ACCEPTANCE CRITERIA: (ECO-13276)
# 1. When Machine Portal suspends an Aeris-connected device, it shall include the FG serial number to the successful suspension record.
# 1.a When the device is transitioned from provisioned to suspended, it shall include the FG serial number to the record.
# 1.b When the device is transitioned from active to suspended, it shall include the FG serial number to the record.
# Note 1. AC 1 adds FG serial number to AC 1.c of --ECO-12634--, ECO-12635, and ECO-12636.
# 2. When Machine Portal transitions an Aeris-connected device to active, it shall include the FG serial number to the record.
# 2.a When the device is transitioned from provisioned to active, it shall include the FG serial number to the record.
# 2.b When the device is transitioned from suspended to active, it shall include the FG serial number to the record.
# Note 2. AC 2 adds recording of FG serial number to all ACs of -ECO-13276-.

  @newport.registration.S1
  @ECO-4775.1 @ECO-4775.2
  @ECO-5581.1
  @ECO-6637.1 @ECO-6637.2 @ECO-6637.3 @ECO-6637.3a @ECO-6637.3b @ECO-6637.3c
  @ECO-6091.1
  @ECO-12819.2
  Scenario: Register Newport device using spare part cam, where the initial module was silent by defaul and became active due to patient assignment
    # Note: This scenario changed from a "Scenario Outline" in to two separate scenarios (added .S8) in ECO-16985
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
    Then NGCS has the following devices and modules
      | flowGenSerial | deviceNumber | mid | vid | buildDateTime        | npCapabilityViaCard | npCapabilityViaWireless | fgSoftware | fgBoot     | fgConfig                      | humSoftware | humBoot    | productCode | productName | regionId | fgPcbaSerialNo | moduleSerial | authKey                          | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan    | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions | camHostName  | camPortNo | camApn | camUriRegistration     | camUriBroker      | internalCam |
      | 11111114444   | 123          | 36  | 25  | 2013-10-16T11:36:55Z | true                | true                    | SX567-0100 | SX577-0100 | CX036-001-001-001-100-100-100 | SX556-0100  | SX537-0100 | 37001       | Newport X   | 1        | 34090044       | 11111114444  | 201913483157YREOYGLR4ZX6698KLYA2 | true      | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123444        | R379-702       | 01                |                  | 10.10.134.45 | 31266     | APN    | /api/v1/registrations/ | /api/v1/requests/ | true        |
    And NGCS has the following modules
      | moduleSerial | authKey                          | status | camSilent | currentSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan    | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | telcoNetworkGsmMSISDN | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions                                                          | camHostName  | camPortNo | camUriRegistration     | camUriBroker      | internalCam |
      | 11111111111  | 201913483158KFAPM0T3V8LJVDMXJWQ6 |        | false     | false         | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 123456789012345       | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123111        | R379-702       | 01                |                                                                           | 10.10.134.45 | 31266     | /api/v1/registrations/ | /api/v1/requests/ | true        |
      | 11111114444  | 201913483157YREOYGLR4ZX6698KLYA2 |        | true      | true          | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 123456789012345       | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123444        | R379-702       | 01                | FDC84510-D85D-4E18-9994-DFBC78D5D793,39F012DF-3F85-4C89-BEC2-500391D1D110 | 10.10.134.45 | 31266     | /api/v1/registrations/ | /api/v1/requests/ | true        |
    When the following devices have been assigned
      | serialNumber | mid | vid |
      | 11111114444  | 36  | 25  |
    Then I should eventually receive a wake up SMS within 10 seconds
    And NGCS has the following modules
      | moduleSerial | camSilent | currentSilent |
      | 11111111111  | false     | false         |
      | 11111114444  | true      | false         |
    And the communication module with serial number "11111114444" should eventually have a status of "ACTIVE" within 20 seconds
    When I am reconditioned with communication module serial number "11111111111"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                          |
      | { "FG": {"SerialNo": "11111114444", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "11111111111", "Software": "SX558-0100", "PCBASerialNo":"123123111", "Subscriptions": [] }, "Hum": {"Software": "SX556-0100"} } |
    Then NGCS has the following devices and modules
      | flowGenSerial | deviceNumber | mid | vid | buildDateTime        | npCapabilityViaCard | npCapabilityViaWireless | fgSoftware | fgBoot     | fgConfig                      | humSoftware | humBoot    | productCode | productName | regionId | fgPcbaSerialNo | moduleSerial | authKey                          | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan    | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions | camHostName  | camPortNo | camApn | camUriRegistration     | camUriBroker      | internalCam |
      | 11111114444   | 123          | 36  | 25  | 2013-10-16T11:36:55Z | true                | true                    | SX567-0100 | SX577-0100 | CX036-001-001-001-100-100-100 | SX556-0100  | SX537-0100 | 37001       | Newport X   | 1        | 34090044       | 11111111111  | 201913483158KFAPM0T3V8LJVDMXJWQ6 | true      | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123111        | R379-702       | 01                |                  | 10.10.134.45 | 31266     | APN    | /api/v1/registrations/ | /api/v1/requests/ | true        |
    And NGCS has the following modules
      | moduleSerial | authKey                          | status   | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan    | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | telcoNetworkGsmMSISDN | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions                                                          | camHostName  | camPortNo | camUriRegistration     | camUriBroker      | internalCam |
      | 11111111111  | 201913483158KFAPM0T3V8LJVDMXJWQ6 | ACTIVE   | true      | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 123456789012345       | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123111        | R379-702       | 01                |                                                                           | 10.10.134.45 | 31266     | /api/v1/registrations/ | /api/v1/requests/ | true        |
      | 11111114444  | 201913483157YREOYGLR4ZX6698KLYA2 | SCRAPPED | true      | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 123456789012345       | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123444        | R379-702       | 01                | FDC84510-D85D-4E18-9994-DFBC78D5D793,39F012DF-3F85-4C89-BEC2-500391D1D110 | 10.10.134.45 | 31266     | /api/v1/registrations/ | /api/v1/requests/ | true        |
    And the server should get the following device configuration change
      | json                                                                                                                                                            |
      | { "serialNo": "11111114444", "mid": 36, "vid": 25, "communicationModuleMode": "ACTIVE", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false} |

  @newport.registration.S2
  @ECO-8220
  Scenario: Don't allow registration with non-spare CAM
    Given the server receives the following manufacturing unit detail
      | resource                                                                                                            |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg22141574392_cam22141574392_020_new.xml  |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg22141574411_cam22141574411_021_new.xml  |
    And the server waits for the device manufactured queue to be empty
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 22141574392               | 22141574392                     |
    And I am a device with the FlowGen serial number "22141574392"
    And I have been connected with CAM with serial number "22141574411" with authentication key "47726994966121365376000000000000"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | { "FG": {"SerialNo": "22141574392", "Software": "SI584-0100-4", "MID": 36, "VID": 34, "PCBASerialNo": "(90)R280-745(91)1(21)4Y060034", "ProductCode":"28311", "Configuration": "CX036-044-020-004-100-100-100" }, "CAM": {"SerialNo": "22141574411", "Software": "SX558-0308", "PCBASerialNo": "438013281", "Subscriptions": [ "3632B858-5E8E-4986-BF43-2DF0E72CEDC0", "652BB610-A1CF-4A8C-A84E-51054BC23115", "E45B3B92-9AE3-44BC-A826-9F00DF279DAE" ] }, "Hum": {"Software": "SX556-0203__"} } |
    Then I should receive a server ok response
    And the server should log a registration error
      | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason |
      | REPLACEMENT_PAIRED  |                       |                         |
    And NGCS has the following devices and modules
      | flowGenSerial | deviceNumber | mid | vid | buildDateTime        | npCapabilityViaCard | npCapabilityViaWireless | fgSoftware | fgBoot     | fgConfig                      | humSoftware | humBoot    | productCode | productName         | regionId | fgPcbaSerialNo                | moduleSerial | authKey                          | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | telcoNetworkGsmMSISDN | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions                                                                                               | camHostName | camPortNo | camApn       | camUriRegistration     | camUriBroker      | internalCam |
      | 22141574392   | 123          | 36  | 34  | 2014-11-18T04:40:54Z | true                | true                    | SX567-0302 | SX577-0200 | CX036-034-022-024-102-101-100 | SX556-0203  | SX537-0101 | 37065       | AirSense 10 AutoSet | 22       | (90)R280-745(91)1(21)4Y060028 | 22141574392  | 20200388032460893896700000000000 | false     | 2G               | MOCK                 | ResMed_X         | 89314404000000000000 | 351700000000000     | 204000000000000     | 123456789012345       | 2014-11-18T04:40:54Z | SX558-0308   | SX559-0106 | 440020493        | R379747        | 03                | 1DCB8822-B259-461F-80B2-0822C1EC8BE0,66A2755A-7006-44BA-B1F1-31D9BC975C72,95EC64A2-A2B0-4788-AA64-0EECC382BE87 | 0.0.0.0     | 31622     | resmed.latam | /api/v1/registrations/ | /api/v1/requests/ | true        |
      | 22141574411   | 123          | 36  | 34  | 2014-11-18T04:40:54Z | true                | true                    | SX567-0302 | SX577-0200 | CX036-034-022-024-102-101-100 | SX556-0203  | SX537-0101 | 37065       | AirSense 10 AutoSet | 22       | (90)R280-745(91)1(21)4Y060034 | 22141574411  | 47726994966121365376000000000000 | false     | 2G               | MOCK                 | ResMed_X         | 89314404000000000000 | 351700000000000     | 204000000000000     | 123456789012345       | 2014-11-18T05:28:52Z | SX558-0308   | SX559-0106 | 438013281        | R379747        | 03                | 3632B858-5E8E-4986-BF43-2DF0E72CEDC0,652BB610-A1CF-4A8C-A84E-51054BC23115,E45B3B92-9AE3-44BC-A826-9F00DF279DAE | 0.0.0.0     | 31622     | resmed.latam | /api/v1/registrations/ | /api/v1/requests/ | true        |

  @newport.registration.S4
  @ECO-8220 @ECO-12459.1
  Scenario: Register Newport device using spare part cam that has subscriptions. Don't allow registration with scrapped spare CAM.
    Given the server receives the following manufacturing unit detail
      | resource                                                                                                                                |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg22141574392_cam22141574392_new_with_more_subscriptions.xml  |
      | /data/manufacture/unit/detail/spare/unit_detail_cam22141574411_spare.xml                                                                |
    And the server waits for the device manufactured queue to be empty
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 22141574392               | 22141574392                     |
    And I am a device with the FlowGen serial number "22141574392"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | { "FG": {"SerialNo": "22141574392", "Software": "SX567-0302", "MID": 36, "VID": 34, "PCBASerialNo": "(90)R280-745(91)1(21)4Y060028", "ProductCode":"37065", "Configuration": "CX036-034-022-024-102-101-100" }, "CAM": {"SerialNo": "22141574392", "Software": "SX558-0308", "PCBASerialNo": "440020493", "Subscriptions": [ "1DCB8822-B259-461F-80B2-0822C1EC8BE0", "66A2755A-7006-44BA-B1F1-31D9BC975C72", "95EC64A2-A2B0-4788-AA64-0EECC382BE87" ] }, "Hum": {"Software": "SX556-0203"} } |
    Then NGCS has the following devices and modules
      | flowGenSerial | deviceNumber | mid | vid | buildDateTime        | npCapabilityViaCard | npCapabilityViaWireless | fgSoftware | fgBoot     | fgConfig                      | humSoftware | humBoot    | productCode | productName         | regionId | fgPcbaSerialNo                | moduleSerial | authKey                          | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | telcoNetworkGsmMSISDN | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions                                                                                               | camHostName | camPortNo | camApn       | camUriRegistration     | camUriBroker      | internalCam |
      | 22141574392   | 123          | 36  | 34  | 2014-11-18T04:40:54Z | true                | true                    | SX567-0302 | SX577-0200 | CX036-034-022-024-102-101-100 | SX556-0203  | SX537-0101 | 37065       | AirSense 10 AutoSet | 22       | (90)R280-745(91)1(21)4Y060028 | 22141574392  | 20200388032460893896700000000000 | true      | 2G               | MOCK                 | ResMed_X         | 89314404000000000000 | 351700000000000     | 204000000000000     | 123456789012345       | 2014-11-18T04:40:54Z | SX558-0308   | SX559-0106 | 440020493        | R379747        | 03                | 1DCB8822-B259-461F-80B2-0822C1EC8BE0,66A2755A-7006-44BA-B1F1-31D9BC975C72,95EC64A2-A2B0-4788-AA64-0EECC382BE87 | 0.0.0.0     | 31622     | resmed.latam | /api/v1/registrations/ | /api/v1/requests/ | true        |
    And NGCS has the following modules
      | moduleSerial | authKey                          | status | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | telcoNetworkGsmMSISDN | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions                                                                                               | camHostName | camPortNo | camApn       | camUriRegistration     | camUriBroker      | internalCam |
      | 22141574411  | 47726994966121365376000000000000 |        | false     | 2G               | MOCK                 | ResMed_X         | 89314404000000000000 | 351700000000000     | 204000000000000     | 123456789012345       | 2014-11-18T05:28:52Z | SX558-0308   | SX559-0106 | 438013281        | R379747        | 03                | A48D026B-3E52-4FE9-94C4-9C230B2678C6,47BD1249-0A38-4C7C-B805-497159F67B1E,91F77992-C636-439F-996E-605C3E017462 | 0.0.0.0     | 31622     | resmed.latam | /api/v1/registrations/ | /api/v1/requests/ | true        |
    When I am reconditioned with communication module serial number "22141574411"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | { "FG": {"SerialNo": "22141574392", "Software": "SX567-0302", "MID": 36, "VID": 34, "PCBASerialNo": "(90)R280-745(91)1(21)4Y060028", "ProductCode":"37065", "Configuration": "CX036-034-022-024-102-101-100" }, "CAM": {"SerialNo": "22141574411", "Software": "SX558-0308", "PCBASerialNo": "438013281", "Subscriptions": [ "3632B858-5E8E-4986-BF43-2DF0E72CEDC0", "652BB610-A1CF-4A8C-A84E-51054BC23115", "E45B3B92-9AE3-44BC-A826-9F00DF279DAE" ] }, "Hum": {"Software": "SX556-0203"} } |
    Then I should receive a server ok response
    And NGCS has the following devices and modules
      | flowGenSerial | moduleSerial | deviceNumber | mid | vid | buildDateTime        | npCapabilityViaCard | npCapabilityViaWireless | fgSoftware | fgBoot     | fgConfig                      | humSoftware | humBoot    | productCode | productName         | regionId | fgPcbaSerialNo                | authKey                          | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | telcoNetworkGsmMSISDN | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions                                                                                               | camHostName | camPortNo | camApn       | camUriRegistration     | camUriBroker      | internalCam |
      | 22141574392   | 22141574411  | 123          | 36  | 34  | 2014-11-18T04:40:54Z | true                | true                    | SX567-0302 | SX577-0200 | CX036-034-022-024-102-101-100 | SX556-0203  | SX537-0101 | 37065       | AirSense 10 AutoSet | 22       | (90)R280-745(91)1(21)4Y060028 | 47726994966121365376000000000000 | true      | 2G               | MOCK                 | ResMed_X         | 89314404000000000000 | 351700000000000     | 204000000000000     | 123456789012345       | 2014-11-18T05:28:52Z | SX558-0308   | SX559-0106 | 438013281        | R379747        | 03                | A48D026B-3E52-4FE9-94C4-9C230B2678C6,47BD1249-0A38-4C7C-B805-497159F67B1E,91F77992-C636-439F-996E-605C3E017462 | 0.0.0.0     | 31622     | resmed.latam | /api/v1/registrations/ | /api/v1/requests/ | true        |
    And NGCS has the following modules
      | moduleSerial | authKey                          | status   | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | telcoNetworkGsmMSISDN | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions                                                                                               | camHostName | camPortNo | camApn       | camUriRegistration     | camUriBroker      | internalCam |
      | 22141574392  | 20200388032460893896700000000000 | SCRAPPED | true      | 2G               | MOCK                 | ResMed_X         | 89314404000000000000 | 351700000000000     | 204000000000000     | 123456789012345       | 2014-11-18T04:40:54Z | SX558-0308   | SX559-0106 | 440020493        | R379747        | 03                | 1DCB8822-B259-461F-80B2-0822C1EC8BE0,66A2755A-7006-44BA-B1F1-31D9BC975C72,95EC64A2-A2B0-4788-AA64-0EECC382BE87 | 0.0.0.0     | 31622     | resmed.latam | /api/v1/registrations/ | /api/v1/requests/ | true        |
    # Reconnect the FG to the scrap cellular module and verify registration to be logged with error
    When I have been connected with CAM with serial number "22141574392" with authentication key "20200388032460893896700000000000"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                                                       |
      | { "FG": {"SerialNo": "22141574392", "Software": "SI584-0100-4", "MID": 36, "VID": 34, "PCBASerialNo": "(90)R280-745(91)1(21)4Y060034", "ProductCode":"28311", "Configuration": "CX036-044-020-004-100-100-100" }, "CAM": {"SerialNo": "22141574392", "Software": "SX558-0308", "PCBASerialNo": "438013281", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0203__"} } |
    Then I should receive a server ok response
    And the server should log a registration error
      | ValidationVetoPoint   | ValidationFailureType | ValidationFailureReason |
      | REPLACEMENT_DISCARDED |                       |                         |

  @newport.registration.S5
  @ECO-12819.2 @ECO-12819.2a
  @ECO-13565.2 @ECO-13565.2a
  Scenario: Registered Aeris device should have a status of ACTIVE and an event history record
    Given the server receives the following manufacturing unit detail
      | resource                                                                                                        |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg19191911999_cam19191911998_new.xml  |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 19191911999               | 19191911998                     |
    And I am a device with the FlowGen serial number "19191911999"
    And the communication module with serial number "19191911998" should have a status of "PROVISIONED"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "19191911999", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo": "34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "19191911998", "Software": "SX558-0100", "PCBASerialNo": "13152G00001", "Subscriptions": [ "70FA4707-EB88-4A21-82C5-DB1F2AB7732D", "3D12B449-68A2-4D03-A4E8-D09F41CCA04F" ] }, "Hum": {"Software": "SX558-0100"} } |
    And the communication module with serial number "19191911998" should eventually have a status of "ACTIVE" within 5 seconds
    And an aeris event history record is created with the following data
      | camSerialNo | flowGenSerial | status    | eventResult | numberOfRecords |
      | 19191911998 | 19191911999   | ACTIVATED |             | 1               |

  @newport.registration.S6
  @ECO-13276.1
  @ECO-13565.2 @ECO-13565.2b
  Scenario: Registration event from a suspended device should change status to active
    Given devices with following properties have been manufactured
      | moduleSerial | authKey      | flowGenSerial | deviceNumber | mid | vid | telcoCarrierProvider | productCode | pcbaSerialNo | internalCommModule |
      | 20102141729  | 201913483157 | 20070811230   | 123          | 36  | 26  | AERIS                | 9745        | 1A345678     | true               |
    And the server waits for the device manufactured queue to be empty
    And the server should not produce device manufactured error
    And I am a device with the FlowGen serial number "20070811230"
    And the communication module with serial number "20102141729" has suspended status for 1 days
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811230", "Software": "FGABCDEFH", "MID": 36, "VID": 26, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "20102141729", "Software": "CAMABCDEFH", "PCBASerialNo":"1A345678", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    Then NGCS sends this registration information to the HI Cloud API
      | flowGenSerial | appVersion | mid | vid | fgpcb    | prodCode | confVersion        | moduleSerial | camVersion | campcb   | humVersion |
      | 20070811230   | FGABCDEFH  | 36  | 26  | 1A345678 | 9745     | CX-ABC-123-DEF-456 | 20102141729  | CAMABCDEFH | 1A345678 | HUMABCDEFH |
    And the server has the following comm modules
      | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   |
      | 20102141729 | 1A345678     | ACTIVE             | ACTIVE             | AERIS                | CAMABCDEFH |
    And the communication module with serial number "20102141729" should eventually have a status of "ACTIVE" within 5 seconds
    And an aeris event history record is created with the following data
      | camSerialNo | flowGenSerial | status    | eventResult | numberOfRecords |
      | 20102141729 | 20070811230   | ACTIVATED |             | 2               |

  @newport.registration.S7
  @ECO-6637.1 @ECO-6637.2 @ECO-6637.3 @ECO-6637.3a @ECO-6637.3b @ECO-6637.3c
  @ECO-6091.1
  @ECO-12819.2
  Scenario: Register Newport device using spare part cam, where the initial module was silent by defaul and also is currently silent
    Given the server receives the following manufacturing unit detail
      | resource                                                                      |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111114444_cam11111114444_new.xml          |
      | /data/manufacture/unit/detail/spare/unit_detail_cam11111111111_spare.xml      |
    And the server waits for the device manufactured queue to be empty
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 11111114444               | 11111114444                     |
    And I am a device with the FlowGen serial number "11111114444"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | { "FG": {"SerialNo": "11111114444", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "11111114444", "Software": "SX558-0100", "PCBASerialNo":"123123444", "Subscriptions": ["FDC84510-D85D-4E18-9994-DFBC78D5D793","39F012DF-3F85-4C89-BEC2-500391D1D110"] }, "Hum": {"Software": "SX556-0100"} } |
    Then NGCS has the following devices and modules
      | flowGenSerial | deviceNumber | mid | vid | buildDateTime        | npCapabilityViaCard | npCapabilityViaWireless | fgSoftware | fgBoot     | fgConfig                      | humSoftware | humBoot    | productCode | productName | regionId | fgPcbaSerialNo | moduleSerial | authKey                          | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan    | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions | camHostName  | camPortNo | camApn | camUriRegistration     | camUriBroker      | internalCam |
      | 11111114444   | 123          | 36  | 25  | 2013-10-16T11:36:55Z | true                | true                    | SX567-0100 | SX577-0100 | CX036-001-001-001-100-100-100 | SX556-0100  | SX537-0100 | 37001       | Newport X   | 1        | 34090044       | 11111114444  | 201913483157YREOYGLR4ZX6698KLYA2 | true      | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123444        | R379-702       | 01                |                  | 10.10.134.45 | 31266     | APN    | /api/v1/registrations/ | /api/v1/requests/ | true        |
    And NGCS has the following modules
      | moduleSerial | authKey                          | status | camSilent | currentSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan    | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | telcoNetworkGsmMSISDN | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions                                                          | camHostName  | camPortNo | camUriRegistration     | camUriBroker      | internalCam |
      | 11111111111  | 201913483158KFAPM0T3V8LJVDMXJWQ6 |        | false     | false         | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 123456789012345       | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123111        | R379-702       | 01                |                                                                           | 10.10.134.45 | 31266     | /api/v1/registrations/ | /api/v1/requests/ | true        |
      | 11111114444  | 201913483157YREOYGLR4ZX6698KLYA2 |        | true      | true          | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 123456789012345       | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123444        | R379-702       | 01                | FDC84510-D85D-4E18-9994-DFBC78D5D793,39F012DF-3F85-4C89-BEC2-500391D1D110 | 10.10.134.45 | 31266     | /api/v1/registrations/ | /api/v1/requests/ | true        |
    And the communication module with serial number "11111114444" should eventually have a status of "ACTIVE" within 5 seconds
    When I am reconditioned with communication module serial number "11111111111"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                          |
      | { "FG": {"SerialNo": "11111114444", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "11111111111", "Software": "SX558-0100", "PCBASerialNo":"123123111", "Subscriptions": [] }, "Hum": {"Software": "SX556-0100"} } |
    Then NGCS has the following devices and modules
      | flowGenSerial | deviceNumber | mid | vid | buildDateTime        | npCapabilityViaCard | npCapabilityViaWireless | fgSoftware | fgBoot     | fgConfig                      | humSoftware | humBoot    | productCode | productName | regionId | fgPcbaSerialNo | moduleSerial | authKey                          | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan    | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions | camHostName  | camPortNo | camApn | camUriRegistration     | camUriBroker      | internalCam |
      | 11111114444   | 123          | 36  | 25  | 2013-10-16T11:36:55Z | true                | true                    | SX567-0100 | SX577-0100 | CX036-001-001-001-100-100-100 | SX556-0100  | SX537-0100 | 37001       | Newport X   | 1        | 34090044       | 11111111111  | 201913483158KFAPM0T3V8LJVDMXJWQ6 | true      | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123111        | R379-702       | 01                |                  | 10.10.134.45 | 31266     | APN    | /api/v1/registrations/ | /api/v1/requests/ | true        |
    And NGCS has the following modules
      | moduleSerial | authKey                          | status   | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan    | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | telcoNetworkGsmMSISDN | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions                                                          | camHostName  | camPortNo | camUriRegistration     | camUriBroker      | internalCam |
      | 11111111111  | 201913483158KFAPM0T3V8LJVDMXJWQ6 | ACTIVE   | true      | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 123456789012345       | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123111        | R379-702       | 01                |                                                                           | 10.10.134.45 | 31266     | /api/v1/registrations/ | /api/v1/requests/ | true        |
      | 11111114444  | 201913483157YREOYGLR4ZX6698KLYA2 | SCRAPPED | true      | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 123456789012345       | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123444        | R379-702       | 01                | FDC84510-D85D-4E18-9994-DFBC78D5D793,39F012DF-3F85-4C89-BEC2-500391D1D110 | 10.10.134.45 | 31266     | /api/v1/registrations/ | /api/v1/requests/ | true        |
    And the server should get the following device configuration change
      | json                                                                                                                                                            |
      | { "serialNo": "11111114444", "mid": 36, "vid": 25, "communicationModuleMode": "SILENT", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false} |

