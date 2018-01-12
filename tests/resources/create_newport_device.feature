@newport
@create.newport.device
@ECO-5389
@ECO-5390
@ECO-5391
@ECO-5803
@ECO-5875
@ECO-5930
@ECO-6008
@ECO-6007

Feature:
  (ECO-5389) As a clinical user
  I want information about all Newport devices to be present in the system
  so I allocate them to my patients and receive data from them successfully.

  (ECO-5390) As a clinical user
  I want information about all Newport devices to be present in the system
  so I allocate them to my patients and receive data from them successfully.

  (ECO-5391) As a clinical user
  I want information about all Newport devices to be present in the system
  so I allocate them to my patients and receive data from them successfully.

  (ECO-5803) As a clinical user
  I want information about all Newport devices to be present in the system
  so I allocate them to my patients and receive data from them successfully.

  (ECO-5875) As ECO
  I want to load the subscriptions that have been programmed into a CAM
  so that I can validate posted data for those.

  (ECO-5930) As ECO
  I do not want to load the FG PCBA Part Number and FG PCBA Version Number
  as these two fields are not required.

  (ECO-6008) As ECO
  I want to gracefully handle any errors while loading subscriptions over the manufacturing interface
  so that erroneous JSON subscriptions are not loaded into ECO.

  (ECO-6007) As ECO
  I want to allow units that are missing the FG or CAM information to be populated into ECO
  so that ECO knows about these units.

# ACCEPTANCE CRITERIA: (ECO-5389)
# Note 1: This story loads the essential fields about each device after manufacture. Further fields will be added in subsequent stories.
# 1. An Applications Support user shall be able to create a record of manufactured therapy devices in ECO.
# 2. The device information shall be able to be specified in bulk through an XML REST interface with basic authentication.
# 3. The field names shall be as specified in D379-513.
# 4. If the FG/CAM Status (i.e BuildStatus) is NEW then the device shall be created in ECO.
# 5. For each device listed the following information shall be loaded:
# 5a. Therapy device serial number (FgSerialNo);
# 5b. Therapy Device Number (FgDeviceNo);
# 5c. FG MID (FgMID);
# 5d. FG VID (FgVID);
# 5e. CAM serial number (Resmed) (CamSerialNo)
# 5f. CAM Authorisation Key (CamAuthKey);
# 5g. Night Profile capable via card (NpCardSupport)
# 5h. Night Profile capable via wireless (NpWirelessSupport)
# 5i. Silent state for CAM (CamSilentState) Note: The intent of this field is to tell the CAM to be silent until it receives an SMS asking it to start communicating with the server.
# Note 2: Sample xml file from D379-513 (MSP_ECO_XMLSample_ETv2.XML) is attached.
# Note 3: Checking for the uniqueness of certain fields is handled by ECO-5491

# ACCEPTANCE CRITERIA: (ECO-5390)
# Note 1: This story extends ECO-5389 by adding more fields to the manufacturing interface.
# 1. For each device loaded into ECO from manufacturing as per ECO-5389 AC#5 the following information shall also be loaded:
# 1a. Network Type (TelcoType); Note: 1xRTT is CDMA
# 1b. Network Provider (TelcoProvider);
# 1c. Telco plan id (TelcoPlanID)
# 1d. SIM id number (ICCID) (CamGsmSimID)
# 1e. RF module id (IMEI) (CamGsmIMEI)
# 1f. Network id (IMSI) (CamGsmIMSI)
# 1g. Phone number (MSISDN) (CamGsmMSISDN) (Note blank expected initially in Newport)
# 1h. RF module id (MEID) (CamCdmaMEID)
# 1i. Network id (MIN) (CamCdmaMIN)
# 1j. Phone number (MDN) (CamCdmaMDN)
# 1k. Activation clock start date (TelcoStartDate)
# 1l. Manufacturing Test Date/Time (FgBuildDateTime)
# Note 2: Take care before making any telco numbers an index in the database. Some numbers like Network ids (IMSI or MIN) and Phone numbers (MSISDN or MDN) can be re-used by the Telco if devices are scrapped.
# Note 3: There is no need to validate the relationship of different fields of the device. For example to check that a CDMA device has the telco information required for CDMA.

