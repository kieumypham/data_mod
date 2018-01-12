@cam
@newport
@newport.autoset
@autoset.comfort
@ECO-4678
@ECO-4684
@ECO-4706
@ECO-4680
@ECO-4768
@ECO-4690
@ECO-4729
@ECO-4847
@ECO-4848
@ECO-4849
@ECO-4860
@ECO-5879
@ECO-5880
@ECO-5874

Feature:
  (ECO-4678) As a user
  I want ECO to receive summary data pushed wirelessly from the Newport AutoSet Comfort device
  In order that I can monitor my patient's compliance

  (ECO-4684) As a user
  I want ECO to receive settings for CPAP mode pushed wirelessly from the Newport AutoSet Comfort device
  In order that I can know my patient's prescription

  (ECO-4706) As a user
  I want ECO to receive settings for AutoSet mode pushed wirelessly from the Newport AutoSet Comfort device
  In order that I can know my patient's prescription

  (ECO-4680) As a user
  I want ECO to specify the summary data pushed wirelessly from the Newport AutoSet Comfort device
  In order that I can control what data is transmitted

  (ECO-4690) As a user
  I want ECO to write settings wirelessly to the Newport AutoSet Comfort device (CPAP mode)
  In order that I can change my patient's prescription

  (ECO-4729) As a user
  I want ECO to write settings wirelessly to the Newport AutoSet Comfort device (AutoSet mode)
  In order that I can change my patient's prescription

  (ECO-4768) As a clinical user
  I want to know the mode and RERA as part of summary data
  so that I can understand my patient's treatment more effectively

  (ECO-4847) As a clinical user
  I want to be able to see (subscribe) the patient interface device details
  In order that I can troubleshoot patient difficulties

  (ECO-4848) As a clinical user
  I want to be able to see (receive) the patient interface device details
  In order that I can troubleshoot patient difficulties

  (ECO-4849) As a clinical user
  I want to be able to see (subscribe) the device faults
  In order that I can troubleshoot patient service difficulties

  (ECO-4860) As a clinical user
  I want to be able to see patient interface and climate settings
  In order that I can shortcut any diagnosis of patient humidification problems

  (ECO-5879) As a clinical user
  I want to see the settings shown for a day that correspond to those used during treatment for the day
  so that I am not misled about the patients therapy

  (ECO-5880) As a clinical user
  I want to see when my wireless settings have been completed
  so that I know that the patient will have the required treatment

  (ECO-5874) As ECO
  I want data received by NGCS to be validated against the subscription for the data
  to prevent rubbish data entering the system

  # ACCEPTANCE CRITERIA: (ECO-4678)
  # Note 1: The term "server" shall be used interchangeably with NGCS.
  # 1. The server shall receive the summary data of the S10 AutoSet Comfort device
  # (MID 36, VID 26) for a day (i.e. session).
  # Note 2: the summary data does not include the settings of the device with the possible exception of the mode.
  # 2. The server shall forward the device identification,
  # the session date and the summary data for the day to an HI Cloud API.
  # Note 3: No authentication of the therapy device is necessary (i.e no need to know the authentication key or to check the MD5 checksum if present.
  # Note 4: Protocol and model details:
  # The protocol is specified at http://confluence.corp.resmed.org/display/CA/Wireless+Protocol
  # The device model for the device (if needed) can be found at http://confluence.corp.resmed.org/display/CA/Modelling+of+Therapy+Devices The model indicates the units of each data item in the Data Dictionary file.
  # Note 5: Example message format for this device is as follows:
  # {
  # "SubscriptionId": "Summary",
  # "CollectTime": "20130430 140302",
  # "Date": "20130429",
  # "Val.Duration": 600,
  # "Val.MaskOn": [120, 340, 450],
  # "Val.MaskOff": [300, 400, 1200],
  # "Val.AHI": 5.5,
  # "Val.AI": 5.5,
  # "Val.HI": 5.5,
  # "Val.OAI": 5.5,
  # "Val.CAI": 5.5,
  # "Val.UAI": 5.5,
  # "Val.Leak.50": 4.3,
  # "Val.Leak.95": 7.3,
  # "Val.Leak.Max": 12.3,
  # "Val.TgtIPAP.50": 12.4,
  # "Val.TgtIPAP.95": 13.0,
  # "Val.TgtIPAP.Max": 14.8,
  # "Val.CSR": 27
  # }
  # Please see http://confluence.corp.resmed.org/display/CA/Summary+data for details and explanations.
  # Note 7: For an unused day the Val.Duration will be zero with (usually) no other fields present. If a field is uninitialised in the device (very common for statisitics if only a few minutes of treatment) then the field will not be present in the structure at all.

  # ACCEPTANCE CRITERIA: (ECO-4684)
  # Note 1: The term "server" shall be used interchangeably with NGCS.
  # 1. The server shall receive the CPAP settings for the S10 AutoSet Comfort device (MID 36, VID 26) for a day (i.e. session).
  # 2. The server shall forward the device identification, the session date and the settings for the day to an HI Cloud API.
  # Note 4: No authentication of the therapy device is necessary (i.e no need to know the authentication key or to check the MD5 checksum if present.
  # Note 5: Protocol and model details:
  # The protocol is specified at http://confluence.corp.resmed.org/display/CA/Wireless+Protocol
  # The device model for the device (if needed) can be found at http://confluence.corp.resmed.org/display/CA/Modelling+of+Therapy+Devices The model indicates the units and enumeration values of each data item in the Data Dictionary file.
  # Note 6: Example mesage JSON for this device for CPAP mode is as follows:
  # {
  # "SubscriptionId": "CPAPSettings",
  # "CollectTime": "20130430 120102",
  # "Date": "20130429",
  # "Set.Mode": "CPAP",
  # "CPAP.Set.Press": 12.2,
  # "CPAP.Set.StartPress": 8.0,
  # "CPAP.Set.EPR.EPREnable": "On",
  # "CPAP.Set.EPR.EPRType": "FullTime",
  # "CPAP.Set.EPR.Level": 2,
  # "CPAP.Set.Ramp.RampEnable": "Off",
  # "CPAP.Set.Ramp.RampTime": 5
  # }
  # Please see http://confluence.corp.resmed.org/display/CA/Settings for details and explanations.

  # ACCEPTANCE CRITERIA: (ECO-4706)
  # Note 1: The term "server" shall be used interchangeably with NGCS.
  # 1. The server shall receive the AutoSet settings for the S10 AutoSet Comfort device (MID 36, VID 26) for a day (i.e. session).
  # 2. The server shall forward the device identification, the session date and the settings for the day to an HI Cloud API.
  # Note 2: No authentication of the therapy device is necessary (i.e no need to know the authentication key or to check the MD5 checksum if present.
  # Note 3: Protocol and model details:
  # The protocol is specified at http://confluence.corp.resmed.org/display/CA/Wireless+Protocol
  # The device model for the device (if needed) can be found at http://confluence.corp.resmed.org/display/CA/Modelling+of+Therapy+Devices  The model indicates the units of each data item in the Data Dictionary file.
  # Note 4: Example mesage JSON for this device for AutoSet mode is as follows:
  # {
  # "SubscriptionId": "AutoSetSettings",
  # "CollectTime": "20130430 120102",
  # "Date": "20130429",
  # "Set.Mode": "AutoSet",
  # "AutoSet.Set.MinPress": 8.0,
  # "AutoSet.Set.MaxPress": 14.0,
  # "AutoSet.Set.StartPress": 10.0,
  # "AutoSet.Set.EPR.EPREnable": "On",
  # "AutoSet.Set.EPR.EPRType": "Ramp",
  # "AutoSet.Set.EPR.Level": 2,
  # "AutoSet.Set.Ramp.RampEnable": "Auto",
  # "AutoSet.Set.Ramp.RampTime": 30,
  # "AutoSet.Set.Comfort": "Off"
  # }
  # Please see http://confluence.corp.resmed.org/display/CA/Settings for details and explanations.

  # ACCEPTANCE CRITERIA: (ECO-4680)
  # Note 1: The term "server" shall be used interchangeably with NGCS.
  # 1. The server shall subscribe on summary data of the S10 AutoSet Comfort device (MID 36, VID 26). Note: the summary data does not include the settings except for the mode. All summary data identified in the model should be subscribed.
  # 2. The subscription shall use the following trigger and delivery information:
  # 2a. Trigger type HALO (Hour after last mask off)
  # 2b. Date range with a from date of today and with no end date
  # Note 2: Protocol and model details:
  # The protocol is specified at http://confluence.corp.resmed.org/display/CA/Wireless+Protocol
  # The device model for the device (if needed) can be found at http://confluence.corp.resmed.org/display/CA/Modelling+of+Therapy+Devices
  # Note 3: It is not necessary as part of this story to force the device to ring in to receive the subscription via SMS or shoulder tap.
  # Note 4: Example subscription JSON for this device is as follows:
  # {
  # "ServicePoint": "/api/v1/summary/add",
  # "SubscriptionId": "Summary",
  # "Trigger": "HALO",
  # "Schedule": {
  #   "StartDate": "20130410",
  #   "EndDate": null
  # },
  # "Data": [
  # "Val.Duration",
  # "Val.MaskOn",
  # "Val.MaskOff",
  # "Val.AHI",
  # "Val.AI",
  # "Val.HI",
  # "Val.OAI",
  # "Val.CAI",
  # "Val.UAI",
  # "Val.Leak.50",
  # "Val.Leak.95",
  # "Val.Leak.Max",
  # "Val.TgtIPAP.50",
  # "Val.TgtIPAP.95",
  # "Val.TgtIPAP.Max",
  # "Val.CSR"
  # ]}

  # ACCEPTANCE CRITERIA: (ECO-4768)
  # Note 1: This story extends the following stories: ECO-4354, ECO-4679, ECO-4680, ECO-4678
  # 1. The server shall receive the therapy mode as part of summary data for S10 devices. Note 2: at the time of writing this is the (a) S10 AfH and (b) S10 AutoSet Comfort devices.
  # 2. The server shall subscribe the therapy mode as part of summary data for S10 devices. Note 3: at the time of writing this is the (a) S10 AfH and (b) S10 AutoSet Comfort devices.
  # 3. The server shall receive the RERA Index (RDI) as part of summary data for the S10 AfH device(MID = 36, VID = 25).
  # 4. The server shall subscribe the RERA Index (RDI) as part of summary data for the S10 AfH device(MID = 36, VID = 25).
  # Note 4: Example summary subscription S10 AfH is:
  # {
  # "ServicePoint": "/api/v1/summary/add",
  # "SubscriptionId": "Summary",
  # "Trigger": "HALO",
  # "Schedule": {
  # "StartDate": "20130410",
  # "EndDate": null
  # },
  # "Data": [
  # "Val.Mode",
  # "Val.Duration",
  # "Val.MaskOn",
  # "Val.MaskOff",
  # "Val.AHI",
  # "Val.AI",
  # "Val.HI",
  # "Val.OAI",
  # "Val.CAI",
  # "Val.UAI",
  # "Val.Leak.50",
  # "Val.Leak.95",
  # "Val.Leak.Max",
  # "Val.TgtIPAP.50",
  # "Val.TgtIPAP.95",
  # "Val.TgtIPAP.Max",
  # "Val.CSR",
  # "Val.RDI"
  # ] }
  # Note 5: Exmaple subscription for the S10 AutoSet Comfort is:
  # {
  # "ServicePoint": "/api/v1/summary/add",
  # "SubscriptionId": "Summary",
  # "Trigger": "HALO",
  # "Schedule": {
  # "StartDate": "20130410",
  # "EndDate": null
  # },
  # "Data": [
  # "Val.Mode",
  # "Val.Duration",
  # "Val.MaskOn",
  # "Val.MaskOff",
  # "Val.AHI",
  # "Val.AI",
  # "Val.HI",
  # "Val.OAI",
  # "Val.CAI",
  # "Val.UAI",
  # "Val.Leak.50",
  # "Val.Leak.95",
  # "Val.Leak.Max",
  # "Val.TgtIPAP.50",
  # "Val.TgtIPAP.95",
  # "Val.TgtIPAP.Max",
  # "Val.CSR"
  # ] }

  # ACCEPTANCE CRITERIA: (ECO-4690)
  # 1. The server shall allow CPAP settings to be updated for the S10 AutoSet Comfort device (MID 36, VID 26).
  # 2. All therapy settings for CPAP shall be changed in one operation.
  # 3. The most recent therapy settings request for a device shall replace any earlier therapy settings requests that have not yet been delivered to the device.
  # Note 1: Protocol and model details:
  # The protocol is specified at http://confluence.corp.resmed.org/display/CA/Settings
  # The device model for the device (if needed) can be found at http://confluence.corp.resmed.org/display/CA/Modelling+of+Therapy+Devices
  # Note 2: It is not necessary as part of this story to force the device to ring in to receive the subscription via SMS or shoulder tap.
  # Note 3: It is not necessary for the device to confirm receiving the settings as part of this operation.
  # Note 4: This story can be just the happy case. That is, only dealing with the GET settings when there is a settings change request present.
  # Note 5: Example message JSON for this device for CPAP mode is as follows:
  # {
  # "SettingsId": "CPAPSettings01",
  # "Set.Mode": "CPAP",
  # "CPAP.Set.Press": 14.0,
  # "CPAP.Set.StartPress": 9.0,
  # "CPAP.Set.EPR.EPREnable": "Off",
  # "CPAP.Set.EPR.EPRType": "FullTime",
  # "CPAP.Set.EPR.Level": 1,
  # "CPAP.Set.Ramp.RampEnable": "On",
  # "CPAP.Set.Ramp.RampTime": 30
  # }
  # Please see http://confluence.corp.resmed.org/display/CA/Settings for details and explanations.

  # ACCEPTANCE CRITERIA: (ECO-4729)
  # Note 1: Settings for CPAP mode for this device implemented in ECO-4690.
  # 1. The server shall allow AutoSet settings to be updated for the S10 AutoSet Comfort device (MID 36, VID 26).
  # 2. All therapy settings for AutoSet shall be changed in one operation.
  # 3. The most recent therapy settings request for a device shall replace any earlier therapy settings requests that have not yet been delivered to the device.
  # Note 2: Protocol and model details:
  # The protocol is specified at http://confluence.corp.resmed.org/display/CA/Settings
  # The device model for the device (if needed) can be found at http://confluence.corp.resmed.org/display/CA/Modelling+of+Therapy+Devices
  # Note 3: It is not necessary as part of this story to force the device to ring in to receive the subscription via SMS or shoulder tap.
  # Note 4: It is not necessary for the device to confirm receiving the settings as part of this operation.
  # Note 5: This story can be just the happy case. That is, only dealing with the GET settings when there is a settings change request present.
  # Note 6: Example mesage JSON for this device for AutoSet mode is as follows:
  # {
  # "SettingsId": "AutoSetSettings01",
  # "Set.Mode": "AutoSet",
  # "AutoSet.Set.MinPress": 6.0,
  # "AutoSet.Set.MaxPress": 16.0,
  # "AutoSet.Set.StartPress": 9.0,
  # "AutoSet.Set.EPR.EPREnable": "Off",
  # "AutoSet.Set.EPR.EPRType": "FullTime",
  # "AutoSet.Set.EPR.Level": 3,
  # "AutoSet.Set.Ramp.RampEnable": "Auto",
  # "AutoSet.Set.Ramp.RampTime": 20,
  # "AutoSet.Set.Comfort": "On"
  # }
  # Please see http://confluence.corp.resmed.org/display/CA/Settings for details and explanations.

  # ACCEPTANCE CRITERIA: (ECO-4847)
  # Note 1: The term "server" shall be used interchangeably with NGCS.
  # 1. The server shall subscribe on patient interface data from S10 devices. Note: currently this is the S10 AfH and AutoSet Comfort devices.
  # 2. The patient interface data shall consist of the patient interface monitored data for the S10 devices as http://confluence.corp.resmed.org/display/CA/Modelling+of+Therapy+Devices
  # 3. The patient interface data shall be subscribed together with the summary data for the device.
  # Note 2: Protocol and model details:
  # The protocol is specified at http://confluence.corp.resmed.org/display/CA/Wireless+Protocol
  # Note 3: Example subscription JSON is as follows:
  # {
  # "ServicePoint": "/api/v1/summary/add",
  # "SubscriptionId": "Summary",
  # "Trigger": "HALO",
  # "Schedule": {
  # "StartDate": "20130410",
  # "EndDate": null
  # }
  # "Data": [
  # "Val.Mode",
  # "Val.Duration",
  # ...
  # etc as per existing summary data
  # ...
  # "Val.Humidifier",
  # "Val.HeatedTube",
  # "Val.AmbHumidity"
  # ] }

  # ACCEPTANCE CRITERIA: (ECO-4848)
  # 1. The summary data received by the server shall include the patient interface data from S10 devices. Note: currently this is for the S10 AfH and AutoSet Comfort devices.
  # 2. The patient interface data shall consist of the patient interface monitored data for the S10 devices as http://confluence.corp.resmed.org/display/CA/Modelling+of+Therapy+Devices
  # Note 2: Protocol and model details:
  # The protocol is specified at http://confluence.corp.resmed.org/display/CA/Wireless+Protocol
  # Note 3: Example summary post is as follows:
  # {
  # "SubscriptionId": "Summary",
  # "CollectTime": "20130430 140302",
  # "Date": "20130429",
  # "Val.Mode": "CPAP",
  # "Val.Duration": 220,
  # ...
  # etc as per existing summary data
  # ...
  # "Val.Humidifier": "Internal",
  # "Val.HeatedTube": "None",
  # "Val.AmbHumidity": 25
  # ]}

  # ACCEPTANCE CRITERIA: (ECO-4849)
  # Note 1: The term "server" shall be used interchangeably with NGCS.
  # 1. The server shall subscribe on device faults from the S10 devices. Note: currently this is the S10 AfH and AutoSet Comfort devices.
  # 2. The subscription shall use the following trigger and delivery information:
  # 2a. Trigger type HALO (Hour after last mask off)
  # 2b. Date range with a from date of today and with no end date
  # 2c. Sent now (initially)
  # 2d. Otherwise sent on change only
  # Note 2: Protocol and model details:
  # The protocol is specified at http://confluence.corp.resmed.org/display/CA/Subscription
  # Note 3: Example subscription JSON is as follows:
  # {
  # "ServicePoint": "/api/v1/faults/add",
  # "SubscriptionId": "Faults",
  # "Trigger": {
  #  "Collect":["HALO", "Now"],
  #  "OnlyOnChange": true
  # },
  # "Data": [
  # "Fault.Device",
  # "Fault.Humidifier",
  # "Fault.HeatedTube"
  # ]}

  # ACCEPTANCE CRITERIA: (ECO-4860)
  # Note 1: The term "server" shall be used interchangeably with NGCS.
  # 1. The server shall receive the patient interface settings from S10 devices. Note: currently this is for the S10 AfH and AutoSet Comfort devices.
  # 2. The patient interface settings shall consist of the patient interface settings for the S10 devices as http://confluence.corp.resmed.org/display/CA/Modelling+of+Therapy+Devices
  # 3. The server shall forward the device identification, the session date and the patient interface settings for the day to an HI Cloud API.
  # Note 3: Protocol and model details:
  # The protocol is specified at http://confluence.corp.resmed.org/display/CA/Climate+Settings+-+new
  # The device model for the device (if needed) can be found at http://confluence.corp.resmed.org/display/CA/Modelling+of+Therapy+Devices The model indicates the units of each data item in the Data Dictionary file.
  # Note 4: Example message JSON is as follows:
  # {
  # "FG.SerialNo": "12345678901",
  # "CollectTime": "20130430 140302",
  # "SubscriptionId": "ClimateSettings01",
  # "Date": "20130429",
  # "Set.ClimateControl": "Auto",
  # "Set.HumEnable": "On",
  # "Set.HumLevel": 5,
  # "Set.TempEnable": "Off",
  # "Set.Temp": 28,
  # "Set.Tube": "19mm",
  # "Set.Mask": "FullFace",
  # "Set.SmartStart": "On"
  # }

    # ACCEPTANCE CRITERIA: (ECO-5879)
    # Note 1: The purpose of this story is to change the settings received that update the settings stored for the day in ECO and that are shown on reports. As per https://confluence.ec2.local/x/MZKeAQ the intent is to receive therapy session settings using a "Val" prefix whereas when writing settings a "Set" prefix should be used.
    # 1. ECO shall update the settings for a day of data when it receives the settings from the therapy session from the device. Note 2: These will use the "Val" prefix rather than the "Set" prefix but otherwise be unchanged from those received currently. The "Val" settings are received in a separate message to the "Set" settings - see Note 4 for an example.
    # Note 3: Once this card is implemented then acknowledgment of wireless settings will not work until ECO-5880 is complete.
    # Note 4: Example CPAP "Val" settings POST to ECO is as follows:
    # POST /api/v1/therapy/settings HTTP/1.1
    # X-CamSerialNo: {serial number}
    # X-Hash: {hash}
    #
    # {
    # "FG.SerialNo": "{serial number}",
    # "SubscriptionId": "{uuid-D}",
    # "Date": "20130429",
    # "CollectTime": "20130430 140302",
    # "Val.Mode": "CPAP",
    # "CPAP.Val.Press": 12.2,
    # "CPAP.Val.StartPress": 8.0,
    # "CPAP.Val.EPR.EPREnable":"On",
    # "CPAP.Val.EPR.EPRType": "FullTime",
    # "CPAP.Val.EPR.Level": 2,
    # "CPAP.Val.Ramp.RampEnable": "Off",
    # "CPAP.Val.Ramp.RampTime": 0
    # }
    # Note 5: This full list of new "Val" settings to be received are as follows:
    # "Val.Mode"
    # "CPAP.Val.Press"
    # "CPAP.Val.StartPress"
    # "CPAP.Val.EPR.EPREnable"
    # "CPAP.Val.EPR.EPRType"
    # "CPAP.Val.EPR.Level"
    # "CPAP.Val.Ramp.RampEnable"
    # "CPAP.Val.Ramp.RampTime"
    # "AutoSet.Val.MinPress"
    # "AutoSet.Val.MaxPress"
    # "AutoSet.Val.StartPress"
    # "AutoSet.Val.EPR.EPREnable"
    # "AutoSet.Val.EPR.EPRType"
    # "AutoSet.Val.EPR.Level"
    # "AutoSet.Val.Ramp.RampEnable"
    # "AutoSet.Val.Ramp.RampTime"
    # "AutoSet.Val.Comfort"
    # "HerAuto.Val.MinPress"
    # "HerAuto.Val.MaxPress"
    # "HerAuto.Val.StartPress"
    # "HerAuto.Val.EPR.EPREnable"
    # "HerAuto.Val.EPR.EPRType"
    # "HerAuto.Val.EPR.Level"
    # "HerAuto.Val.Ramp.RampEnable"
    # "HerAuto.Val.Ramp.RampTime"
    # "Val.ClimateControl"
    # "Val.HumEnable"
    # "Val.HumLevel"
    # "Val.TempEnable"
    # "Val.Temp",
    # "Val.Tube",
    # "Val.Mask",
    # "Val.SmartStart"

   # ACCEPTANCE CRITERIA: (ECO-5880)
   # Note 1: Settings are being changed so that the 'Set" settings are only being sent to the cloud after a remote settings change operation as per discussions on page https://confluence.ec2.local/x/MZKeAQ
   #
   # 1. When current settings are received from a Newport device i.e. using the 'Set" prefix, that match the most recent settings request then ECO shall:
   #    1a. change the settings status to No Changes Pending;
   #    1b. display the updated settings on the Prescription page; and
   #    1c. log settings success.
   # Note 2: This matches the existing S9 behaviour when a settings confirmation or acknowledgement is received from Comm Server via CAL as per ECO-1574
   # Note 3: The receipt of current settings should not be used to update the settings for a day of data anymore. We do not want the current settings to appear on reports etc.
   # Note 4: This card is implementing the happy day case for settings acknowledgment - assuming that settings changes will be successful.

   # ACCEPTANCE CRITERIA: (ECO-5874)
   # Note 1: This story corresponds to part of the processing in Step 4 Subscription comparison on https://confluence.ec2.local/x/q4yeAQ
   # 1. Any messages containing data or settings received from Newport devices shall be prevented from being placed on the valid message queue if the message does not correspond to a known subscription.
   # 2. Any message containing data items that are not listed in the subscription shall be shall be prevented from being placed on the valid message queue.
   # 3. A configurable property shall be available that can disable or enable the validation in AC#1 and AC#2 above. Note 2: That is, when the validation is disabled then all messages would be placed on the valid message queue even if the message did not correspond to a known subscription.
   # Note 3: For reference testing if needed the data needed in the subscriptions for Newport CPL can be found at http://confluence.corp.resmed.org/x/N4Nj in "Subscriptions CPL.txt"

  Background:
    Given the server receives the following manufacturing unit detail
      | resource                                                             |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg20070811223_cam20102141732_new.xml |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |

  @autoset.comfort.S1 @subscription @subscription.therapy_summary @subscription.fault
  @ECO-4680.1 @ECO-4680.2
  @ECO-4768.2 @ECO-4768.4
  @ECO-4847.1 @ECO-4847.2 @ECO-4847.3
  @ECO-4849.1b @ECO-4849.2
  Scenario: Device receives the correct subscription information for the subscription request that the device sends.
    And the server has the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryCPAP",    "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max",                                                        "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryAutoSet", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.TgtIPAP.50", "Val.TgtIPAP.95", "Val.TgtIPAP.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"Faults",         "ServicePoint":"/api/v1/faults",            "Trigger": { "Collect": [ "HALO", "Now" ], "OnlyOnChange": true },          "Data":[ "Fault.Device", "Fault.Humidifier", "Fault.HeatedTube" ] }                                                                                                                                                                                                                                         |
    When I request the subscription with identifier "SummaryCPAP"
    Then I should receive the following subscription
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryCPAP",    "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max",                                                        "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |

  @autoset.comfort.S2 @subscription @subscription.therapy_summary @subscription.fault
  @ECO-4680.1 @ECO-4680.2
  @ECO-4768.2 @ECO-4768.4
  @ECO-4847.1 @ECO-4847.2 @ECO-4847.3
  @ECO-4849.1b @ECO-4849.2
  Scenario: Device receives the correct subscription information for the subscription request that the device sends.
    And the server has the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryCPAP",    "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max",                                                        "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryAutoSet", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.TgtIPAP.50", "Val.TgtIPAP.95", "Val.TgtIPAP.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"Faults",         "ServicePoint":"/api/v1/faults",            "Trigger": { "Collect": [ "HALO", "Now" ], "OnlyOnChange": true },          "Data":[ "Fault.Device", "Fault.Humidifier", "Fault.HeatedTube" ] }                                                                                                                                                                                                                                         |
    When I request the subscription with identifier "SummaryAutoSet"
    Then I should receive the following subscription
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryAutoSet", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.TgtIPAP.50", "Val.TgtIPAP.95", "Val.TgtIPAP.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |

  @autoset.comfort.S3 @subscription @subscription.therapy_summary @subscription.fault
  @ECO-4680.1 @ECO-4680.2
  @ECO-4768.2b
  @ECO-4847.1 @ECO-4847.2 @ECO-4847.3
  @ECO-4849.1b @ECO-4849.2
  Scenario: Device receives the correct subscription information for the subscription request that the device sends.
    And the server has the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryCPAP",    "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max",                                                        "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryAutoSet", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.TgtIPAP.50", "Val.TgtIPAP.95", "Val.TgtIPAP.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"Faults",         "ServicePoint":"/api/v1/faults",            "Trigger": { "Collect": [ "HALO", "Now" ], "OnlyOnChange": true },          "Data":[ "Fault.Device", "Fault.Humidifier", "Fault.HeatedTube" ] }                                                                                                                                                                                                                                         |
    When I request the subscription with identifier "Faults"
    Then I should receive the following subscription
      | json                                                                                                                                                                                                                                                           |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"Faults",         "ServicePoint":"/api/v1/faults",            "Trigger": { "Collect": [ "HALO", "Now" ], "OnlyOnChange": true },          "Data":[ "Fault.Device", "Fault.Humidifier", "Fault.HeatedTube" ] } |

  @autoset.comfort.S4 @summary @summary.usage @valid.against.subscription
  @ECO-4678.1 @ECO-4678.2
  @ECO-4768.1 @ECO-4768.3
  @ECO-4848.1 @ECO-4848.2
  @ECO-5874.1
  Scenario: Summary service responds with OK for good data and empty data
     # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_12CE1A82-93A9-4839-948A-E3F8FD51C9FE.json |
    And these devices have the following therapy summaries
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"12CE1A82-93A9-4839-948A-E3F8FD51C9FE",    "Date":"3 days ago", "CollectTime":"2 days ago 090100", "Val.Mode":"CPAP",    "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":4.4, "Val.Leak.Max":4.6,                                                                       "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"12CE1A82-93A9-4839-948A-E3F8FD51C9FE",    "Date":"2 days ago", "CollectTime":"1 days ago 102252", "Val.Mode":"CPAP",    "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":4.4, "Val.Leak.Max":4.6,                                                                       "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"12CE1A82-93A9-4839-948A-E3F8FD51C9FE",    "Date":"1 day ago",  "CollectTime":"today 010101",      "Val.Mode":"CPAP",    "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":4.4, "Val.Leak.Max":4.6,                                                                       "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
    When I send the therapy summaries from 3 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | THERAPY_SUMMARY | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId":"12CE1A82-93A9-4839-948A-E3F8FD51C9FE",    "Date":"3 days ago", "CollectTime":"2 days ago 090100", "Val.Mode":"CPAP",    "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":4.4, "Val.Leak.Max":4.6,                                                                       "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
    When I send the therapy summaries from 2 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | THERAPY_SUMMARY | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId":"12CE1A82-93A9-4839-948A-E3F8FD51C9FE",    "Date":"2 days ago", "CollectTime":"1 days ago 102252", "Val.Mode":"CPAP",    "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":4.4, "Val.Leak.Max":4.6,                                                                       "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
    When I send the therapy summaries from 1 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | THERAPY_SUMMARY | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId":"12CE1A82-93A9-4839-948A-E3F8FD51C9FE",    "Date":"1 day ago",  "CollectTime":"today 010101",      "Val.Mode":"CPAP",    "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":4.4, "Val.Leak.Max":4.6,                                                                       "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |

  @autoset.comfort.S5 @summary @summary.usage @valid.against.subscription
  @ECO-4678.1 @ECO-4678.2
  @ECO-4768.1 @ECO-4768.3
  @ECO-4848.1 @ECO-4848.2
  @ECO-5874.1
  Scenario: Summary service responds with OK for good data and empty data
     # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_12A64E97-6E6F-4C18-A78D-7844A827BF28.json |
    And these devices have the following therapy summaries
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"12A64E97-6E6F-4C18-A78D-7844A827BF28", "Date":"3 days ago", "CollectTime":"2 days ago 090100", "Val.Mode":"AutoSet", "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":4.4, "Val.Leak.Max":4.6, "Val.TgtIPAP.50":12.4, "Val.TgtIPAP.95":13.0, "Val.TgtIPAP.Max":14.8, "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"12A64E97-6E6F-4C18-A78D-7844A827BF28", "Date":"2 days ago", "CollectTime":"1 days ago 102252", "Val.Mode":"AutoSet", "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":4.4, "Val.Leak.Max":4.6, "Val.TgtIPAP.50":12.4, "Val.TgtIPAP.95":13.0, "Val.TgtIPAP.Max":14.8, "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId":"12A64E97-6E6F-4C18-A78D-7844A827BF28", "Date":"1 day ago",  "CollectTime":"today 010101",      "Val.Mode":"AutoSet", "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":4.4, "Val.Leak.Max":4.6, "Val.TgtIPAP.50":12.4, "Val.TgtIPAP.95":13.0, "Val.TgtIPAP.Max":14.8, "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
    When I send the therapy summaries from 3 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | THERAPY_SUMMARY | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId":"12A64E97-6E6F-4C18-A78D-7844A827BF28", "Date":"3 days ago", "CollectTime":"2 days ago 090100", "Val.Mode":"AutoSet", "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":4.4, "Val.Leak.Max":4.6, "Val.TgtIPAP.50":12.4, "Val.TgtIPAP.95":13.0, "Val.TgtIPAP.Max":14.8, "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
    When I send the therapy summaries from 2 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | THERAPY_SUMMARY | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId":"12A64E97-6E6F-4C18-A78D-7844A827BF28", "Date":"2 days ago", "CollectTime":"1 days ago 102252", "Val.Mode":"AutoSet", "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":4.4, "Val.Leak.Max":4.6, "Val.TgtIPAP.50":12.4, "Val.TgtIPAP.95":13.0, "Val.TgtIPAP.Max":14.8, "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
    When I send the therapy summaries from 1 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | THERAPY_SUMMARY | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId":"12A64E97-6E6F-4C18-A78D-7844A827BF28", "Date":"1 day ago",  "CollectTime":"today 010101",      "Val.Mode":"AutoSet", "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":4.4, "Val.Leak.Max":4.6, "Val.TgtIPAP.50":12.4, "Val.TgtIPAP.95":13.0, "Val.TgtIPAP.Max":14.8, "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |

  @autoset.comfort.S6 @settings @settings.therapy @valid.against.subscription
  @ECO-4684.1 @ECO-4684.2
  @ECO-5879.1
  @ECO-5874.1
  Scenario: Update Autoset Comfort settings data wirelessly for CPAP mode
     # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_23268714-645A-4A38-85C3-AE691D62907A.json |
    And these devices have the following therapy settings
      | json                                                                                                                                                                                                                                                                                                                                                                        |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "23268714-645A-4A38-85C3-AE691D62907A", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Mode": "CPAP","CPAP.Val.Press":12.3,"CPAP.Val.StartPress":8.1,"CPAP.Val.EPR.EPREnable":"On","CPAP.Val.EPR.EPRType":"FullTime","CPAP.Val.EPR.Level":2,"CPAP.Val.Ramp.RampEnable":"Off","CPAP.Val.Ramp.RampTime":0 } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "23268714-645A-4A38-85C3-AE691D62907A", "Date": "2 days ago", "CollectTime": "1 days ago 102252", "Val.Mode": "CPAP","CPAP.Val.Press":12.4,"CPAP.Val.StartPress":8.2,"CPAP.Val.EPR.EPREnable":"On","CPAP.Val.EPR.EPRType":"FullTime","CPAP.Val.EPR.Level":2,"CPAP.Val.Ramp.RampEnable":"Off","CPAP.Val.Ramp.RampTime":0 } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "23268714-645A-4A38-85C3-AE691D62907A", "Date": "1  day ago", "CollectTime": "today      010101", "Val.Mode": "CPAP","CPAP.Val.Press":12.5,"CPAP.Val.StartPress":8.3,"CPAP.Val.EPR.EPREnable":"On","CPAP.Val.EPR.EPRType":"FullTime","CPAP.Val.EPR.Level":2,"CPAP.Val.Ramp.RampEnable":"Off","CPAP.Val.Ramp.RampTime":0 } |
    When I send the therapy settings from 3 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                        |
      | THERAPY_SETTING | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId": "23268714-645A-4A38-85C3-AE691D62907A", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Mode": "CPAP","CPAP.Val.Press":12.3,"CPAP.Val.StartPress":8.1,"CPAP.Val.EPR.EPREnable":"On","CPAP.Val.EPR.EPRType":"FullTime","CPAP.Val.EPR.Level":2,"CPAP.Val.Ramp.RampEnable":"Off","CPAP.Val.Ramp.RampTime":0 } |
    When I send the therapy settings from 2 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                        |
      | THERAPY_SETTING | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId": "23268714-645A-4A38-85C3-AE691D62907A", "Date": "2 days ago", "CollectTime": "1 days ago 102252", "Val.Mode": "CPAP","CPAP.Val.Press":12.4,"CPAP.Val.StartPress":8.2,"CPAP.Val.EPR.EPREnable":"On","CPAP.Val.EPR.EPRType":"FullTime","CPAP.Val.EPR.Level":2,"CPAP.Val.Ramp.RampEnable":"Off","CPAP.Val.Ramp.RampTime":0 } |
    When I send the therapy settings from 1 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                        |
      | THERAPY_SETTING | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId": "23268714-645A-4A38-85C3-AE691D62907A", "Date": "1  day ago", "CollectTime": "today      010101", "Val.Mode": "CPAP","CPAP.Val.Press":12.5,"CPAP.Val.StartPress":8.3,"CPAP.Val.EPR.EPREnable":"On","CPAP.Val.EPR.EPRType":"FullTime","CPAP.Val.EPR.Level":2,"CPAP.Val.Ramp.RampEnable":"Off","CPAP.Val.Ramp.RampTime":0 } |

  @autoset.comfort.S7 @settings @settings.therapy @valid.against.subscription
  @ECO-4706.1 @ECO-4706.2
  @ECO-5879.1
  @ECO-5874.1
  Scenario: Update Autoset Comfort settings data wirelessly for AutoSet mode
     # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_21C219CD-EB66-43E7-B677-50E858BB851B.json |
    And these devices have the following therapy settings
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "21C219CD-EB66-43E7-B677-50E858BB851B", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Mode": "AutoSet","AutoSet.Val.MinPress":8.0,"AutoSet.Val.MaxPress":14.0,"AutoSet.Val.StartPress":10.0,"AutoSet.Val.EPR.EPREnable":"On","AutoSet.Val.EPR.EPRType":"Ramp","AutoSet.Val.EPR.Level":2,"AutoSet.Val.Ramp.RampEnable":"Auto","AutoSet.Val.Ramp.RampTime":30,"AutoSet.Val.Comfort":"Off" } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "21C219CD-EB66-43E7-B677-50E858BB851B", "Date": "2 days ago", "CollectTime": "1 days ago 102252", "Val.Mode": "AutoSet","AutoSet.Val.MinPress":8.1,"AutoSet.Val.MaxPress":14.1,"AutoSet.Val.StartPress":10.1,"AutoSet.Val.EPR.EPREnable":"On","AutoSet.Val.EPR.EPRType":"Ramp","AutoSet.Val.EPR.Level":2,"AutoSet.Val.Ramp.RampEnable":"Auto","AutoSet.Val.Ramp.RampTime":30,"AutoSet.Val.Comfort":"Off" } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "21C219CD-EB66-43E7-B677-50E858BB851B", "Date": "1  day ago", "CollectTime": "today      010101", "Val.Mode": "AutoSet","AutoSet.Val.MinPress":8.2,"AutoSet.Val.MaxPress":14.2,"AutoSet.Val.StartPress":10.2,"AutoSet.Val.EPR.EPREnable":"On","AutoSet.Val.EPR.EPRType":"Ramp","AutoSet.Val.EPR.Level":2,"AutoSet.Val.Ramp.RampEnable":"Auto","AutoSet.Val.Ramp.RampTime":30,"AutoSet.Val.Comfort":"Off" } |
    When I send the therapy settings from 3 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | THERAPY_SETTING | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId": "21C219CD-EB66-43E7-B677-50E858BB851B", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Mode": "AutoSet","AutoSet.Val.MinPress":8.0,"AutoSet.Val.MaxPress":14.0,"AutoSet.Val.StartPress":10.0,"AutoSet.Val.EPR.EPREnable":"On","AutoSet.Val.EPR.EPRType":"Ramp","AutoSet.Val.EPR.Level":2,"AutoSet.Val.Ramp.RampEnable":"Auto","AutoSet.Val.Ramp.RampTime":30,"AutoSet.Val.Comfort":"Off" } |
    When I send the therapy settings from 2 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | THERAPY_SETTING | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId": "21C219CD-EB66-43E7-B677-50E858BB851B", "Date": "2 days ago", "CollectTime": "1 days ago 102252", "Val.Mode": "AutoSet","AutoSet.Val.MinPress":8.1,"AutoSet.Val.MaxPress":14.1,"AutoSet.Val.StartPress":10.1,"AutoSet.Val.EPR.EPREnable":"On","AutoSet.Val.EPR.EPRType":"Ramp","AutoSet.Val.EPR.Level":2,"AutoSet.Val.Ramp.RampEnable":"Auto","AutoSet.Val.Ramp.RampTime":30,"AutoSet.Val.Comfort":"Off" } |
    When I send the therapy settings from 1 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | THERAPY_SETTING | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId": "21C219CD-EB66-43E7-B677-50E858BB851B", "Date": "1  day ago", "CollectTime": "today      010101", "Val.Mode": "AutoSet","AutoSet.Val.MinPress":8.2,"AutoSet.Val.MaxPress":14.2,"AutoSet.Val.StartPress":10.2,"AutoSet.Val.EPR.EPREnable":"On","AutoSet.Val.EPR.EPRType":"Ramp","AutoSet.Val.EPR.Level":2,"AutoSet.Val.Ramp.RampEnable":"Auto","AutoSet.Val.Ramp.RampTime":30,"AutoSet.Val.Comfort":"Off" } |

  @autoset.comfort.S8 @settings @settings.therapy
  @ECO-4690.1 @ECO-4690.2 @ECO-4690.3
  Scenario: Obtain the most recent therapy settings request for Autoset Comfort (CPAP mode)
    And the server has the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "20070811223", "SettingsId": "CPAPSettings01","Set.Mode": "CPAP","CPAP.Set.Press":14.0,"CPAP.Set.StartPress":8.0,"CPAP.Set.EPR.EPREnable":"On","CPAP.Set.EPR.EPRType":"FullTime","CPAP.Set.EPR.Level":2,"CPAP.Set.Ramp.RampEnable":"On","CPAP.Set.Ramp.RampTime":30 } |
    When I request the therapy settings with identifier "CPAPSettings01"
    Then I should receive the following therapy settings
      | json                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "20070811223", "SettingsId": "CPAPSettings01","Set.Mode": "CPAP","CPAP.Set.Press":14.0,"CPAP.Set.StartPress":8.0,"CPAP.Set.EPR.EPREnable":"On","CPAP.Set.EPR.EPRType":"FullTime","CPAP.Set.EPR.Level":2,"CPAP.Set.Ramp.RampEnable":"On","CPAP.Set.Ramp.RampTime":30 } |

  @autoset.comfort.S9 @settings @settings.thearpy
  @ECO-4729.1 @ECO-4729.2 @ECO-4729.3
  Scenario: Obtain the most recent therapy settings request for Autoset Comfort (AutoSet mode)
    And the server has the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                        |
      | { "FG.SerialNo": "20070811223", "SettingsId": "AutoSetSettings01", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" } |
    When I request the therapy settings with identifier "AutoSetSettings01"
    Then I should receive the following therapy settings
      | json                                                                                                                                                                                                                                                                                                                                                                                        |
      | { "FG.SerialNo": "20070811223", "SettingsId": "AutoSetSettings01", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" } |

  @autoset.comfort.S10 @settings @settings.climate @valid.against.subscription
  @ECO-4860.1 @ECO-4860.2 @ECO-4860.3
  @ECO-5879.1
  @ECO-5874.1
  Scenario: Update Autoset Comfort climate settings data wirelessly
     # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_301E6C6C-A3C3-44B9-99D4-171A99FE6BD5.json |
    And these devices have the following climate settings
      | json                                                                                                                                                                                                                                                                                                                                       |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 5, "Val.TempEnable": "Off", "Val.Temp": 28, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "2 days ago", "CollectTime": "1 days ago 112039", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 8, "Val.TempEnable": "On",  "Val.Temp": 23, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "1 day ago",  "CollectTime": "today      094703", "Val.ClimateControl": "Auto", "Val.HumEnable": "Off", "Val.HumLevel": 6, "Val.TempEnable": "Off", "Val.Temp": 25, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |
    When I send the climate settings from 3 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                       |
      | CLIMATE_SETTING | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 5, "Val.TempEnable": "Off", "Val.Temp": 28, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |
    When I send the climate settings from 2 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                       |
      | CLIMATE_SETTING | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "2 days ago", "CollectTime": "1 days ago 112039", "Val.ClimateControl": "Auto", "Val.HumEnable": "On",  "Val.HumLevel": 8, "Val.TempEnable": "On",  "Val.Temp": 23, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |
    When I send the climate settings from 1 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType         | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                       |
      | CLIMATE_SETTING | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "1 day ago",  "CollectTime": "today      094703", "Val.ClimateControl": "Auto", "Val.HumEnable": "Off", "Val.HumLevel": 6, "Val.TempEnable": "Off", "Val.Temp": 25, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |

  @autoset.comfort.S11 @settings @settings.therapy @settings.acknowledgement @invalid.against.subscription
  @ECO-5880.1
  @ECO-5874.1
  Scenario: Send RemoteMod acknowledgement with Autoset Comfort settings data wirelessly.  CPAP mode.  The message should not end up on the queue for therapy session.
     # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_28D54873-A79C-47A5-A08F-D55D979418F0.json |
    And these devices have the following therapy settings
      | json                                                                                                                                                                                                                                                                                                                                                                        |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "28D54873-A79C-47A5-A08F-D55D979418F0", "Date": "0  day ago", "CollectTime": "today      010101", "Set.Mode": "CPAP","CPAP.Set.Press":12.5,"CPAP.Set.StartPress":8.3,"CPAP.Set.EPR.EPREnable":"On","CPAP.Set.EPR.EPRType":"FullTime","CPAP.Set.EPR.Level":2,"CPAP.Set.Ramp.RampEnable":"Off","CPAP.Set.Ramp.RampTime":0 } |
    When I send the therapy settings from 0 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                        |
      | THERAPY_SETTING_ACKNOWLEDGMENT | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId": "28D54873-A79C-47A5-A08F-D55D979418F0", "Date": "0  day ago", "CollectTime": "today      010101", "Set.Mode": "CPAP","CPAP.Set.Press":12.5,"CPAP.Set.StartPress":8.3,"CPAP.Set.EPR.EPREnable":"On","CPAP.Set.EPR.EPRType":"FullTime","CPAP.Set.EPR.Level":2,"CPAP.Set.Ramp.RampEnable":"Off","CPAP.Set.Ramp.RampTime":0 } |


  @autoset.comfort.S12 @settings @settings.therapy @settings.acknowledgement @invalid.against.subscription
  @ECO-5880.1
  @ECO-5874.1
  Scenario: Send RemoteMod acknowledgement with Autoset Comfort settings data wirelessly.  AutoSet mode. The message should not end up on the queue for therapy session.
     # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_2896C763-FE94-4B3F-AD6C-305583FD4210.json |
    And these devices have the following therapy settings
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "2896C763-FE94-4B3F-AD6C-305583FD4210", "Date": "0 day ago", "CollectTime": "today      010101", "Set.Mode": "AutoSet","AutoSet.Set.MinPress":8.2,"AutoSet.Set.MaxPress":14.2,"AutoSet.Set.StartPress":10.2,"AutoSet.Set.EPR.EPREnable":"On","AutoSet.Set.EPR.EPRType":"Ramp","AutoSet.Set.EPR.Level":2,"AutoSet.Set.Ramp.RampEnable":"Auto","AutoSet.Set.Ramp.RampTime":30,"AutoSet.Set.Comfort":"Off" } |
    When I send the therapy settings from 0 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | THERAPY_SETTING_ACKNOWLEDGMENT | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId": "2896C763-FE94-4B3F-AD6C-305583FD4210", "Date": "0 day ago", "CollectTime": "today      010101", "Set.Mode": "AutoSet","AutoSet.Set.MinPress":8.2,"AutoSet.Set.MaxPress":14.2,"AutoSet.Set.StartPress":10.2,"AutoSet.Set.EPR.EPREnable":"On","AutoSet.Set.EPR.EPRType":"Ramp","AutoSet.Set.EPR.Level":2,"AutoSet.Set.Ramp.RampEnable":"Auto","AutoSet.Set.Ramp.RampTime":30,"AutoSet.Set.Comfort":"Off" } |

  @autoset.comfort.S13 @settings @settings.therapy @settings.acknowledgement  @invalid.against.subscription
  @ECO-5880.1
  @ECO-5874.1
  Scenario: Send invalid RemoteMod acknowledgement with Autoset Comfort settings data wirelessly.  The message should not end up on any queue.
     # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_2896C763-FE94-4B3F-AD6C-305583FD4210.json |
    And these devices have the following therapy settings
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "2896C763-FE94-4B3F-AD6C-305583FD4210", "Date": "0  day ago", "CollectTime": "today      010101", "AutoSet.Set.MinPress":8.2,"AutoSet.Set.MaxPress":14.2,"AutoSet.Set.StartPress":10.2,"AutoSet.Set.EPR.EPREnable":"On","AutoSet.Set.EPR.EPRType":"Ramp","AutoSet.Set.EPR.Level":2,"AutoSet.Set.Ramp.RampEnable":"Auto","AutoSet.Set.Ramp.RampTime":30,"AutoSet.Set.Comfort":"Off" } |
    When I send the therapy settings from 0 days ago
    Then I should receive a server ok response
    And the server should log a therapy settings acknowledgment error
      | ValidationVetoPoint  | ValidationFailureType | ValidationFailureReason |
      | UNKNOWN_SETTING_TYPE |                       |                         |
    And no device data received events have been published


  @autoset.comfort.S14 @settings @settings.climate @settings.acknowledgement @invalid.against.subscription
  @ECO-4860.1 @ECO-4860.2 @ECO-4860.3
  @ECO-5880.1
  @ECO-5874.1
  Scenario: Send RemoteMod acknowledgement with Autoset Comfort climate settings data wirelessly. The message should not end up on the queue for therapy session.
     # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_30B59434-BF4F-4788-9678-A00FF860C038.json |
    And these devices have the following climate settings
      | json                                                                                                                                                                                                                                                                                                                                       |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "0 day ago",  "CollectTime": "today      094703", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
    When I send the climate settings from 0 days ago
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType                        | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                                                                                                                       |
      | CLIMATE_SETTING_ACKNOWLEDGMENT | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "0 day ago",  "CollectTime": "today      094703", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |


  @autoset.comfort.S15 @settings @settings.climate @settings.acknowledgement @invalid.against.subscription
  @ECO-4860.1 @ECO-4860.2 @ECO-4860.3
  @ECO-5880.1
  @ECO-5874.1
  Scenario: Send invalid RemoteMod acknowledgement with Autoset Comfort climate settings data wirelessly. The message should not end up on any queue.
      # Deprecated
    Given the following subscriptions are loaded into NGCS
      | /data/subscription_30B59434-BF4F-4788-9678-A00FF860C038.json |
    And these devices have the following climate settings
      | json                                                                                                                                                                                                                                                                                                         |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "30B59434-BF4F-4788-9678-A00FF860C038", "Date": "0 day ago",  "CollectTime": "today      094703", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
    When I send the climate settings from 0 days ago
    Then I should receive a server ok response
    And the server should log a climate settings acknowledgment error
      | ValidationVetoPoint  | ValidationFailureType | ValidationFailureReason |
      | UNKNOWN_SETTING_TYPE |                       |                         |
    And no device data received events have been published
