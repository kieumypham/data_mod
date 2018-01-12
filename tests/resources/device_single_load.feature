@newport
@device.single.load
@ECO-5389
@ECO-5390
@ECO-5391
@ECO-5394
@ECO-5491
@ECO-5803
@ECO-5875
@ECO-5892
@ECO-5930
@ECO-6008
@ECO-6119
@ECO-6007
@ECO-6090
@ECO-6097
@ECO-9651
@ECO-10512
@ECO-10589
@ECO-12819
@ECO-16986

Feature:
  (@ECO-5389) As a clinical user
   I want information about all Newport devices to be present in the system
  so I allocate them to my patients and receive data from them successfully
  (@ECO-5390) As a clinical user
   I want information about all Newport devices to be present in the system
  so I allocate them to may patients and receive data from them successfully
  (@ECO-5391) As a clinical user
   I want information about all Newport devices to be present in the system
  so I allocate them to my patients and receive data from them successfully
  (@ECO-5394) As a clinical user
   I want information about Newport devices to be up-to-date in case they are serviced in the field
  so that the correct therapy information continues to be delivered for my patients
  (@ECO-5491) As ECO
   I want to gracefully handle errors arising in Newport device creation through the Manufacturing interface
  so that the Application Support user is well informed.
  (@ECO-5803) As a clinical user
   I want information about all Newport devices to be present in the system
  so I allocate them to my patients and receive data from them successfully
  (@ECO-5892) As ECO
   I want to provide a mechanism for the App Support user to query the status of a job
  so that the user is well informed.
  (@ECO-5875) As ECO
   I want to load the subscriptions that have been programmed into a CAM
  so that I can validate posted data for those.
  as these two fields are not required.
  (@ECO-5930) As ECO
  As ECO I do not want to load the FG PCBA Part Number and FG PCBA Version Number
  as these two fields are not required.
  (@ECO-6008) As ECO
   I want to gracefully handle any errors while loading subscriptions over the manufacturing interface
  so that erroneous JSON subscriptions are not loaded into ECO.
  (@ECO-6119) As ECO
   I want to allow a device without subscriptions to be loaded via the manufacturing interface
  so that I can load a CAM as a spare part.
  (@ECO-6007) As ECO
   I want to allow units that are missing the FG or CAM information to be populated into ECO
  so that ECO knows about these units.
  (@ECO-6090) As ECO
   I want to be able to scrap a device if it is no longer in use
  so that I do not incur a telco bill.
  (@ECO-6097) Job status of manufacture device upload service was not updated to COMPLETE_SUCCESS
  (ECO-9651) As an manufacturer
   I want to be able to register my external CAMs with bridge with NGCS
  so that NGCS is notified when the bridge and CAM become active
  (ECO-10512) As a user
   I want information about all Stellar and Astral devices to be present in the system
  so that I can receive data and communicate with connected therapy devices effectively.
  (ECO-10589) As a user
   I want information about all Monaco devices to be present in the system
  so I can receive data and communicate with connected therapy devices effectively.
  (ECO-12819) As NGCS
   I want to store newly manufactured CAM units with a status of PROVISIONED instead of ACTIVE,
  so that NGCS can properly manage suspend state for CAMs.
  (ECO-16986) As a user
   I want information about all Newport and Geneva devices to be present in the system
   so I can receive data and communicate with connected therapy devices effectively

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
#
# FG Identification info
# 1a. FG Software (application) (FgFirmwareVersion);
# 1b. FG Software (bootloader) (FgBootVersion);
# 1c. FG Config Software (FgConfigVersion);
# 1d. Humidifier SW (application) (HumFirmwareVersion);
# 1e. Humidifier SW (bootloader) (HumBootVersion);
# 1f. Product code (base unit) FgProductCode
# 1g. Product Name (PNA node) (FgProductName)
# 1h. FG PCBA serial number (FgPcbaSerialNo)
#
# CAM identification info
# 1i. CAM SW (application) (CamFirmwareVersion);
# 1j. CAM SW (bootloader) (CamBootVersion);
# 1k. CAM PCBA serial number (Sanmina) (CamPcbaSerialNo)
# 1l. CAM PCBA Part Number (CamPcbaPartNo)
# lm. CAM PCBA Version Number (CamPcbaVersionNo)
# 1n. Loaded subscriptions (CamSubscriptions)
# 1o. Loaded hostname (CamHostName)
# 1p. Loaded port number (CamPortNo)
# 1q. APN (CamAPN)
# 1r. Registration URI (CamUriRegistration)
# 1s. Broker URI (CamUriBroker)
# 1t. Internal CAM (InternalCam)

# ACCEPTANCE CRITERIA: (ECO-5394)
# *Note 1:* This story extends the requirements from ECO-5389 which allowed devices to be created from manufacturing. There are two scenarios in which an update is required: a) A unit (FG+CAM) is put through the test system without changing the FG or CAM serial numbers. In this case, the unit will get new subscriptions. b) A unit (FG+CAM) is put through the test system and its FG and CAM serial numbers have changed.
# *Note 2:* An UPDATE is only required for a FG+CAM unit, and not for a CAM spare part. Further, the CAM PCBA Serial Number cannot change during an UPDATE. Hence, this can be used as they key in performing the update
# 1.Manufacturing shall be able to update the manufactured therapy device information in ECO.
# 2.The device information shall be able to be specified in bulk as per ECO-5389 AC#2 and AC#3, with the BuildStatus UPDATE *Note:* The UPDATE records may be interspersed with NEW records
# 3.For the UPDATE record, if the CAM PCBA serial number is found in ECO and the Flow Gen Serial Number provided in the xml is the same as the serial number stored in ECO,
# 3a. The details for the Flow Gen and CAM module shall be updated to those reported in the xml
# 3b. The existing subscriptions for the CAM module shall be deleted and the subscriptions specified in the xml shall be added for the CAM
# 4.For the UPDATE record, if the CAM PCBA serial number is found in ECO and the currently associated Flow Gen Serial Number does not match the Flow Gen Serial number provided in the xml,
# 4a. If the Flow Gen Serial Number or the CAM Serial Number provided in the xml exists in ECO then an error shall be returned indicating that the serial number used in the update is a duplicate. *Note:* Error xml contained in Note 3
# 4b. A new Flow Gen shall be created in ECO using details provided in the xml
# 4c. The existing Flow Gen for the updated unit shall be marked as scrapped in ECO
# 4d. The CAM for the updated unit shall be associated with this newly created flow gen
# 4e. The CAM details shall be updated based on the information provided in the xml
# 4f. The existing subscriptions for the CAM module shall be deleted and the subscriptions specified in the xml shall be added for the CAM
# 5.If the FG/CAM Status (column BuildStatus) is UPDATE and the CAM PCBA Serial Number does not exist in ECO then an error shall be returned indicating the Flow Gen Serial Number *Note:* Error xml contained in Note 5
# 6. If the unit being updated is a CAM Spare Part, this update shall be rejected and an error returned. *Note:* Error xml contained in Note 4
# 7. If the submitted xml corresponds to a CAM Spare Part, but a FG + CAM unit exists in ECO with a matching CAM PCBA Serial Number, this update shall be rejected and an error returned indicating the submitted CAM Serial Number. Note: Error xml contained in Note 6
# 8. If the submitted xml has a subscription ID that already exists in the ECO database, the update shall be rejected and an error returned indicating the submitted CAM Serial Number and the FG Serial Number (if the submitted unit is not a CAM spare part). Note: Error xml contained in Note 7
#
# *Note 3:*
# Note 3.1: Error xml for a duplicate FG SN when doing update
# <EcoResponse>
#     <JobId>97d88e79-bb5e-41b9-b319-09df9cdca873</JobId>
#     <Status>COMPLETE-ERROR</Status>
#     <BadUnits>
#         <Unit>
#             <FG>
#                 <SerialNo>99991300288</SerialNo>
#                 <ErrorCode>DUPLICATE</ErrorCode>
#             </FG>
#             <CAM>
#                 <SerialNo></SerialNo>
#                 <ErrorCode></ErrorCode>
#             </CAM>
#             <Subscription>
#                 <SubscriptionId></SubscriptionId>
#                 <ErrorCode></ErrorCode>
#             </Subscription>
#         </Unit>
#     </BadUnits>
# </EcoResponse>
#
# Note 3.2: Error xml for a duplicate CAM SN when doing update
# <EcoResponse>
#     <JobId>97d88e79-bb5e-41b9-b319-09df9cdca873</JobId>
#     <Status>COMPLETE-ERROR</Status>
#     <BadUnits>
#         <Unit>
#             <FG>
#                 <SerialNo></SerialNo>
#                 <ErrorCode></ErrorCode>
#             </FG>
#             <CAM>
#                 <SerialNo>99991300288</SerialNo>
#                 <ErrorCode>UPDATE_DUPLICATE</ErrorCode>
#             </CAM>
#             <Subscription>
#                 <SubscriptionId></SubscriptionId>
#                 <ErrorCode></ErrorCode>
#             </Subscription>
#         </Unit>
#     </BadUnits>
# </EcoResponse>
#
# Note 3.3: Error xml for a duplicate FG SN and CAM SN when doing update
# <EcoResponse>
#     <JobId>97d88e79-bb5e-41b9-b319-09df9cdca873</JobId>
#     <Status>COMPLETE-ERROR</Status>
#     <BadUnits>
#         <Unit>
#             <FG>
#                 <SerialNo>99991300288</SerialNo>
#                 <ErrorCode>UPDATE_DUPLICATE</ErrorCode>
#             </FG>
#             <CAM>
#                 <SerialNo>99991300288</SerialNo>
#                 <ErrorCode>UPDATE_DUPLICATE</ErrorCode>
#             </CAM>
#             <Subscription>
#                 <SubscriptionId></SubscriptionId>
#                 <ErrorCode></ErrorCode>
#             </Subscription>
#         </Unit>
#     </BadUnits>
# </EcoResponse>
#
# *Note 4:* Error xml for an attempt to update a CAM spare part
# <EcoResponse>
#     <JobId>97d88e79-bb5e-41b9-b319-09df9cdca873</JobId>
#     <Status>COMPLETE-ERROR</Status>
#     <BadUnits>
#         <Unit>
#             <FG>
#                 <SerialNo></SerialNo>
#                 <ErrorCode></ErrorCode>
#             </FG>
#             <CAM>
#                 <SerialNo>99991300288</SerialNo>
#                 <ErrorCode>UPDATE_CAMSPAREPART</ErrorCode>
#             </CAM>
#             <Subscription>
#                 <SubscriptionId></SubscriptionId>
#                 <ErrorCode></ErrorCode>
#             </Subscription>
#         </Unit>
#     </BadUnits>
# </EcoResponse>
# {noformat}
#
# *Note 5:* Error xml for an attempt to update a unit and the CAM PCBA Serial Number does not exist
# {noformat}
# <EcoResponse>
#     <JobId>97d88e79-bb5e-41b9-b319-09df9cdca873</JobId>
#     <Status>COMPLETE-ERROR</Status>
#     <BadUnits>
#         <Unit>
#             <FG>
#                 <SerialNo></SerialNo>
#                 <ErrorCode></ErrorCode>
#             </FG>
#             <CAM>
#                 <SerialNo>99991300288</SerialNo>
#                 <ErrorCode>UPDATE_UNKNOWN</ErrorCode>
#             </CAM>
#             <Subscription>
#                 <SubscriptionId></SubscriptionId>
#                 <ErrorCode></ErrorCode>
#             </Subscription>
#         </Unit>
#     </BadUnits>
# </EcoResponse>
#
# Note 6: Error xml where the submitted xml corresponds to a CAM spare part, but a FG+CAM unit exists in ECO with a matching CAM PCBA Serial Number
# <EcoResponse>
#     <JobId>97d88e79-bb5e-41b9-b319-09df9cdca873</JobId>
#     <Status>COMPLETE-ERROR</Status>
#     <BadUnits>
#         <Unit>
#             <FG>
#                 <SerialNo></SerialNo>
#                 <ErrorCode></ErrorCode>
#             </FG>
#             <CAM>
#                 <SerialNo>99991300288</SerialNo>
#                 <ErrorCode>UPDATE_INVALID</ErrorCode>
#             </CAM>
#             <Subscription>
#                 <SubscriptionId></SubscriptionId>
#                 <ErrorCode></ErrorCode>
#             </Subscription>
#         </Unit>
#     </BadUnits>
# </EcoResponse>
#
# Note 7: Error xml where the submitted xml contains a subscription ID that already exists in the ECO database. For a FG+CAM unit, the first duplicate subscription ID and the FG and CAM serial numbers of the submitted unit are returned. For a CAM spare part, the first duplicate subscription ID and the CAM serial number are returned.
# <EcoResponse>
#     <JobId>97d88e79-bb5e-41b9-b319-09df9cdca873</JobId>
#     <Status>COMPLETE-ERROR</Status>
#     <BadUnits>
#         <Unit>
#             <FG>
#                 <SerialNo>99991300288</SerialNo>
#                 <ErrorCode></ErrorCode>
#             </FG>
#             <CAM>
#                 <SerialNo>99991300288</SerialNo>
#                 <ErrorCode></ErrorCode>
#             </CAM>
#             <Subscription>
#                 <SubscriptionId>00a7dbd5-4a61-4eaa-938a-5938f76f6811</SubscriptionId>
#                 <ErrorCode>UPDATE_DUPLICATE</ErrorCode>
#             </Subscription>
#         </Unit>
#     </BadUnits>
# </EcoResponse>