# ACCEPTANCE CRITERIA: (ECO-5391)
# 1. For each device loaded from manufacturing as per ECO-5389 AC#5 the following information shall also be loaded:
# FG Identification info
# 1a. FG Software (application) (FgFirmwareVersion);
# 1b. FG Software (bootloader) (FgBootVersion);
# 1c. FG Config Software (FgConfigVersion);
# 1d. Humidifier SW (application) (HumFirmwareVersion);
# 1e. Humidifier SW (bootloader) (HumBootVersion);
# 1f. Product code (base unit) FgProductCode
# 1g. Product Name (PNA node) (FgProductName)
# 1h. FG PCBA serial number (FgPcbaSerialNo)
# CAM identification info
# 1i. CAM SW (application) (CamFirmwareVersion);
# 1j. CAM SW (bootloader) (CamBootVersion);
# 1k. CAM PCBA serial number (Sanmina) (CamPcbaSerialNo)
# 1l. CAM PCBA Part Number (CamPcbaPartNo)
# 1m. CAM PCBA Version Number (CamPcbaVersionNo)
# 1n. Loaded subscriptions (CamSubscriptions)
# 1o. Loaded hostname (CamHostName)
# 1p. Loaded port number (CamPortNo)
# 1q. APN (CamAPN)
# 1r. Registration URI (CamUriRegistration)
# 1s. Broker URI (CamUriBroker)
# 1t. Internal CAM (InternalCam)

# ACCEPTANCE CRITERIA: (ECO-5803)
# Note 1: This story extends ECO-5389 by adding more fields to the manufacturing interface.
# 1. For each device loaded into ECO from manufacturing as per ECO-5389 AC#5 the following information shall also be loaded:
# 1a. FG PCBA Part Number (FgPcbaPartNo)
# 1b. FG PCBA Version Number (FgPcbaVersionNo)
# 1c. Region ID (RegionId)
# Note 2: Currently, we have a single field, FG PCBA Serial Number, which is intended to hold a concatenation of the FG PCBA Part Number, FG PCBA Version Number and FG PCBA Serial Number. The intent behind AC1a and AC1b is to split that field into three separate fields, which can be individually queried.
# Note 3: The intent behind AC1c is to provide a Region ID for each manufactured device.

# ACCEPTANCE CRITERIA: (ECO-5875)
# Note 1: The intent of this story is the following. Subscription JSON's are loaded into a CAM during manufacture. ECO also needs to know these JSON's so that it can validate the posted data. This story intends to load these JSON's into ECO.
# 1. For each device loaded into ECO from manufacturing as per ECO-5389 AC#5, the subscriptions loaded onto the CAM shall also be loaded into ECO.

# ACCEPTANCE CRITERIA: (ECO-5930)
# Note 1: The intent of this story is the following. The FG PCBA Serial Number was initially split into three fields: The Serial Number, Part Number and Version Number. It has since been agreed that this split is no longer necessary. It is acceptable to get all the information we need in the FG PCBA Serial Number field. Hence, this story removes the two fields that are no longer necessary.
# 1. The FG PCBA Part Number and the FG PCBA Version Number fields defined in ECO-5803 AC1a and AC1b shall not be loaded. Note: This obsoletes ECO-5803 AC1a and AC1b
# Note 2: The intent is that these two fields will be removed from the NGCS database.
# These two fields have already been removed from the XML schema in D379-513.

# ACCEPTANCE CRITERIA: (ECO-6008)
# Note 1:* The intent of this story is the following. ECO-5875 allows subscription JSON's to be loaded over the manufacturing interface. This story does error checking on the JSON's loaded over the manufacturing interface.
# 1. If a unit submitted over the manufacturing interface is not rejected as per ECO-5491, and a subscription JSON for the unit has a subscription ID which already exists in ECO,
# 1a. The corresponding unit shall be rejected *Note:* This implies that FG, CAM or Subscription information shall not be saved in the database for this device.
# 1b. The unit shall be marked as having a subscription with a duplicate subscription ID
# 1c. The first duplicate subscription ID shall be returned.
# Note 2:* It is expected that the Subscription section of the response is always present. Its contents will be empty if no duplicate subscription ID's are detected.
# Note 3:* The intent is that we will check for duplicate subscription ID's only when the submitted unit does not have a duplicate FG or duplicate CAM. If the FG or CAM are duplicate, it is not required to check for duplicate subscription ID's
# Note 4:* For AC1, the intent is for the duplicate subscription ID to be returned as part of the polling response.
# Note 5:* A given unit may have multiple subscription ID's (from multiple subscription JSONs) which are duplicated in the database. It is sufficient to return the first subscription ID which is duplicated.
# Note 6:*  The required format for the response is shown in the following examples.
# Example 1: This example shows a unit where a duplicate subscription ID has been detected, but the FG and CAM Serial Numbers are not duplicate:
#
# <BadUnits>
# 	  <Unit>
# 	    <FG>
# 	      <SerialNo>20130000001</SerialNo>
# 	      <ErrorCode></ErrorCode>
#     </FG>
# 	    <CAM>
# 	      <SerialNo>20130000001</SerialNo>
# 	      <ErrorCode></ErrorCode>
# 	    </CAM>
#     <Subscription>
#       <SubscriptionId>8dc0d080-b0c0-11e3-a5e2-0800200c9a66</SubscriptionId>
#       <ErrorCode>DUPLICATE</ErrorCode>
#     </Subscription>
# 	  </Unit>
# 	</BadUnits>
#
# Example 2: This example shows a unit where a duplicate subscription ID has been detected, but which also has a duplicate FG and CAM Serial Number. Note that the Subscription section contains no information.
#
# <BadUnits>
# 	  <Unit>
# 	    <FG>
# 	      <SerialNo>20130000001</SerialNo>
# 	      <ErrorCode>DUPLICATE</ErrorCode>
# 	    </FG>
# 	    <CAM>
# 	      <SerialNo>20130000001</SerialNo>
# 	      <ErrorCode>DUPLICATE</ErrorCode>
# 	    </CAM>
#     <Subscription>
#       <SubscriptionId></SubscriptionId>
#       <ErrorCode></ErrorCode>
#     </Subscription>
# 	  </Unit>
# 	</BadUnits>
#
# *Note 7:* This story excludes the UPDATE workflow