# ACCEPTANCE CRITERIA: (ECO-5491)
# Note 1: The intent of this story is to specify how error handling should work, between the Manufacturing IT interface and ECO. The protocol for exchanging data between Manufacturing IT and ECO is described in https://confluence.ec2.local/display/ECO/Job+transmission+from+Manufacturing+IT+to+ECO?focusedCommentId=27168529#comment-27168529
# 1. ECO shall provide a mechanism to poll the status of a job. Note: The statuses are listed on the attached confluence page
# 2. If ECO is queried about the status of a job it does not recognize, ECO shall indicate that it is an unrecognized job. Note: This corresponds to Scenario 6 on the attached confluence page.
# 3. When creating records of manufactured Newport devices in ECO (as per ECO-5389) if an individual record fails validation then the record shall be rejected. Note: This corresponds to Scenario 4 on the attached confluence page.
# 4. If the BuildStatus is NEW and if the supplied value of any of the following fields already exists in ECO then the record shall fail validation as per AC#3
# 4a. FgSerialNo
# 4b. CamSerialNo
# Note 2: This corresponds to Scenario 4 on the attached confluence page. The format for rejected records is specified in the XML file attached to the confluence page.
# 5. If rejection occurs as per AC#3 then
# 5a. it shall be reported as part of the status of the operation. Note: The statuses are listed on the attached confluence page.
# 5b. rejected records shall be discarded in their entirety. Note: This means that rejected records will not effect any changes to the database.
# Note 3: Example 1: If record 1 in the job is FG A, CAM A, and record 10 is FG A, CAM A, then ECO shall return that the unit (FG A, CAM A) was in error, and both the FG and CAM fields were duplicated. In this case, record 1 will be stored in the database, but record 10 will not make any change to the database.
# Example 2: If record 1 in the job is FG A, CAM A; and record 10 is FG A, CAM B, then ECO shall return that the unit (FG A, CAM B) was in error, with the FG field being duplicated. Once again, record 1 will be stored in the database, but record 10 will not make any change to the database.
# Note 4: The D379-513 document specifies which data items are required for a particular device type. In this story, we do not check to see that mandatory items are present for each type of device.

# ACCEPTANCE CRITERIA: (ECO-5803)
# Note 1: This story extends ECO-5389 by adding more fields to the manufacturing interface.
# 1. For each device loaded into ECO from manufacturing as per ECO-5389 AC#5 the following information shall also be loaded:
# 1a. FG PCBA Part Number (FgPcbaPartNo)
# 1b. FG PCBA Version Number (FgPcbaVersionNo)
# 1c. Region ID (RegionId)
# Note 2: Currently, we have a single field, FG PCBA Serial Number, which is intended to hold a concatenation of the FG PCBA Part Number, FG PCBA Version Number and FG PCBA Serial Number. The intent behind AC1a and AC1b is to split that field into three separate fields, which can be individually queried.
# Note 3: The intent behind AC1c is to provide a Region ID for each manufactured device.

# ACCEPTANCE CRITERIA: (ECO-5892)
# Note 1: The intent of this story is to specify how error handling should work, between the Manufacturing IT interface and ECO. The protocol for exchanging data between Manufacturing IT and ECO is described in https://confluence.ec2.local/display/ECO/Job+transmission+from+Manufacturing+IT+to+ECO?focusedCommentId=27168529#comment-27168529
# 1. When creating records of manufactured Newport devices in ECO (as per ECO-5389), if the submitted job fails schema validation,
# 1a. the entire job shall be rejected.
# 1b. this shall be returned in the status of the operation. Note: This corresponds to Scenario 1 on the attached confluence page. When the entire job is rejected, every record within the job is considered to be rejected.
# 2. If the job is not rejected as per AC1a above, a job ID shall be returned for the submitted job. Note: This corresponds to Scenario 2 on the attached confluence page.

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
#     <Unit>
#       <FG>
#         <SerialNo>20130000001</SerialNo>
#         <ErrorCode></ErrorCode>
#     </FG>
#       <CAM>
#         <SerialNo>20130000001</SerialNo>
#         <ErrorCode></ErrorCode>
#       </CAM>
#     <Subscription>
#       <SubscriptionId>8dc0d080-b0c0-11e3-a5e2-0800200c9a66</SubscriptionId>
#       <ErrorCode>DUPLICATE</ErrorCode>
#     </Subscription>
#     </Unit>
#   </BadUnits>
#
# Example 2: This example shows a unit where a duplicate subscription ID has been detected, but which also has a duplicate FG and CAM Serial Number. Note that the Subscription section contains no information.
#
# <BadUnits>
#     <Unit>
#       <FG>
#         <SerialNo>20130000001</SerialNo>
#         <ErrorCode>DUPLICATE</ErrorCode>
#       </FG>
#       <CAM>
#         <SerialNo>20130000001</SerialNo>
#         <ErrorCode>DUPLICATE</ErrorCode>
#       </CAM>
#     <Subscription>
#       <SubscriptionId></SubscriptionId>
#       <ErrorCode></ErrorCode>
#     </Subscription>
#     </Unit>
#   </BadUnits>
#
# *Note 7:* This story excludes the UPDATE workflow

# ACCEPTANCE CRITERIA: (ECO-6119)
# 1. For all devices loaded via the manufacturing interface, subscriptions shall be optional.
# Note 1: The intent is that CAM as spare parts do not come loaded with subscriptions. Hence, subscriptions shall be optional on these devices, and it shall be possible to create a CAM as a spare part without subscriptions. Similarly, in the future it is possible that devices are manufactured without having any subscriptions loaded on them.

# ACCEPTANCE CRITERIA: (ECO-6007)
# Note 1: The intent of this story is the following. The error handling introduced by ECO-5491 expects that a manufactured unit should have both the FG and CAM details. If a manufactured unit does not have both FG and CAM details, it will be rejected by the error handling. This has the effect of blocking CAM as spare parts (which do not have FG information). This story allows CAM as a spare part to be loaded.
# 1. When loading a record of manufactured devices into ECO (as per ECO-5389), it shall be possible to load a device which has CAM information but no FlowGen information Note: This corresponds to a CAM spare part.
# Note 2: This story extends ECO-5491 by allowing the devices of the types mentioned above, to be loaded into ECO
# Note 3: It is expected that the duplicate handling will be the same as that introduced in ECO-5491. Namely, the Flow Gen section of the error will not contain a serial number or error code, while the CAM section will contain the serial number and the error code DUPLICATE

# ACCEPTANCE CRITERIA: (ECO-6090)
# 1. Manufacturing IT shall have the facility to scrap a Newport device by providing the following information,
# 1a. BuildStatus SCRAP Note: xml provided in Note 2
# 1b. The Flow Gen Serial Number
# 1c. The Flow Gen device number
# Note 1: This extends the manufacturing interface as specified in ECO-5389 to also allow for the SCRAP status. The SCRAP records may be interspersed with NEW and UPDATE records
# 2. If the supplied device number does not match the device number stored in ECO, the scrap operation shall not occur and an error shall be returned indicating invalid device number.
# 3. If the unit to be scrapped cannot be found in ECO, the scrap operation shall not occur and an error shall be returned indicating the device is not found.
# 4. On successful scrap,
# 4a. the Flow Gen shall be marked as being scrapped in ECO.
# 4b. the associated CAM shall be marked as being scrapped in ECO Note: scrapping the CAM with the Telco is covered by ECO-7299 and ECO-7300
# Note 2: xml submitted by manufacturing IT for scrapping a device
# <UnitDetail>
#     <Build>
#       <Status>SCRAP</Status>
#       <DateTime>2014-01-22T14:48:55Z</DateTime>
#     </Build>
#     <FG>
#       <SerialNo>10000000001</SerialNo>
#       <DeviceNo>121</DeviceNo>
#     </FG>
#     <CAM>
#     </CAM>
#     <Hum>
#     </Hum>
#   </UnitDetail>
# Note 3: Error xml for an incorrect device number
# <EcoResponse>
#     <JobId>97d88e79-bb5e-41b9-b319-09df9cdca873</JobId>
#     <Status>COMPLETE-ERROR</Status>
#     <BadUnits>
#         <Unit>
#             <FG>
#                 <SerialNo>99991300288</SerialNo>
#                 <ErrorCode>SCRAP_INCORRECT_DEVICENUMBER</ErrorCode>
#             </FG>
#             <CAM>
#                 <SerialNo></SerialNo>
#                 <ErrorCode></ErrorCode>
#             </CAM>
#             <Subscription>
#                 <SubscriptionId></SubscriptionId>
#                 <ErrorCode></ErrorCode>
#             </Subscription>
#         </Unit>
#     </BadUnits>
# </EcoResponse>
# Note 4: Error xml for device not found
# <EcoResponse>
#     <JobId>97d88e79-bb5e-41b9-b319-09df9cdca873</JobId>
#     <Status>COMPLETE-ERROR</Status>
#     <BadUnits>
#         <Unit>
#             <FG>
#                 <SerialNo>99991300288</SerialNo>
#                 <ErrorCode>SCRAP_UNKNOWN</ErrorCode>
#             </FG>
#             <CAM>
#                 <SerialNo></SerialNo>
#                 <ErrorCode></ErrorCode>
#             </CAM>
#             <Subscription>
#                 <SubscriptionId></SubscriptionId>
#                 <ErrorCode></ErrorCode>
#             </Subscription>
#         </Unit>
#     </BadUnits>
# </EcoResponse>

# ACCEPTANCE CRITERIA: (ECO-6097)
# When posting device information to the Manufacturing Interface, two anomalies are noticed:
# 1. The status of the job continues to be displayed as 'PROCESSING'
# 2. Only some of the posted devices appear in the NGCS database.
# A check of the ECX2 logs reveals that if a device information is longer than 4096 characters, ECX2 throws an exception. It is possible that both the above anomalies arise from this issue.

# Acceptance Criteria (ECO-9651)
# Note 1: Cambridge is also known as the external CAM. The objective document D379-513 Manufacturing IT to AirView Interface
# has been updated to allow Cambridge external CAMs.
#         1. Manufacturing IT shall be able to create a record of manufactured external CAM devices in AirView.
#         2. The information stored for each external CAM shall be as specified in D379-513. Note that this document includes
#            descriptive information, an xml schema and an xml example.
# Note 2: The example xml for a Cambridge extracted from D379-513 is as follows: (See https://jira.ec2.local/browse/ECO-9651)

# Acceptance Criteria (ECO-10512)
# *Note 1: The objective document D2225-040 Manufacturing IT to AirView Interface has been updated to allow Stellar and Astral devices.
# 1. Manufacturing IT shall be able to create a record of manufactured Stellar and Astral devices in AirView.
# 2. The information stored for each Stellar and Astral shall be as specified in D2225-040. Note that this document includes descriptive information, an xml schema and an xml example.

#  ACCEPTANCE CRITERIA: (ECO-10589)
#  Note 1: The Objective document D2225-040 Manufacturing IT to AirView Interface Specification (A3629015) and it's associated records have been updated to define the fields required for Monaco devices.
#
#  [OBSOLETE] 1. Manufacturing IT shall be able to create a record of manufactured Monaco devices in AirView.
#  [OBSOLETE] 2. The information stored for each Monaco device shall be as specified in D2225-040. Note that this document includes descriptive information, an xml schema and an xml example. New items to support Monaco are as follows:
#  [OBSOLETE] 2a. Security Data
#  [OBSOLETE] 2b. Security Data Hash
#  [OBSOLETE] 2c. Settings Profiles
#  [OBSOLETE] 2d. Security Code
#  [OBSOLETE] 2e. Bluetooth MAC Address
#  [OBSOLETE] 2f. Bluetooth Software Version
#  [OBSOLETE] 3. The record shall be rejected and logged if the Security Data is not validated by the Security Data Hash.
#
#  Note 2: An example xml is as follows:
#  <?xml version="1.0"?>
#  <UnitDetail>
#  <Build>
#  <Status>NEW</Status>
#  <DateTime>2015-11-02T14:49:06Z</DateTime>
#  </Build>
#  <FG>
#  <SerialNo>10000000004</SerialNo>
#  <Software>SX567-0100</Software>
#  <MID>46</MID>
#  <VID>99</VID>
#  <RegionId>1</RegionId>
#  <PCBASerialNo>(90)R370-7224(91)P3(21)41030011</PCBASerialNo>
#  <ProductCode>37001</ProductCode>
#  <Configuration>CX036-001-001-001-100-100-100</Configuration>
#  <Name>Monaco1</Name>
#  <DeviceNo>124</DeviceNo>
#  <SecurityCode>glyph</SecurityCode>
#  <SecurityData>W/ls/O+ZQ1eQ5+5PWi54KdwFOuEuzqWNYseQkgj8eRkcJImFpyRoudtzmik1IlBlidxNNFaIVrFfMRzjJBPBBXMxllQEBUoHZ0NgRr7dHPQqyH+lOZQhPm4D2rhG9nJKfjDq80sq4tNHCe9u3Hh7c6vROiYUfTgVUE+4L437AJFdBtt/9bJzWBhQ2XvtrxNOlXohdkhlDCx3P9XrK+mSkM/TSXqpht5l3GuoXHSrpzcRNGwnD9A0VktmansIsI4kRfaeYtfqM7utp8EmnuNgCrdX5kNPAX0byi89/mS36kQL48coVX++MFP1bse34RmIXxBMGIXznFbwXCbwFquxuha6jdPXmsZs1odBc4kqYQjgqaheR9GIv9sLDwU3Sv4aVO7XQsXzoA4hTr89tY/wb/rk36Bxk7Iw7UMq+h68q7IzkhvcPA9/aSg5HnnA5HvZujYcYpli4w4a4hEGcYGMuhtGlrQPGAHrh8ChJnlCIGYhrlF8MvOIOcY7DHAugJ8ZU7u2MgAjn42TI6UbED8pAjpjpzbjwCTaAX10ROtr8niDjc51lYcECRR6/w6MPnysPLqFjLT+OtHKso7SN2ZV/TTjgegSGVkKMUG88Ml9ObQT15DlckDkAEo/Cu1CdQE7LLKt3K/oYLSVd0b5AcQzF5WOglJZURannJrcb83PS9Q=</SecurityData>
#  <SecurityDataHash>08c9a00e97f20f808e0960ddc1b6275e36ad949b857882547e4b35ed224709c7</SecurityDataHash>
#  <Boot>SX577-0100</Boot>
#  <Features>
#  <NightProfileCard>false</NightProfileCard>
#  <NightProfileWireless>false</NightProfileWireless>
#  </Features>
#  <SettingsProfiles>
#  <SettingsProfile>SettingsCPAP</SettingsProfile>
#  <SettingsProfile>SettingsEPR</SettingsProfile>
#  <SettingsProfile>SettingsAutoRamp</SettingsProfile>
#  <SettingsProfile>SettingsSmartStartStop</SettingsProfile>
#  <SettingsProfile>SettingsBluetooth</SettingsProfile>
#  </SettingsProfiles>
#  </FG>
#  <Bluetooth>
#  <MacAddress>aa:aa:aa:aa:aa:aa</MacAddress>
#  <SoftwareVersion>BTSWID123-4328</SoftwareVersion>
#  </Bluetooth>
#  </UnitDetail>

# ACCEPTANCE CRITERIA: (ECO-12819)
# 1. For manufacture records with a status of NEW, NGCS shall store the Cellular Module status as PROVISIONED.
# Note 1. For manufacture records with a status of UPDATE, NGCS shall not modify the status of the cellular modem.
# Note 2. For manufacture records with a status of SCRAP, NGCS will change the cellular modem to SCRAP per ECO-7299.
# 2. When a valid registration is seen the Cellular Module state will be changed to ACTIVE. 2.a Activation of an Aeris device shall be recorded, including FG serial number, CAM serial number, date, time and Aeris response code.

# ACCEPTANE CRITERIA: (ECO-15318)
# Note 1: Overview of Type 2 message signing can be found at https://confluence.ec2.local/display/NGCS/Protocol+%3A+Sequence+%3A+Newport+%3A+Authentication+%3A+Type+2
# Note 2: Message signing specification can be found at https://confluence.ec2.local/display/NGCS/00+05+Authentication
# Note 3: A precursor to message signing is that both the Cellular Module and Machine Portal compute a Version 3 Universally Unique Identifier (GUID) from information known to both parties and used in all communications. ECO-14753 established the calculation and storage of the Cellular Module GUID for manufactured units. This card concerns update by manufacturing to units before they have been shipped.
# 1. When a valid Update Newport UnitDetail is given containing a cellular module, a cellular module GUID shall be calculated from the updated cellular module details, associated with the updated cellular module, and persisted with the updated cellular module.
# Note 4: This is through the version 1 manufacturing interface
# Note 5: With ECO-14753, the calculated GUID is used as the primary key which cannot be changed. Therefore, if the calculated GUID using the unit update detail is different than the primary key value, then the existing unit will have to be deleted from the database before insertion of the "updated" unit. This is because there is a unique constraint on the PCBA Serial Number column that will prevent insertion of the "updated" unit without removal of the previous unit first.