# ACCEPTANCE CRITERIA: (ECO-6007)
# Note 1: The intent of this story is the following. The error handling introduced by ECO-5491 expects that a manufactured unit should have both the FG and CAM details. If a manufactured unit does not have both FG and CAM details, it will be rejected by the error handling. This has the effect of blocking CAM as spare parts (which do not have FG information). This story allows CAM as a spare part to be loaded.
# 1. When loading a record of manufactured devices into ECO (as per ECO-5389), it shall be possible to load a device which has CAM information but no FlowGen information Note: This corresponds to a CAM spare part.
# Note 2: This story extends ECO-5491 by allowing the devices of the types mentioned above, to be loaded into ECO
# Note 3: It is expected that the duplicate handling will be the same as that introduced in ECO-5491. Namely, the Flow Gen section of the error will not contain a serial number or error code, while the CAM section will contain the serial number and the error code DUPLICATE

  Background:

  @create.newport.device.S1
  @ECO-5389
  @ECO-5390
  @ECO-5391
  @ECO-5803.1 @ECO-5803.1a @ECO-5803.1b @ECO-5803.1c
  @ECO-5930.1
  Scenario: Bulk load of Newport device data
    When the server receives the following manufacturing unit detail
      | resource                                                                                                            |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111111111_cam11111111111_003_new.xml  |
    Then the server should not produce device manufactured error
    And NGCS has the following devices and modules
      | flowGenSerial | deviceNumber | mid | vid | buildDateTime        | npCapabilityViaCard | npCapabilityViaWireless | fgSoftware | fgBoot     | fgConfig                      | humSoftware | humBoot    | productCode | productName | regionId | fgPcbaSerialNo | moduleSerial | authKey                          | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan    | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | telcoNetworkGsmMSISDN | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions                                                          | camHostName  | camPortNo | camApn | camUriRegistration     | camUriBroker      | internalCam |
      | 11111111111   | 123          | 36  | 25  | 2013-10-16T11:36:55Z | true                | true                    | SX567-0100 | SX577-0100 | CX036-001-001-001-100-100-100 | SX556-0100  | SX537-0100 | 37001       | Newport X   | 1        | 34090044       | 11111111111  | 201913483157RM9U9PQO0FD7UOFMQG09 | true      | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 123456789012345       | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 13152G00001      | R379-702       | 01                | 70FA4707-EB88-4A21-82C5-DB1F2AB7732D,3D12B449-68A2-4D03-A4E8-D09F41CCA04F | 10.10.134.45 | 31266     | APN    | /api/v1/registrations/ | /api/v1/requests/ | true        |

  @create.newport.device.S2
  @ECO-5875.1
  @ECO-5930.1
  Scenario: Bulk load of Newport device data
    When the server receives the following manufacturing unit detail
      | resource                                                                                                            |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111111111_cam11111111111_006_new.xml  |
    Then the server should not produce device manufactured error
    And NGCS has the following devices and modules
      | flowGenSerial | deviceNumber | mid | vid | buildDateTime        | npCapabilityViaCard | npCapabilityViaWireless | fgSoftware | fgBoot     | fgConfig                      | humSoftware | humBoot    | productCode | productName | regionId | fgPcbaSerialNo | moduleSerial | authKey                          | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan    | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | telcoNetworkGsmMSISDN | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions                                                          | camHostName  | camPortNo | camApn | camUriRegistration     | camUriBroker      | internalCam |
      | 11111111111   | 123          | 36  | 25  | 2013-10-16T11:36:55Z | true                | true                    | SX567-0100 | SX577-0100 | CX036-001-001-001-100-100-100 | SX556-0100  | SX537-0100 | 37001       | Newport X   | 1        | 34090044       | 11111111111  | 2019134831570FO0EMNF7SMB8FAMEH0W | true      | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 123456789012345       | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 13152G00001      | R379-702       | 01                | D93FD8C4-EF82-43C2-A7DA-0E6A841100F1,B884F699-84ED-446E-997A-8B15B09B6979 | 10.10.134.45 | 31266     | APN    | /api/v1/registrations/ | /api/v1/requests/ | true        |
    And NGCS has the following subscriptions
      | subscriptionId                       | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | D93FD8C4-EF82-43C2-A7DA-0E6A841100F1 | {  "FG.SerialNo": "11111111111",  "SubscriptionId": "D93FD8C4-EF82-43C2-A7DA-0E6A841100F1",  "ServicePoint": "/api/v1/therapy/summaries",  "Trigger": {    "Collect": [ "HALO" ],    "Conditional": {      "Setting": "Val.Duration",      "Value": 0    }  },  "Data": [    "Val.Duration"  ]}                                                                                                                                                                                                                                          |
      | B884F699-84ED-446E-997A-8B15B09B6979 | {  "FG.SerialNo": "11111111111",  "SubscriptionId": "B884F699-84ED-446E-997A-8B15B09B6979",  "ServicePoint": "/api/v1/therapy/settings",  "Trigger": {    "Collect": [ "HALO" ],    "OnlyOnChange": true,    "Conditional": {      "Setting": "Val.Mode",      "Value": "AutoSet"    }  },  "Data": [    "Val.Mode",    "AutoSet.Val.Press",    "AutoSet.Val.StartPress",    "AutoSet.Val.EPR.EPREnable",    "AutoSet.Val.EPR.EPRType",    "AutoSet.Val.EPR.Level",    "AutoSet.Val.Ramp.RampEnable",    "AutoSet.Val.Ramp.RampTime"  ]} |

  @create.newport.device.S3
  @ECO-6008.1
  Scenario: Bulk load of Newport device data
    When the server receives the following manufacturing unit detail
      | resource                                                                                                            |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111111111_cam11111111111_006_new.xml  |
    Then the server should not produce device manufactured error
    And NGCS has the following devices and modules
      | flowGenSerial | deviceNumber | mid | vid | buildDateTime        | npCapabilityViaCard | npCapabilityViaWireless | fgSoftware | fgBoot     | fgConfig                      | humSoftware | humBoot    | productCode | productName | regionId | fgPcbaSerialNo | moduleSerial | authKey                          | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan    | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | telcoNetworkGsmMSISDN | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions                                                          | camHostName  | camPortNo | camApn | camUriRegistration     | camUriBroker      | internalCam |
      | 11111111111   | 123          | 36  | 25  | 2013-10-16T11:36:55Z | true                | true                    | SX567-0100 | SX577-0100 | CX036-001-001-001-100-100-100 | SX556-0100  | SX537-0100 | 37001       | Newport X   | 1        | 34090044       | 11111111111  | 2019134831570FO0EMNF7SMB8FAMEH0W | true      | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 123456789012345       | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 13152G00001      | R379-702       | 01                | D93FD8C4-EF82-43C2-A7DA-0E6A841100F1,B884F699-84ED-446E-997A-8B15B09B6979 | 10.10.134.45 | 31266     | APN    | /api/v1/registrations/ | /api/v1/requests/ | true        |
    And NGCS has the following subscriptions
      | subscriptionId                       | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | D93FD8C4-EF82-43C2-A7DA-0E6A841100F1 | {"FG.SerialNo":"11111111111","SubscriptionId":"D93FD8C4-EF82-43C2-A7DA-0E6A841100F1","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
      | B884F699-84ED-446E-997A-8B15B09B6979 | {"FG.SerialNo":"11111111111","SubscriptionId":"B884F699-84ED-446E-997A-8B15B09B6979","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |
    # Note that we're sending the same subscriptions, hence the subscription IDs are duplicate.
    When the following subscriptions are loaded into NGCS
      | /data/upload_subscriptions_006.json |
    Then the subscriptions will not be saved
    And the first duplicate subscription ID "D93FD8C4-EF82-43C2-A7DA-0E6A841100F1" is returned
    # Note that there are no new subscriptions saved to the database
    And NGCS has the following subscriptions
      | subscriptionId                       | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | D93FD8C4-EF82-43C2-A7DA-0E6A841100F1 | {"FG.SerialNo":"11111111111","SubscriptionId":"D93FD8C4-EF82-43C2-A7DA-0E6A841100F1","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
      | B884F699-84ED-446E-997A-8B15B09B6979 | {"FG.SerialNo":"11111111111","SubscriptionId":"B884F699-84ED-446E-997A-8B15B09B6979","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |

  @create.newport.device.S4
  @ECO-6007.1
  Scenario: Adding CAM as a spare part
    When the server receives the following manufacturing unit detail
      | resource                                                                  |
      | /data/manufacture/unit/detail/spare/unit_detail_cam11111111111_spare.xml  |
    Then the server should not produce device manufactured error
    And NGCS has the following modules
      | moduleSerial | authKey                          | status | camSilent | telcoCarrierType | telcoCarrierProvider | telcoCarrierPlan    | telcoNetworkGsmSimID | telcoNetworkGsmIMEI | telcoNetworkGsmIMSI | telcoNetworkGsmMSISDN | activationDateTime   | commSoftware | commBoot   | commPcbaSerialNo | commPcbaPartNo | commPcbaVersionNo | camSubscriptions | camHostName  | camPortNo | camUriRegistration     | camUriBroker      | internalCam |
      | 11111111111  | 201913483158KFAPM0T3V8LJVDMXJWQ6 |        | false     | 2G               | MOCK                 | Internet_TARIFF_001 | 89300000000000000000 | 490000000000000     | 204000000000000     | 123456789012345       | 2013-09-02T06:24:00Z | SX558-0100   | SX999-0123 | 123123111        | R379-702       | 01                |                  | 10.10.134.45 | 31266     | /api/v1/registrations/ | /api/v1/requests/ | true        |