# ACCEPTANE CRITERIA: (ECO-16986)
# Note 1: The Objective document D2225-040 Manufacturing IT to AirView Interface Specification (A3629015) and it's associated records have been updated to define the fields required for Balboa enhanced (Newport and Geneva) devices.
# 1. The information stored for each Balboa enhanced device shall be as specified in D2225-040. Note that this document includes descriptive information, an xml schema and an xml example. New items to support Balboa are as follows:
# 1a. Cellular Module Security Data
# 1b. Cellular Module Security Data Hash
# 2. The record shall be rejected and logged if the Security Data is not validated by the Security Data Hash.
# Note 2: An example xml is as follows:
#     <!-- Scenario: New Flow Generator with Balboa CAM (GSM) and Humidifier -->
#     <ns0:UnitDetail>
#         <ns0:Build>
#             <ns0:Status>NEW</ns0:Status>
#             <ns0:DateTime>2017-07-31T14:50:56Z</ns0:DateTime>
#         </ns0:Build>
#         <ns0:FG>
# ...
#         </ns0:FG>
#         <ns0:CAM>
# ...<ns0:SecurityData>5kjCeHzoBaZ6cI6DLr9NVxX7x/3t3O8TCki5XzsuIpp5oCOCBPm+zgVMs9iNhleP7GU/9LDImnu/1EvWBRzwc28vWydAukVChhBp/Wsd+lpQd5BbWd2fhifnB9Ow0RoCyLCtMrQ5oa7WPSXGYWszXZH17lTd2MEkZ5QYs87koSY=</ns0:SecurityData>
#             <ns0:SecurityDataHash>e24ff80ea7cc44c8cff3d401dbb0ec1f824ef092f1a112c1bbc313a18077a826</ns0:SecurityDataHash>
# ...
#         </ns0:CAM>
#         <ns0:Hum>
# ...
#         </ns0:Hum>
#     </ns0:UnitDetail>

  @device.single.load.S1
  @ECO-5389.1  @ECO-5389.3  @ECO-5389.4
  @ECO-5389.5a @ECO-5389.5b @ECO-5389.5c @ECO-5389.5d
  @ECO-5389.5i
  @ECO-5390.1  @ECO-5390.1a @ECO-5390.1b @ECO-5390.1c
  @ECO-5390.1d @ECO-5390.1e @ECO-5390.1f @ECO-5390.1g
  @ECO-5390.1h @ECO-5390.1i @ECO-5390.1j @ECO-5390.1k
  @ECO-5390.1l
  @ECO-5391.1  @ECO-5391.1a @ECO-5391.1b @ECO-5391.1c
  @ECO-5391.1d @ECO-5391.1e @ECO-5391.1f @ECO-5391.1g
  @ECO-5391.1h @ECO-5391.1i @ECO-5391.1j @ECO-5391.1k
  @ECO-5391.1l @ECO-5391.1m @ECO-5391.1n @ECO-5391.1o
  @ECO-5391.1p @ECO-5391.1q @ECO-5391.1r @ECO-5391.1s
  @ECO-5391.1t
  @ECO-5491.1 @ECO-5491.4
  @ECO-5803.1 @ECO-5803.1a @ECO-5803.1b @ECO-5803.1c
  @ECO-5875.1
  @ECO-5892.2
  @ECO-5930.1
  @ECO-6097.1 @ECO-6097.2
  @ECO-12819.1
   Scenario: Verify manufacture device upload service process and stores flowgen data correctly in server database also related flowgen subscriptions.
      Given the server receives the following manufacturing unit detail
         | resource                                                        |
         | /data/manufacturing/unit_detail_000_20000000005_new.xml         |
         | /data/manufacturing/unit_detail_000_20000000007_new.xml         |
         | /data/manufacturing/unit_detail_001_10000000001_new.xml         |
         | /data/manufacturing/unit_detail_001_10000000002_new.xml         |
         | /data/manufacturing/unit_detail_001_10000000003_new_camless.xml |
         | /data/manufacturing/unit_detail_001_10000000004_new_camless.xml |
         | /data/manufacturing/unit_detail_001_10000000005_new.xml         |
         | /data/manufacturing/unit_detail_001_10000000006_new.xml         |
         | /data/manufacturing/unit_detail_001_10000000007_new.xml         |
      And the server should not produce device manufactured error
      Then the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | hasCellularModule | managedByThisSystem         | status | software   |
         | 20000000005 | 121          | 36  | 25  | 37001       | true                      | true                | NEW    | SX567-0100 |
         | 20000000007 | 121          | 36  | 25  | 37001       | true                      | true                | NEW    | SX567-0100 |
         | 10000000001 | 121          | 36  | 25  | 37001       | true                      | true                | NEW    | SX567-0100 |
         | 10000000002 | 121          | 36  | 25  | 37001       | true                      | true                | NEW    | SX567-0100 |
         | 10000000003 | 121          | 36  | 33  | 37001       | false                     | true                | NEW    | SX567-0100 |
         | 10000000004 | 121          | 36  | 33  | 37001       | false                     | true                | NEW    | SX567-0100 |
         | 10000000005 | 121          | 36  | 25  | 37001       | true                      | true                | NEW    | SX567-0100 |
         | 10000000006 | 121          | 36  | 25  | 37001       | true                      | true                | NEW    | SX567-0100 |
         | 10000000007 | 121          | 36  | 25  | 37001       | true                      | true                | NEW    | SX567-0100 |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
         | 20000000006 | 23152G00005  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
         | 20000000007 | 23152G00007  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
         | 10000000001 | 13152G00011  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
         | 10000000002 | 13152G00012  | SILENT             | SILENT             | VODAFONE             | SX558-0100 | PROVISIONED |
         | 10000000005 | 13152G00015  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
         | 10000000006 | 13152G00016  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
         | 10000000007 | 13152G00017  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
         | B884F699-84ED-446E-10000000001 | {  "FG.SerialNo": "10000000001",  "SubscriptionId": "B884F699-84ED-446E-10000000001",  "ServicePoint": "/api/v1/therapy/settings",  "Trigger": {    "Collect": [ "HALO" ],    "OnlyOnChange": true,    "Conditional": {      "Setting": "Val.Mode",      "Value": "AutoSet"    }  },  "Data": [    "Val.Mode",    "AutoSet.Val.Press",    "AutoSet.Val.StartPress",    "AutoSet.Val.EPR.EPREnable",    "AutoSet.Val.EPR.EPRType",    "AutoSet.Val.EPR.Level",    "AutoSet.Val.Ramp.RampEnable",    "AutoSet.Val.Ramp.RampTime"  ]} |
         | D93FD8C4-EF82-43C2-10000000001 | {  "FG.SerialNo": "10000000001",  "SubscriptionId": "D93FD8C4-EF82-43C2-10000000001",  "ServicePoint": "/api/v1/therapy/summaries",  "Trigger": {    "Collect": [ "HALO" ],    "Conditional": {      "Setting": "Val.Duration",      "Value": 0    }  },  "Data": [    "Val.Duration"  ]}                                                                                                                                                                                                                                          |
         | C884F699-84ED-446E-10000000002 | {  "FG.SerialNo": "10000000002",  "SubscriptionId": "C884F699-84ED-446E-10000000002",  "ServicePoint": "/api/v1/therapy/settings",  "Trigger": {    "Collect": [ "HALO" ],    "OnlyOnChange": true,    "Conditional": {      "Setting": "Val.Mode",      "Value": "AutoSet"    }  },  "Data": [    "Val.Mode",    "AutoSet.Val.Press",    "AutoSet.Val.StartPress",    "AutoSet.Val.EPR.EPREnable",    "AutoSet.Val.EPR.EPRType",    "AutoSet.Val.EPR.Level",    "AutoSet.Val.Ramp.RampEnable",    "AutoSet.Val.Ramp.RampTime"  ]} |
         | E93FD8C4-EF82-43C2-10000000002 | {  "FG.SerialNo": "10000000002",  "SubscriptionId": "E93FD8C4-EF82-43C2-10000000002",  "ServicePoint": "/api/v1/therapy/summaries",  "Trigger": {    "Collect": [ "HALO" ],    "Conditional": {      "Setting": "Val.Duration",      "Value": 0    }  },  "Data": [    "Val.Duration"  ]}                                                                                                                                                                                                                                          |
         | E13FD8C4-EF82-43C2-10000000005 | {  "FG.SerialNo": "10000000005",  "SubscriptionId": "E13FD8C4-EF82-43C2-10000000005",  "ServicePoint": "/api/v1/therapy/summaries",  "Trigger": {    "Collect": [ "HALO" ],    "Conditional": {      "Setting": "Val.Duration",      "Value": 0    }  },  "Data": [    "Val.Duration"  ]}                                                                                                                                                                                                                                          |
         | E13FD8C4-EF82-43C2-20000000005 | {  "FG.SerialNo": "20000000005",  "SubscriptionId": "E13FD8C4-EF82-43C2-20000000005",  "ServicePoint": "/api/v1/therapy/summaries",  "Trigger": {    "Collect": [ "HALO" ],    "Conditional": {      "Setting": "Val.Duration",      "Value": 0    }  },  "Data": [    "Val.Duration"  ]}                                                                                                                                                                                                                                          |
         | E23FD8C4-EF82-43C2-10000000006 | {  "FG.SerialNo": "10000000006",  "SubscriptionId": "E23FD8C4-EF82-43C2-10000000006",  "ServicePoint": "/api/v1/therapy/summaries",  "Trigger": {    "Collect": [ "HALO" ],    "Conditional": {      "Setting": "Val.Duration",      "Value": 0    }  },  "Data": [    "Val.Duration"  ]}                                                                                                                                                                                                                                          |
         | E33FD8C4-EF82-43C2-10000000007 | {  "FG.SerialNo": "10000000007",  "SubscriptionId": "E33FD8C4-EF82-43C2-10000000007",  "ServicePoint": "/api/v1/therapy/summaries",  "Trigger": {    "Collect": [ "HALO" ],    "Conditional": {      "Setting": "Val.Duration",      "Value": 0    }  },  "Data": [    "Val.Duration"  ]}                                                                                                                                                                                                                                          |
         | E23FD8C4-EF82-43C2-20000000007 | {  "FG.SerialNo": "20000000007",  "SubscriptionId": "E23FD8C4-EF82-43C2-20000000007",  "ServicePoint": "/api/v1/therapy/summaries",  "Trigger": {    "Collect": [ "HALO" ],    "Conditional": {      "Setting": "Val.Duration",      "Value": 0    }  },  "Data": [    "Val.Duration"  ]}                                                                                                                                                                                                                                          |

  @device.single.load.S2
  @ECO-5389.1  @ECO-5389.3 @ECO-5389.4
  @ECO-5389.5a @ECO-5389.5b @ECO-5389.5c @ECO-5389.5d
  @ECO-5892.2
  @ECO-5491.1 @ECO-5491.4 @ECO-5491.5
  @ECO-6008.1 @ECO-6008.1a @ECO-6008.1b @ECO-6008.1c
  @ECO-6007.1
   Scenario: Return job status COMPLETE-ERROR from manufacture device upload service, devices with serial_no 2000000000* are duplicate entries.
      Given the server receives the following manufacturing unit detail
         | resource                                                |
         | /data/manufacturing/unit_detail_000_20000000005_new.xml |
         | /data/manufacturing/unit_detail_000_20000000007_new.xml |
      Then the server should not produce device manufactured error
      When the server receives the following manufacturing unit detail
         | resource                                                |
         | /data/manufacturing/unit_detail_001_20000000005_new.xml |
         | /data/manufacturing/unit_detail_001_20000000006_new.xml |
         | /data/manufacturing/unit_detail_001_20000000007_new.xml |
         | /data/manufacturing/unit_detail_005_30000000005_new.xml |
         | /data/manufacturing/unit_detail_005_30000000007_new.xml |
         | /data/manufacturing/unit_detail_008_20000000006_new.xml |
         | /data/manufacturing/unit_detail_009_20000000009_new.xml |
      Then the server produces the following device manufactured error
         | PersistVetoPoint | PersistFailureType                              | PersistFailureReason                                               | XmlFile                                                 |
         | DUPLICATE        | DUPLICATE_FLOW_GENERATOR                        | Duplicate Flow Generator was detected                              | /data/manufacturing/unit_detail_001_20000000005_new.xml |
         | DUPLICATE        | DUPLICATE_CELLULAR_MODULE                       | Duplicate Cellular Module was detected                             | /data/manufacturing/unit_detail_001_20000000006_new.xml |
         | DUPLICATE        | DUPLICATE_FLOW_GENERATOR                        | Duplicate Flow Generator was detected                              | /data/manufacturing/unit_detail_001_20000000007_new.xml |
         | DUPLICATE        | DUPLICATE_SUBSCRIPTION                          | Duplicate Subscription was detected                                | /data/manufacturing/unit_detail_005_30000000005_new.xml |
         | DUPLICATE        | DUPLICATE_SUBSCRIPTION                          | Duplicate Subscription was detected                                | /data/manufacturing/unit_detail_005_30000000007_new.xml |
         | DUPLICATE        | DUPLICATE_CELLULAR_MODULE                       | Duplicate Cellular Module was detected                             | /data/manufacturing/unit_detail_008_20000000006_new.xml |
         | DUPLICATE        | DUPLICATE_CELLULAR_MODULE_BY_PCBA_SERIAL_NUMBER | Duplicate Cellular Module was detected based on pcba serial number | /data/manufacturing/unit_detail_009_20000000009_new.xml |

  @device.single.load.S3
  @ECO-6119.1
  @ECO-12819.1
   Scenario: Load FG & module without subscriptions.
      Given the server receives the following manufacturing unit detail
         | resource                                                |
         | /data/manufacturing/unit_detail_006_10000000001_new.xml |
      Then the server should not produce device manufactured error
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | hasCellularModule | managedByThisSystem | status | software   |
         | 10000000001 | 121          | 36  | 25  | 37001       | true                      | true                | NEW    | SX567-0100 |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
         | 10000000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
      And I verify that NGCS does not store any subscriptions for communication module with serial number "10000000001"

  @device.single.load.S4
  @ECO-6007.1
  @ECO-12819.1
   Scenario: Load communication module without a flowgen.
      Given the server receives the following manufacturing unit detail
         | resource                                                |
         | /data/manufacturing/unit_detail_007_10000000001_new.xml |
      Then the server should not produce device manufactured error
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
         | 10000000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
      And I verify the cellular module with serial number 10000000001 does not have a flow generator

  @device.single.load.S5
  @ECO-5390.1  @ECO-5390.1a @ECO-5390.1b @ECO-5390.1c
  @ECO-5390.1d @ECO-5390.1e @ECO-5390.1f @ECO-5390.1g
  @ECO-5390.1h @ECO-5390.1i @ECO-5390.1j @ECO-5390.1k
  @ECO-5390.1l
  @ECO-5391.1  @ECO-5391.1a @ECO-5391.1b @ECO-5391.1c
  @ECO-5391.1d @ECO-5391.1e @ECO-5391.1f @ECO-5391.1g
  @ECO-5391.1h @ECO-5391.1i @ECO-5391.1j @ECO-5391.1k
  @ECO-5391.1l @ECO-5391.1m @ECO-5391.1n @ECO-5391.1o
  @ECO-5391.1p @ECO-5391.1q @ECO-5391.1r @ECO-5391.1s
  @ECO-5391.1t
  @ECO-5803.1 @ECO-5803.1a @ECO-5803.1b @ECO-5803.1c
  @ECO-5930.1
  @ECO-16986.2
   Scenario: Manufacturing task request with invalid schema should fail xsd validation.
      Given the server receives the following manufacturing unit detail
         | resource                                                              |
         | /data/manufacturing/unit_detail_new_fg1555_cam1555.xml                |
         | /data/manufacturing/unit_detail_new_fg2000_cam2000_invalid_schema.xml |
         | /data/manufacturing/unit_detail_new_fg2000_cam2000_invalid_hash.xml   |
      Then the server produces the following device manufactured error
         | ValidationVetoPoint | ValidationFailureType      | ValidationFailureReason                                   | XmlFile                                                               |
         | SCHEMA              | INVALID_DOCUMENT           | Unit Detail does not validate against schema              | /data/manufacturing/unit_detail_new_fg1555_cam1555.xml                |
         | EXCEPTION           | EXCEPTION_THROWABLE        | Exception occurred check exception message and stacktrace | /data/manufacturing/unit_detail_new_fg2000_cam2000_invalid_schema.xml |
         | HASH                | SECURITY_DATA_HASH         | Security data hash validation failure                     | /data/manufacturing/unit_detail_new_fg2000_cam2000_invalid_hash.xml   |

  @device.single.load.S6
  @ECO-5394.1 @ECO-5394.2 @ECO-5394.3 @ECO-5394.3a @ECO-5394.3b
   Scenario: Update a cam that the xml serial numbers match the existing flowgen and the existing CAM
      Given the server receives the following manufacturing unit detail
         | resource                                                                 |
         | /data/manufacturing/unit_detail_new_cam10900000001_fg10900000001_bdg.xml |
         | /data/manufacturing/unit_detail_new_cam10900000002_fg10900000002_bdg.xml |
      Then the server should not produce device manufactured error
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule  | managedByThisSystem | status | uid                                 |
         | 10900000001 | 121          | 36  | 25  | 37001       | SX567-0100 | true               | true                | NEW    | d5682a7c-4ca8-4c60-85fc-2d7717667ff7|
         | 10900000002 | 122          | 36  | 25  | 37001       | SX567-0100 | true               | true                | NEW    | 38d2dd56-0986-4a75-9900-eb4600aea47c|
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      | uid                                 |
         | 10900000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED | 76994273-e01e-4d23-9d3e-2140bcf10d79|
         | 10900000002 | 13152G00003  | SILENT             | SILENT             | VODAFONE             | SX558-0100 | PROVISIONED | 02178da6-a88b-4863-8ae2-3c73ac35b438|
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                             |
         | D93FD8C4-EF82-43C2-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"D93FD8C4-EF82-43C2-10900000001","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | B884F699-84ED-446E-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"B884F699-84ED-446E-10900000001","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |
         | E93FD8C4-EF82-43C2-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"E93FD8C4-EF82-43C2-10900000002","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | C884F699-84ED-446E-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"C884F699-84ED-446E-10900000002","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |
      When the server receives the following manufacturing unit detail
         | resource                                                                    |
         | /data/manufacturing/unit_detail_update_cam10900000001_fg10900000001_bdg.xml |
         | /data/manufacturing/unit_detail_update_cam10900000002_fg10900000002_bdg.xml |
      Then the server should not produce device manufactured error
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule          | managedByThisSystem | status |
         | 10900000001 | 121          | 36  | 25  | 37001       | SX567-0111 | true                       | true                | NEW    |
         | 10900000002 | 122          | 36  | 25  | 37001       | SX567-0111 | true                       | true                | NEW    |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
         | 10900000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                | SX558-0112 | PROVISIONED |
         | 10900000002 | 13152G00003  | SILENT             | SILENT             | VODAFONE             | SX558-0112 | PROVISIONED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                 |
         | D93FD8C4-EF82-53C2-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"D93FD8C4-EF82-53C2-10900000001","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                             |
         | B884F699-84ED-546E-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"B884F699-84ED-546E-10900000001","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable"]} |
         | E93FD8C4-EF82-53C2-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"E93FD8C4-EF82-53C2-10900000002","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                             |
         | C884F699-84ED-546E-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"C884F699-84ED-546E-10900000002","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable"]} |

  @device.single.load.S7
  @ECO-5394.1 @ECO-5394.2 @ECO-5394.4 @ECO-5394.4b @ECO-5394.4c @ECO-5394.4d @ECO-5394.4e @ECO-5394.4f
   Scenario: Update a cam that does not match an existing flowgen with matching cam
      Given the server receives the following manufacturing unit detail
         | resource                                                                 |
         | /data/manufacturing/unit_detail_new_cam10900000001_fg10900000001_bdg.xml |
         | /data/manufacturing/unit_detail_new_cam10900000002_fg10900000002_bdg.xml |
      Then the server should not produce device manufactured error
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule          | managedByThisSystem | status |
         | 10900000001 | 121          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
         | 10900000002 | 122          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
         | 10900000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
         | 10900000002 | 13152G00003  | SILENT             | SILENT             | VODAFONE             | SX558-0100 | PROVISIONED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                             |
         | D93FD8C4-EF82-43C2-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"D93FD8C4-EF82-43C2-10900000001","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | B884F699-84ED-446E-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"B884F699-84ED-446E-10900000001","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |
         | E93FD8C4-EF82-43C2-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"E93FD8C4-EF82-43C2-10900000002","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | C884F699-84ED-446E-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"C884F699-84ED-446E-10900000002","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |
      When the server receives the following manufacturing unit detail
         | resource                                                                    |
         | /data/manufacturing/unit_detail_update_cam10900000001_fg10910000001_bdg.xml |
         | /data/manufacturing/unit_detail_update_cam10900000002_fg10910000002_bdg.xml |
      Then the server should not produce device manufactured error
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule          | managedByThisSystem | status |
         | 10910000001 | 121          | 36  | 25  | 37001       | SX567-0111 | true                       | true                | NEW    |
         | 10910000002 | 122          | 36  | 25  | 37001       | SX567-0111 | true                       | true                | NEW    |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
         | 10900000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                | SX558-0112 | PROVISIONED |
         | 10900000002 | 13152G00003  | ACTIVE             | ACTIVE             | AERIS                | SX558-0112 | PROVISIONED |
      And NGCS has the following subscriptions
         | subscriptionId                       | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                   |
         | D93FD8C4-EF82-43C2-A7DA-0E6A841100F1 | {"FG.SerialNo":"10910000001","SubscriptionId":"D93FD8C4-EF82-43C2-A7DA-0E6A841100F1","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                               |
         | B884F699-84ED-446E-997A-8B15B09B6979 | {"FG.SerialNo":"10910000001","SubscriptionId":"B884F699-84ED-446E-997A-8B15B09B6979","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level"]} |
         | D93FD8C4-EF82-43C2-AAAA-0E6A841100F1 | {"FG.SerialNo":"10910000002","SubscriptionId":"D93FD8C4-EF82-43C2-AAAA-0E6A841100F1","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                               |
         | B884F699-84ED-446E-AAAA-8B15B09B6979 | {"FG.SerialNo":"10910000002","SubscriptionId":"B884F699-84ED-446E-AAAA-8B15B09B6979","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level"]} |

  @device.single.load.S8
  @ECO-5394.1 @ECO-5394.2 @ECO-5394.4 @ECO-5394.4b @ECO-5394.4c @ECO-5394.4d @ECO-5394.4e @ECO-5394.4f
   Scenario: Update a cam that does match an existing flowgen but not the existing CAM
      Given the server receives the following manufacturing unit detail
         | resource                                                                 |
         | /data/manufacturing/unit_detail_new_cam10900000001_fg10900000001_bdg.xml |
         | /data/manufacturing/unit_detail_new_cam10900000002_fg10900000002_bdg.xml |
      Then the server should not produce device manufactured error
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule          | managedByThisSystem | status |
         | 10900000001 | 121          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
         | 10900000002 | 122          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
         | 10900000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
         | 10900000002 | 13152G00003  | SILENT             | SILENT             | VODAFONE             | SX558-0100 | PROVISIONED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                             |
         | D93FD8C4-EF82-43C2-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"D93FD8C4-EF82-43C2-10900000001","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | B884F699-84ED-446E-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"B884F699-84ED-446E-10900000001","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |
         | E93FD8C4-EF82-43C2-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"E93FD8C4-EF82-43C2-10900000002","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | C884F699-84ED-446E-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"C884F699-84ED-446E-10900000002","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |
      When the server receives the following manufacturing unit detail
         | resource                                                                    |
         | /data/manufacturing/unit_detail_update_cam10910000001_fg10900000001_bdg.xml |
         | /data/manufacturing/unit_detail_update_cam10910000002_fg10900000002_bdg.xml |
      Then the server should not produce device manufactured error
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule  | managedByThisSystem | status |
         | 10900000001 | 121          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
         | 10900000002 | 122          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
         | 10910000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                | SX558-0112 | PROVISIONED |
         | 10910000002 | 13152G00003  | SILENT             | SILENT             | VODAFONE             | SX558-0112 | PROVISIONED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                           |
         | D93FD8C4-EF82-73C2-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"D93FD8C4-EF82-73C2-10900000001","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                       |
         | B884F699-84ED-746E-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"B884F699-84ED-746E-10900000001","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","Autoset.Val.Shoe.Size"]} |
         | E93FD8C4-EF82-73C2-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"E93FD8C4-EF82-73C2-10900000002","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                       |
         | C884F699-84ED-746E-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"C884F699-84ED-746E-10900000002","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","Autoset.Val.Shoe.Size"]} |

  @device.single.load.S9
  @ECO-5394.1 @ECO-5394.2 @ECO-5394.4 @ECO-5394.4b @ECO-5394.4c @ECO-5394.4d @ECO-5394.4e @ECO-5394.4f
   Scenario: Update a cam that does not match an existing flowgen and not an existing CAM
      Given the server receives the following manufacturing unit detail
         | resource                                                                 |
         | /data/manufacturing/unit_detail_new_cam10900000001_fg10900000001_bdg.xml |
         | /data/manufacturing/unit_detail_new_cam10900000002_fg10900000002_bdg.xml |
      Then the server should not produce device manufactured error
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule          | managedByThisSystem | status |
         | 10900000001 | 121          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
         | 10900000002 | 122          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
         | 10900000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
         | 10900000002 | 13152G00003  | SILENT             | SILENT             | VODAFONE             | SX558-0100 | PROVISIONED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                             |
         | D93FD8C4-EF82-43C2-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"D93FD8C4-EF82-43C2-10900000001","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | B884F699-84ED-446E-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"B884F699-84ED-446E-10900000001","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |
         | E93FD8C4-EF82-43C2-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"E93FD8C4-EF82-43C2-10900000002","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | C884F699-84ED-446E-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"C884F699-84ED-446E-10900000002","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |
      When the server receives the following manufacturing unit detail
         | resource                                                                    |
         | /data/manufacturing/unit_detail_update_cam10700000001_fg10700000001_bdg.xml |
         | /data/manufacturing/unit_detail_update_cam10700000002_fg10700000002_bdg.xml |
      Then the server should not produce device manufactured error
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule          | managedByThisSystem | status |
         | 10700000001 | 121          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
         | 10700000002 | 122          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
         | 10700000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
         | 10700000002 | 13152G00003  | SILENT             | SILENT             | VODAFONE             | SX558-0100 | PROVISIONED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                             |
         | D93FD8C4-EF82-43C2-10700000001 | {"FG.SerialNo":"10700000001","SubscriptionId":"D93FD8C4-EF82-43C2-10700000001","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | B884F699-84ED-446E-10700000001 | {"FG.SerialNo":"10700000001","SubscriptionId":"B884F699-84ED-446E-10700000001","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |
         | E93FD8C4-EF82-43C2-10700000002 | {"FG.SerialNo":"10700000002","SubscriptionId":"E93FD8C4-EF82-43C2-10700000002","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | C884F699-84ED-446E-10700000002 | {"FG.SerialNo":"10700000002","SubscriptionId":"C884F699-84ED-446E-10700000002","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |

  @device.single.load.S10
  @ECO-5394.1 @ECO-5394.2 @ECO-5394.4 @ECO-5394.4a
   Scenario: Reject an update of a cam that has the same cam serial number or flowgen serial number in the database while the xml flowgen doesn't match associated flowgen
      Given the server receives the following manufacturing unit detail
         | resource                                                                 |
         | /data/manufacturing/unit_detail_new_cam10900000001_fg10900000001_bdg.xml |
         | /data/manufacturing/unit_detail_new_cam10900000002_fg10900000002_bdg.xml |
      Then the server should not produce device manufactured error
      When the server receives the following manufacturing unit detail
         | resource                                                                    |
         | /data/manufacturing/unit_detail_update_cam10910000001_fg10900000002_bdg.xml |
         | /data/manufacturing/unit_detail_update_cam10900000002_fg10900000003_bdg.xml |
         | /data/manufacturing/unit_detail_update_cam10900000002_fg10900000001_bdg.xml |
         | /data/manufacturing/unit_detail_update_cam10810000002_fg10810000002_bdg.xml |
      Then the server produces the following device manufactured error
         | PersistVetoPoint | PersistFailureType        | PersistFailureReason                          | XmlFile                                                                     |
         | DUPLICATE        | DUPLICATE_FLOW_GENERATOR  | Update duplicate Flow Generator was detected  | /data/manufacturing/unit_detail_update_cam10910000001_fg10900000002_bdg.xml |
         | DUPLICATE        | DUPLICATE_CELLULAR_MODULE | Update duplicate Cellular Module was detected | /data/manufacturing/unit_detail_update_cam10900000002_fg10900000003_bdg.xml |
         | DUPLICATE        | DUPLICATE_CELLULAR_MODULE | Update duplicate Cellular Module was detected | /data/manufacturing/unit_detail_update_cam10900000002_fg10900000001_bdg.xml |
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule          | managedByThisSystem | status |
         | 10900000001 | 121          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
         | 10900000002 | 122          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
         | 10900000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
         | 10900000002 | 13152G00003  | SILENT             | SILENT             | VODAFONE             | SX558-0100 | PROVISIONED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                             |
         | D93FD8C4-EF82-43C2-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"D93FD8C4-EF82-43C2-10900000001","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | B884F699-84ED-446E-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"B884F699-84ED-446E-10900000001","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |
         | E93FD8C4-EF82-43C2-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"E93FD8C4-EF82-43C2-10900000002","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | C884F699-84ED-446E-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"C884F699-84ED-446E-10900000002","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |

  @device.single.load.S11
  @ECO-5394.1 @ECO-5394.2 @ECO-5394.5
   Scenario: Reject an update when the PCBA Serial Number doesn't exist in the CAM table
      Given the server receives the following manufacturing unit detail
         | resource                                                                 |
         | /data/manufacturing/unit_detail_new_cam10900000001_fg10900000001_bdg.xml |
         | /data/manufacturing/unit_detail_new_cam10900000002_fg10900000002_bdg.xml |
      Then the server should not produce device manufactured error
      When the server receives the following manufacturing unit detail
         | resource                                                                    |
         | /data/manufacturing/unit_detail_update_cam10810000002_fg10810000002_bdg.xml |
      Then the server produces the following device manufactured error
         | PersistVetoPoint | PersistFailureType      | PersistFailureReason                                   | XmlFile                                                                     |
         | UNKNOWN          | UNKNOWN_CELLULAR_MODULE | Cellular Module was not found using PCBA serial number | /data/manufacturing/unit_detail_update_cam10810000002_fg10810000002_bdg.xml |
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule          | managedByThisSystem | status |
         | 10900000001 | 121          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
         | 10900000002 | 122          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
         | 10900000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
         | 10900000002 | 13152G00003  | SILENT             | SILENT             | VODAFONE             | SX558-0100 | PROVISIONED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                             |
         | D93FD8C4-EF82-43C2-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"D93FD8C4-EF82-43C2-10900000001","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | B884F699-84ED-446E-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"B884F699-84ED-446E-10900000001","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |
         | E93FD8C4-EF82-43C2-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"E93FD8C4-EF82-43C2-10900000002","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | C884F699-84ED-446E-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"C884F699-84ED-446E-10900000002","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |

  @device.single.load.S12
  @ECO-5394.1 @ECO-5394.2 @ECO-5394.6
   Scenario: Reject an update when the CAM is a Spare Part
      Given the server receives the following manufacturing unit detail
         | resource                                                |
         | /data/manufacturing/unit_detail_007_10000000001_new.xml |
      Then the server should not produce device manufactured error
      When the server receives the following manufacturing unit detail
         | resource                                                         |
         | /data/manufacturing/unit_detail_update_cam10900000002_fg_bdg.xml |
      Then the server produces the following device manufactured error
         | PersistVetoPoint | PersistFailureType      | PersistFailureReason                                                       | XmlFile                                                          |
         | UNKNOWN          | UNPAIRED_FLOW_GENERATOR | Cellular Module is a spare part cause its not paired with a Flow Generator | /data/manufacturing/unit_detail_update_cam10900000002_fg_bdg.xml |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
         | 10000000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
      And I verify the cellular module with serial number 10000000001 does not have a flow generator

  @device.single.load.S13
  @ECO-5394.1 @ECO-5394.2 @ECO-5394.7
   Scenario: Reject an update when the flow generator is missing
      Given the server receives the following manufacturing unit detail
         | resource                                                                 |
         | /data/manufacturing/unit_detail_new_cam10900000001_fg10900000001_bdg.xml |
         | /data/manufacturing/unit_detail_new_cam10900000002_fg10900000002_bdg.xml |
      Then the server should not produce device manufactured error
      When the server receives the following manufacturing unit detail
         | resource                                                         |
         | /data/manufacturing/unit_detail_update_cam10900000002_fg_bdg.xml |
      Then the server produces the following device manufactured error
         | ValidationVetoPoint | ValidationFailureType  | ValidationFailureReason      | XmlFile                                                          |
         | INCOMPLETE_DATA     | MISSING_FLOW_GENERATOR | Flow Generator was not given | /data/manufacturing/unit_detail_update_cam10900000002_fg_bdg.xml |
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule          | managedByThisSystem | status |
         | 10900000001 | 121          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
         | 10900000002 | 122          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
         | 10900000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
         | 10900000002 | 13152G00003  | SILENT             | SILENT             | VODAFONE             | SX558-0100 | PROVISIONED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                             |
         | D93FD8C4-EF82-43C2-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"D93FD8C4-EF82-43C2-10900000001","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | B884F699-84ED-446E-10900000001 | {"FG.SerialNo":"10900000001","SubscriptionId":"B884F699-84ED-446E-10900000001","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |
         | E93FD8C4-EF82-43C2-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"E93FD8C4-EF82-43C2-10900000002","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | C884F699-84ED-446E-10900000002 | {"FG.SerialNo":"10900000002","SubscriptionId":"C884F699-84ED-446E-10900000002","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |

  @device.single.load.S14
  @ECO-5394.1 @ECO-5394.2 @ECO-5394.8
   Scenario: Reject an update due to duplicate subscription id's
      Given the server receives the following manufacturing unit detail
         | resource                                                                 |
         | /data/manufacturing/unit_detail_new_cam10700000001_fg10700000001_bdg.xml |
      Then the server should not produce device manufactured error
      When the server receives the following manufacturing unit detail
         | resource                                                                    |
         | /data/manufacturing/unit_detail_update_cam10700000001_fg10700000001_bdg.xml |
      Then the server produces the following device manufactured error
         | PersistVetoPoint | PersistFailureType     | PersistFailureReason                       | XmlFile                                                                     |
         | DUPLICATE        | DUPLICATE_SUBSCRIPTION | Update duplicate Subscription was detected | /data/manufacturing/unit_detail_update_cam10700000001_fg10700000001_bdg.xml |
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule          | managedByThisSystem | status |
         | 10700000001 | 121          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider  | software   | status      |
         | 10700000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                 | SX558-0100 | PROVISIONED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                             |
         | D93FD8C4-EF82-43C2-10700000001 | {"FG.SerialNo":"10700000001","SubscriptionId":"D93FD8C4-EF82-43C2-10700000001","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | B884F699-84ED-446E-10700000001 | {"FG.SerialNo":"10700000001","SubscriptionId":"B884F699-84ED-446E-10700000001","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |

  @device.single.load.S15
  @ECO-6090.1 @ECO-6090.1a @ECO-6090.1b @ECO-6090.1c @ECO-6090.4 @ECO-6090.4a @ECO-6090.4b
   Scenario: Scrap a FG/CAM Pair - Clean case with supported region codes
      Given the server receives the following manufacturing unit detail
         | resource                                                                 |
         | /data/manufacturing/unit_detail_new_cam10300000001_fg10300000001_bdg.xml |
      Then the server should not produce device manufactured error
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule          | managedByThisSystem | status |
         | 10300000001 | 121          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software    | status      |
         | 10300000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                 | SX558-0100 | PROVISIONED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                             |
         | D93FD8C4-EF82-43C2-10300000001 | {"FG.SerialNo":"10300000001","SubscriptionId":"D93FD8C4-EF82-43C2-10300000001","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | B884F699-84ED-446E-10300000001 | {"FG.SerialNo":"10300000001","SubscriptionId":"B884F699-84ED-446E-10300000001","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |
      When the server receives the following manufacturing unit detail
         | resource                                                                   |
         | /data/manufacturing/unit_detail_scrap_cam10300000001_fg10300000001_bdg.xml |
      Then the server should not produce device manufactured error
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule          | managedByThisSystem | status   |
         | 10300000001 | 121          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | SCRAPPED |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider  | software   | status   |
         | 10300000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                 | SX558-0100 | SCRAPPED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                             |
         | D93FD8C4-EF82-43C2-10300000001 | {"FG.SerialNo":"10300000001","SubscriptionId":"D93FD8C4-EF82-43C2-10300000001","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | B884F699-84ED-446E-10300000001 | {"FG.SerialNo":"10300000001","SubscriptionId":"B884F699-84ED-446E-10300000001","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |

  @device.single.load.S16
  @ECO-6090.1 @ECO-6090.1a @ECO-6090.1b @ECO-6090.1c @ECO-6090.4 @ECO-6090.4a @ECO-6090.4b
   Scenario: Scrap a FG/CAM Pair - Clean case with NOT supported region codes
      Given the server receives the following manufacturing unit detail
         | resource                                                                 |
         | /data/manufacturing/unit_detail_new_cam10300000002_fg10300000002_bdg.xml |
      Then the server should not produce device manufactured error
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule          | managedByThisSystem | status |
         | 10300000002 | 122          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider  | software   | status      |
         | 10300000002 | 13152G00003  | SILENT             | SILENT             | AERIS                 | SX558-0100 | PROVISIONED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                             |
         | E93FD8C4-EF82-43C2-10300000002 | {"FG.SerialNo":"10300000002","SubscriptionId":"E93FD8C4-EF82-43C2-10300000002","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | C884F699-84ED-446E-10300000002 | {"FG.SerialNo":"10300000002","SubscriptionId":"C884F699-84ED-446E-10300000002","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |
      When the server receives the following manufacturing unit detail
         | resource                                                                   |
         | /data/manufacturing/unit_detail_scrap_cam10300000002_fg10300000002_bdg.xml |
      Then the server should not produce device manufactured error
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule          | managedByThisSystem | status   |
         | 10300000002 | 122          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | SCRAPPED |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software    | status   |
         | 10300000002 | 13152G00003  | SILENT             | SILENT             | AERIS                 | SX558-0100 | SCRAPPED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                             |
         | E93FD8C4-EF82-43C2-10300000002 | {"FG.SerialNo":"10300000002","SubscriptionId":"E93FD8C4-EF82-43C2-10300000002","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | C884F699-84ED-446E-10300000002 | {"FG.SerialNo":"10300000002","SubscriptionId":"C884F699-84ED-446E-10300000002","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |
      And the telco administrator should not have device discarded notification

  @device.single.load.S17
  @ECO-6090.1 @ECO-6090.1a @ECO-6090.1b @ECO-6090.1c @ECO-6090.2 @ECO-6090.3
   Scenario: Rejected scrap of a FG/CAM Pair
      Given the server receives the following manufacturing unit detail
         | resource                                                                 |
         | /data/manufacturing/unit_detail_new_cam10700000001_fg10700000001_bdg.xml |
      Then the server should not produce device manufactured error
      When the server receives the following manufacturing unit detail
         | resource                                                                   |
         | /data/manufacturing/unit_detail_scrap_cam10700000001_fg10700000001_bdg.xml |
         | /data/manufacturing/unit_detail_scrap_cam10300000003_fg10300000003_bdg.xml |
      Then the server produces the following device manufactured error
         | PersistVetoPoint | PersistFailureType      | PersistFailureReason                             | XmlFile                                                                    |
         | INCORRECT        | INCORRECT_DEVICE_NUMBER | Flow Generator device number was incorrect       | /data/manufacturing/unit_detail_scrap_cam10700000001_fg10700000001_bdg.xml |
         | UNKNOWN          | UNKNOWN_FLOW_GENERATOR  | Flow Generator was not found using serial number | /data/manufacturing/unit_detail_scrap_cam10300000003_fg10300000003_bdg.xml |
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | software   | hasCellularModule          | managedByThisSystem | status |
         | 10700000001 | 121          | 36  | 25  | 37001       | SX567-0100 | true                       | true                | NEW    |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider  | software   | status      |
         | 10700000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                 | SX558-0100 | PROVISIONED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                                                                                                                                                                                                                             |
         | D93FD8C4-EF82-43C2-10700000001 | {"FG.SerialNo":"10700000001","SubscriptionId":"D93FD8C4-EF82-43C2-10700000001","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data":["Val.Duration"]}                                                                                                                                                                                                         |
         | B884F699-84ED-446E-10700000001 | {"FG.SerialNo":"10700000001","SubscriptionId":"B884F699-84ED-446E-10700000001","ServicePoint":"/api/v1/therapy/settings","Trigger":{"Collect":["HALO"],"OnlyOnChange":true,"Conditional":{"Setting":"Val.Mode","Value":"AutoSet"}},"Data":["Val.Mode","AutoSet.Val.Press","AutoSet.Val.StartPress","AutoSet.Val.EPR.EPREnable","AutoSet.Val.EPR.EPRType","AutoSet.Val.EPR.Level","AutoSet.Val.Ramp.RampEnable","AutoSet.Val.Ramp.RampTime"]} |

  @device.single.load.S18
  @ECO-9651.1 @ECO-9651.2
   Scenario: Manufacturing task request for external CAM successfully done
      Given the server receives the following manufacturing unit detail
         | resource                                                                  |
         | /data/manufacturing/unit_detail_new_cam10000000001_fg_bdg22151763341.xml  |
      Then the server should not produce device manufactured error
      And the bridge with cam serial number 10000000001 from the last manufacturing task request is stored in the database

  @device.single.load.S19
  @ECO-9651.2
   Scenario: Manufacturing task request for external CAM with duplicate bridge PCBA serial number will be rejected
      Given the server receives the following manufacturing unit detail
         | resource                                                                  |
         | /data/manufacturing/unit_detail_new_cam10000000001_fg_bdg22151763341.xml  |
      Then the server should not produce device manufactured error
      And the bridge with cam serial number 10000000001 from the last manufacturing task request is stored in the database
      When the server receives the following manufacturing unit detail
         | resource                                                                  |
         | /data/manufacturing/unit_detail_new_cam10000000002_fg_bdg22151763341.xml  |
      Then the server produces the following device manufactured error
         | PersistVetoPoint | PersistFailureType      | PersistFailureReason                 | XmlFile                                                                  |
         | DUPLICATE        | DUPLICATE_BRIDGE_MODULE | Duplicate Bridge Module was detected | /data/manufacturing/unit_detail_new_cam10000000002_fg_bdg22151763341.xml |
      And the bridge with cam serial number 10000000002 from the last manufacturing task request is not stored in the database

  # This xml will be blocked by the NGCS because it fails the validation
  # This scenario only to test one of the filter that checks if CAM is null
  @device.single.load.S20
  @ECO-9651.2
   Scenario: Manufacturing task request for external CAM which fails xsd validation (missing CAM in the xml) will be rejected
      Given the server receives the following manufacturing unit detail
         | resource                                                      |
         | /data/manufacturing/unit_detail_new_cam_fg_bdg22151763344.xml |
      Then the server produces the following device manufactured error
         | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason                      | XmlFile                                                       |
         | SCHEMA              | INVALID_DOCUMENT      | Unit Detail does not validate against schema | /data/manufacturing/unit_detail_new_cam_fg_bdg22151763344.xml |
      And the bridge with pcba serial number 22151763344 from the last manufacturing task request is not stored in the database

  @device.single.load.S21
  @ECO-9651.2
   Scenario: Manufacturing task request with duplicated CAM (a CAM which already come in previous request) will be rejected
      Given the server receives the following manufacturing unit detail
         | resource                                                                  |
         | /data/manufacturing/unit_detail_new_cam10000000001_fg_bdg22151763341.xml  |
      Then the server should not produce device manufactured error
      And the bridge with cam serial number 10000000001 from the last manufacturing task request is stored in the database
      When the server receives the following manufacturing unit detail
         | resource                                                                  |
         | /data/manufacturing/unit_detail_new_cam10000000001_fg_bdg22151763351.xml  |
      Then the server produces the following device manufactured error
         | PersistVetoPoint | PersistFailureType        | PersistFailureReason                   | XmlFile                                                                  |
         | DUPLICATE        | DUPLICATE_CELLULAR_MODULE | Duplicate Cellular Module was detected | /data/manufacturing/unit_detail_new_cam10000000001_fg_bdg22151763351.xml |
      And the bridge with pcba serial number 22151763351 from the last manufacturing task request is not stored in the database

  @device.single.load.S22
  @ECO-10512.1 @ECO-10512.2
   Scenario: Manufacturing task request for Stellar or Astral successfully done
      Given the server receives the following manufacturing unit detail
         | resource                                                      |
         | /data/manufacturing/unit_detail_new_cam_fg10000000004_bdg.xml |
      Then the server should not produce device manufactured error
      And the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | hasCellularModule         | scrapped | managedByThisSystem |
         | 10000000004 | 124          | 36  | 99  | 37001       | false                     | false    | true                |

  @device.single.load.S23
  @ECO-10512.1
   Scenario: Manufacturing task request for Stellar or Astral failed due to invalid xml
      Given the server receives the following manufacturing unit detail
         | resource                                                              |
         | /data/manufacturing/unit_detail_new_cam_fg10000000004_bdg_invalid.xml |
      Then the server produces the following device manufactured error
         | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason                      | XmlFile                                                               |
         | SCHEMA              | INVALID_DOCUMENT      | Unit Detail does not validate against schema | /data/manufacturing/unit_detail_new_cam_fg10000000004_bdg_invalid.xml |
      And I find no flow generator with serial number "10000000004"

  @device.single.load.S24
  @ECO-15318.1
  Scenario: An Update Newport UnitDetail is given containing a cellular module, a cellular module GUID shall be calculated from the updated cellular module details, associated with the updated cellular module, and persisted with the updated cellular module
    Given the server receives the following manufacturing unit detail
      | resource                                                             |
      | /data/manufacturing/unit_detail_fg20000000005_cam20000000006_new.xml |
    Then the server should not produce device manufactured error
    And the server has the following comm modules
      | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
      | 20000000006 | 23152G00005  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
    And NGCS has the following subscriptions
      | subscriptionId                 | subscriptionJson |
      | E13FD8C4-EF82-43C2-20000000005 | {"FG.SerialNo":"20000000005","SubscriptionId":"E13FD8C4-EF82-43C2-20000000005","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data": [ "Val.Duration"]} |
    And the server receives the following manufacturing unit detail
      | resource                                                                |
      | /data/manufacturing/unit_detail_fg20000000005_cam20000000006_update.xml |
    Then the server should not produce device manufactured error
    And the server has the following comm modules
      | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      | uid |
      | 20000000006 | 23152G00005  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED | 277f56e6-4c19-3c79-a5be-730225ef3876 |
    And NGCS has the following subscriptions
      | subscriptionId                 | subscriptionJson |
      | E13FD8C4-EF82-43C2-29999999995 | {"FG.SerialNo":"20000000005","SubscriptionId":"E13FD8C4-EF82-43C2-29999999995","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data": [ "Val.Duration"]} |
    And NGCS does not have subscription "E13FD8C4-EF82-43C2-20000000005"

  @device.single.load.S25
  @ECO-16986.1
  @ECO-16986.1a
  @ECO-16986.1b
  @ECO-15318.1
   Scenario: Manufacture is able to send NEW or UPDATE Newport device(s) with security data instead of authentication key.
      Given the server receives the following manufacturing unit detail
         | resource                                                                                |
         | /data/manufacturing/unit_detail_fg20000000005_cam20000000006_new_with_security_data.xml |
      Then the server should not produce device manufactured error
      Then the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | hasCellularModule | managedByThisSystem | status | software   |
         | 20000000005 | 121          | 36  | 25  | 37001       | true              | true                | NEW    | SX567-0100 |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
         | 20000000006 | 23152G00005  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
      And NGCS has the following subscriptions
         | subscriptionId                 | subscriptionJson                                                                                                                                                                                                                       |
         | E13FD8C4-EF82-43C2-20000000005 | {"FG.SerialNo":"20000000005","SubscriptionId":"E13FD8C4-EF82-43C2-20000000005","ServicePoint":"/api/v1/therapy/summaries","Trigger":{"Collect":["HALO"],"Conditional":{"Setting":"Val.Duration","Value":0}},"Data": [ "Val.Duration"]} |
#       And the server persist the Cellular Module security data in the CELLULAR_MODULE_SECURITY table
      When the server receives the following manufacturing unit detail
         | resource                                                                                   |
         | /data/manufacturing/unit_detail_fg20000000005_cam20000000066_update_with_security_data.xml |
      Then the server should not produce device manufactured error
      Then the server has the following flow generators
         | serialNo    | deviceNumber | mid | vid | productCode | hasCellularModule | managedByThisSystem | status | software   |
         | 20000000005 | 121          | 36  | 25  | 37001       | true              | true                | NEW    | SX577-0100 |
      And the server has the following comm modules
         | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
         | 20000000066 | 23152G00005  | ACTIVE             | ACTIVE             | AERIS                | SX577-0100 | PROVISIONED |