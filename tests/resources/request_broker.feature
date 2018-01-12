@cam
@newport
@newport.broker
@newport.broker.flowgen
@ECO-4687
@ECO-4776
@ECO-4779
@ECO-5581
@ECO-5571
@ECO-5884
@ECO-5789
@ECO-6140
@ECO-6268
@ECO-6607
@ECO-7322
@ECO-8222
@ECO-6248
@ECO-4833

Feature:
  (ECO-4687) As a user
  I want a device to be contacted when there is a change in subscription
  so that the device can start making changes or sending information immediately

  (ECO-4776) As a clinical user
  I want ECO to deliver requests to the device when needed
  In order that I can update settings, change subscriptions and update software remotely in the field.

  (ECO-4779) As a user
  I want a device to be contacted when there is a requested change of settings
  so that the new prescription can be applied tonight

  (ECO-5581) As ECO
  I want to be able to receive CAM subscriptions on registration
  so that registration operations do not fail

  (ECO-5571) As ECO
  I want to resend an SMS to a device
  so that I can establish communications with it

  (ECO-5572) As EU ECO
  I want to send an SMS to an S10 device
  so that it can establish communications

  (ECO-5884) As an clinical user
  I only want data copied to a patient since the device was last erased
  so that I do not see data for previous patients

  (ECO-5789) As a clinical user
  I want ECO to cancel any outstanding wireless settings if I remove the device from the patient
  so that the settings cannot be accidentally applied to a subsequent patient

  (ECO-6140) Race condition when an S10 device is reassigned to a patient

  (ECO-6268) As a clinical user
  I want ECO to cancel any outstanding silent mode configuration messages when a patient has
  been assigned to a device
  in order that the device does not get inadvertanly placed into silent mode

  (ECO-6607) As a Newport Device,
  I want an HTTP response code that indicates I should register and then retry my request
  so that I stop assuming all is fine.

  (ECO-7322) As ECO
  I want to cancel any outstanding requests for a scrapped Flow Gen
  so that I do not clutter my request broker.

  (ECO-8222) As ECO
  I want to prevent any new requests for a scrapped Flow Gen
  so that I do not clutter my request broker.

  (ECO-6248) As NGCS
  I want to reject requests for serial numbers I don't support
  so that I don't send wasteful SMS messages

  (ECO-4833) As a clinician,
  I would like requests to be removed from the request broker when they are received by the device
  so they do not get delivered a second time

  # ACCEPTANCE CRITERIA: (ECO-4687)
  # 1. If NGCS is has a new subscription for a Newport device, then NGCS shall notify the device to contact the server for the subscription.
  # Note 1: It is assumed that the Twilio API will be used to send an SMS to the device. Initially the content of the SMS is not important.
  # Note 2: It can be assumed that any SIM in the device is already active and that the phone number of the device is known.
  # Note 3: It can be assumed that there is no difference for the US, Canada or EU presently

  # ACCEPTANCE CRITERIA: (ECO-4776)
  # 1. When a request to change settings for a device is received then the request broker shall queue the request for the device.
  # 2. When a request to change subscription for a device is received then the request broker shall queue the request for the device.
  # 3. When a request to upgrade software for a device is received then the request broker shall queue the request for the device.
  # 4. When any request is queued for a device then an SMS shall be sent to the device.
  # 5. The request broker shall return the list of queued requests (FIFO) to the device when the device queries the request broker.
  # 6. A request queued for a specific device shall be provided only to that device. Note 1: this will be done using a unique identifier for the request.
  # 7. If the device has never registered then an error shall be returned to the device when it queries the request broker.
  # 8. The request broker shall return an error if a request is attempted to be queued for an unknown device.
  # Note 1: Protocol details: http://confluence.corp.resmed.org/display/CA/Requests+-+new
  # Note 2: The messages delivered to the broker are assumed to be correct. This card will not validate the content.

  # ACCEPTANCE CRITERIA: (ECO-4779)
  # 1. If NGCS has a new requested change for a Newport device, then NGCS shall notify the device to contact the server in order to change the settings on the device.
  # Note 1: It is assumed that the Twilio API will be used to send an SMS to the device. Initially the content of the SMS is not important.
  # Note 2: It can be assumed that any SIM in the device is already active and that the phone number of the device is known.
  # Note 3: It can be assumed that there is no difference for the US, Canada or EU presently

  # ACCEPTANCE CRITERIA: (ECO-5581)
  # 1. CAM subscription information during Registration should be able to be received as per http://confluence.corp.resmed.org/x/YwGz
  #
  # Note 1: It is not necessary at this stage to do anything with the CAM subscription information. The important thing is to prevent all registrations failing.

  # ACCEPTANCE CRITERIA: (ECO-5571)
  # Note 1: This story extends ECO-4776 AC#4 by implementing a retry on SMS
  # 1. If an SMS has been sent to an S10 device due to a request being added to the request broker and the S10 device has not acknowledged the request in n days, a new SMS shall be sent.
  # 1a. On the Vodafone network, the number of days n shall be 7 days. Note 2: the new SMS should be a replacement to the previously sent SMS, rather than a new one.
  # 1b. On the Aeris network, the number of days n shall be 3 days.
  # Note 3: There is no limit currently placed on the number of retries.

  # ACCEPTANCE CRITERIA: (ECO-5572)
  # 1. When an S10 device is added to a patient and the device's CAM is in a silent state at time of manufacture (see note 4), an SMS shall be sent to the device. Note 1: On the Vodafone network, this may be accomplished using a wake-up trigger.
  # Note 3: Due to privacy regulations in the EU, a device cannot post data to ECO without having consent from the patient. Thus these EU devices are set to a "silent" mode at manufacture and the addition of the device to an ECO patient constitutes consent to collecting data.
  # Note 4: The silent state may be determined by the field CamSilentState as indicated in D379-513.

  # ACCEPTANCE CRITERIA: (ECO-5884)
  # 1. The last erase date shall be received from Newport devices and stored.
  # Note 1: The "Erases" interface described at http://confluence.corp.resmed.org/display/CA/Wireless+Protocol should be used for this purpose

  # ACCEPTANCE CRITERIA: (ECO-5789)
  # Note 1: For S9 devices CAL cancels settings requests when a schedule is cancelled as per ECO-1541.  This story provides equivalent functionality for Newport devices
  # 1. When a Newport therapy device is removed from a patient then any wireless settings change requests awaiting collection by the device shall be deleted.  Note: This applies even if the device is being implicitely removed such as when the device is added to patient B and removed from patient A after confirmation.
  # Note 2: The settings and settings status (i.e. changes pending) are not shown in the Prescription panel if the patient does not have a device.  It is assumed that if this device or another was added back to the patient after removal then the settings status would not still show that changes are pending.

  # ACCEPTANCE CRITERIA: (ECO-6140)
  # When an S10 Newport device is reassigned to a patient, ECO publishes both device activation event and device unassigned event to the corresponding topics, one for the newly assigned device and the other for the unassignment. The intention in reassignment case is that we first want to unassign the device (and put it back to silent state for EU) and then to activate the device (and wake up for EU).
  # However, due to the asynchronous nature of the event driven communication model, there is no guarantee for the order of the processing of these events. Therefore, when the device unassigment event is processed after the activation, the device will be considered inactive and new settings requests(if any) will be cancelled along with the old ones. In addition, in EU case the device will also be put to silent mode, even though it's expected to be in active mode.

  # ACCEPTANCE CRITERIA: (ECO-6268)
  # 1. When an S10 device is added to a patient and the device's CAM is in a silent state at time of manufacture (see note 2), then any queued request to return the device to silent mode that has not yet been collected shall be deleted.
  # Note 1: This extends ECO-5572 AC#1
  # Note 2: The silent state at time of manufacture may be determined by the field CamSilentState as indicated in D379-513.

  # ACCEPTANCE CRITERIA: (ECO-6607)
  # Note 1: This story relates to the NGCS to CAM interface interface.
  # 1. ECO shall return a 424 HTTP response code for a device request if the device has no recorded registration. Note 2: Message authentication must succeed first.

  # ACCEPTANCE CRITERIA: (ECO-7322)
  # Note 1: This story extends ECO-6090
  # 1. On successful scrap of a Flow Gen per ECO-6090, all outstanding requests for this Flow Gen shall be cancelled. Note: This includes settings, subscriptions, climate settings and config change requests

  # ACCEPTANCE CRITERIA: (ECO-8222)
  # Note 1: ECO-7322 cancels all existing requests for a FlowGen when it is scrapped. This story prevents further requests from being queued on the broker for the device.
  # 1. On successful scrap of a Flow Gen per ECO-6090, all future requests for this Flow Gen shall be blocked. Note: This includes settings, subscriptions, climate settings and config change requests

  # ACCEPTANCE CRITERIA: (ECO-6248)
  # Note 1: This story adds functionality so that installations of ECO won't attempt to communicate with devices that are managed by a different installation of ECO.
  # Note 2: Whether a device is managed by an instance of ECO can be determined from its regionID, which comes through from manufacturing.
  # Note 3: Region IDs supported by installation are defined in DevOps cards such as DEV-348 and DEV-1103 and currently exist in exchange.properties as regions.managed.us and regions.managed.eu. See DEV-1555.
  # Note 4: This card should involve moving the 'is region supported' logic to NGCS rather than ECX2. Already DONE by ECO-9144.
  # 1. ECO installations shall attempt to communicate with a device only if it is managed by that installation of AirView. Note: This means not sending SMS messages, and not putting messages on the broker.

  # ACCEPTANCE CRITERIA: (ECO-4833)
  # 1. When the device acknowledges a subscription request then that request shall be removed from the request broker.
  # 2. When the device acknowledges a settings change request then that request shall be removed from the request broker.
  # 3. When the device acknowledges a software upgrade request then that request shall be removed from the request broker.
  # Note 1: Protocol details: See subscription, settings, software upgrade etc at http://confluence.corp.resmed.org/display/CA/Wireless+Protocol+-+new
  #
  # PUT /api/v1/subscriptions/{uuid-D}/status HTTP/1.1
  # X-CamSerialNo: {serial number}
  # X-Hash: {hash}
  # {
  # "FG.SerialNo": "{serial number}",
  # "SubscriptionId": "{uuid-D}",
  # "Status": "(Received|*Failure)"
  # }

  Background:
    Given devices with following properties have been manufactured
      | moduleSerial | internalCommModule | authKey      | flowGenSerial | deviceNumber | mid | vid | pcbaSerialNo | regionId | productCode |
      | 31213252843  | true               | 312023494168 | 31181922334   | 124          | 36  | 26  | 124124124    | 1        | 9745        |
    And the server receives the following manufacturing unit detail
      | resource                                                                                                        |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111111112_cam11111111112_new.xml  |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111111111_cam11111111111_new.xml  |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg20070811223_cam20102141732_new.xml |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111114444_cam11111114444_new.xml |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg88800000001_cam88810000001_new.xml |
    And the server waits for the device manufactured queue to be empty
    And the server should not produce device manufactured error

  @newport.broker.S1
  @ECO-4687.1
  @ECO-4776.1 @ECO-4776.2 @ECO-4776.3 @ECO-4776.4
  @ECO-4779.1
  @ECO-5581.1
  @ECO-5884.1
  Scenario: The broker messages are put on the request broker and sends an SMS.
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    When the server is given the following climate settings to be sent to devices
      | json                                                                                                                                                                                                                                                                         |
      | { "FG.SerialNo": "88800000001", "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
    Then I should receive a response code of "200"
    And I should eventually receive a call home SMS within 10 seconds
    When the server is given the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | { "FG.SerialNo": "88800000001", "SubscriptionId":"E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
    Then I should receive a response code of "200"
    And I should eventually receive a call home SMS within 10 seconds

    When the server is given the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                           |
      | { "FG.SerialNo": "88800000001", "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" } |
    Then I should receive a response code of "200"
    Then I should eventually receive a call home SMS within 10 seconds
    When the server is given the following upgrades to be sent to devices
      | json                                                                                                                                                                                                           |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
    Then I should receive a response code of "200"
    Then I should eventually receive a call home SMS within 10 seconds
     # Device Erasure Subscription
    When the server is given the following upgrades to be sent to devices
      | json                                                                                                                                                                                             |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "MyErasure", "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "OnlyOnChange": true }, "Data": [ "Val.LastEraseDate" ] } |
    Then I should receive a response code of "200"
    Then I should eventually receive a call home SMS within 10 seconds

  @newport.broker.S2
  @ECO-4776.1 @ECO-4776.2 @ECO-4776.3 @ECO-4776.5 @ECO-4776.6
  @ECO-5581.1
  @ECO-5884.1
  Scenario: The messages are retrievable after being put on the request broker.
    Given the server has the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                        |
      | { "FG.SerialNo": "20070811223", "SettingsId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7", "Set.Mode": "CPAP", "CPAP.Set.Press": 14.0, "CPAP.Set.StartPress": 8.0, "CPAP.Set.EPR.EPREnable": "On", "CPAP.Set.EPR.EPRType": "FullTime", "CPAP.Set.EPR.Level": 2, "CPAP.Set.Ramp.RampEnable": "On", "CPAP.Set.Ramp.RampTime": 30 } |
    And the server has the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | { "FG.SerialNo": "31181922334", "SubscriptionId": "3E05F22E-F1B1-4BA4-A89D-01398C41F775", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.TgtIPAP.50", "Val.TgtIPAP.95", "Val.TgtIPAP.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "7E293B00-9396-48A8-945E-A61712BAD67E", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max",                                                        "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "02ea52a6-b826-4749-ae9b-8c5fbc7d43c5",  "ServicePoint": "/api/v1/erasures",         "Trigger": { "Collect": [ "HALO" ], "OnlyOnChange": true }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                          |
    And the server has the following upgrades to be sent to devices
      | json                                                                                                                                                                                                          |
      | { "FG.SerialNo": "20070811223", "UpgradeId": "CD4FF71B-E2A2-412F-8489-2A2FEB95DC28", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin", "Size": 9876, "CRC": "C7D2" } |
      | { "FG.SerialNo": "31181922334", "UpgradeId": "80302685-93BA-494F-AFFD-B27AEC759635", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin", "Size": 9876, "CRC": "C7D2" } |
    And the server has the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                  |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "31BEBCC4-4D33-4C0E-A52F-906650EED227", "ServicePoint":"/api/v1/faults",            "Trigger": { "Collect": [ "HALO", "Now" ], "OnlyOnChange": true },          "Data":[ "Fault.Device", "Fault.Humidifier", "Fault.HeatedTube" ] } |
    And the server has the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                           |
      | { "FG.SerialNo": "31181922334", "SettingsId": "9E66F8DA-0428-4FFE-B035-766DAB96621C", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" } |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                               |
      | { "FG": {"SerialNo": "20070811223", "Software": "FGABCDEFH", "MID": 36, "VID": 26, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "20102141732", "Software": "CAMABCDEFH", "PCBASerialNo":"123123123", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    Then by requesting messages for FG "20070811223" by myself I should eventually receive the following results in 30 seconds
      | URI Fixed Part            | Content Identifier                   |
      | /api/v1/therapy/settings/ | DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7 |
      | /api/v1/subscriptions/    | 7E293B00-9396-48A8-945E-A61712BAD67E |
      | /api/v1/subscriptions/    | 02ea52a6-b826-4749-ae9b-8c5fbc7d43c5 |
      | /api/v1/upgrades/         | CD4FF71B-E2A2-412F-8489-2A2FEB95DC28 |
      | /api/v1/subscriptions/    | 31BEBCC4-4D33-4C0E-A52F-906650EED227 |
    Given I am a device with the FlowGen serial number "31181922334"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                               |
      | { "FG": {"SerialNo": "31181922334", "Software": "FGABCDEFH", "MID": 36, "VID": 26, "PCBASerialNo":"3A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "31213252843", "Software": "CAMABCDEFH", "PCBASerialNo":"124124124", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    Then by requesting messages for FG "31181922334" by myself I should eventually receive the following results in 30 seconds
      | URI Fixed Part            | Content Identifier                   |
      | /api/v1/subscriptions/    | 3E05F22E-F1B1-4BA4-A89D-01398C41F775 |
      | /api/v1/upgrades/         | 80302685-93BA-494F-AFFD-B27AEC759635 |
      | /api/v1/therapy/settings/ | 9E66F8DA-0428-4FFE-B035-766DAB96621C |
    Given I am a device with the FlowGen serial number "20070811223"
    Then by requesting messages for FG "20070811223" by myself I should eventually receive the following results in 30 seconds
      | URI Fixed Part            | Content Identifier                   |
      | /api/v1/therapy/settings/ | DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7 |
      | /api/v1/subscriptions/    | 7E293B00-9396-48A8-945E-A61712BAD67E |
      | /api/v1/subscriptions/    | 02ea52a6-b826-4749-ae9b-8c5fbc7d43c5 |
      | /api/v1/upgrades/         | CD4FF71B-E2A2-412F-8489-2A2FEB95DC28 |
      | /api/v1/subscriptions/    | 31BEBCC4-4D33-4C0E-A52F-906650EED227 |
    Given I am a device with the FlowGen serial number "31181922334"
    Then by requesting messages for FG "31181922334" by myself I should eventually receive the following results in 30 seconds
      | URI Fixed Part            | Content Identifier                   |
      | /api/v1/subscriptions/    | 3E05F22E-F1B1-4BA4-A89D-01398C41F775 |
      | /api/v1/upgrades/         | 80302685-93BA-494F-AFFD-B27AEC759635 |
      | /api/v1/therapy/settings/ | 9E66F8DA-0428-4FFE-B035-766DAB96621C |

  @newport.broker.S3
  @ECO-4776.7
  @ECO-6607.1
  Scenario: Known and unregistered device requests messages
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    When I request my broker requests
    Then I should receive a response code of "424"

  @newport.broker.S4
  @ECO-4776.7
  @ECO-5581.1
  Scenario: Known and registered device requests messages
    And I am a device with the FlowGen serial number "31181922334"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                               |
      | { "FG": {"SerialNo": "31181922334", "Software": "FGABCDEFH", "MID": 36, "VID": 26, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "31213252843", "Software": "CAMABCDEFH", "PCBASerialNo":"124124124", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    When I request my broker requests
    Then I should receive the following broker requests
      | json                                             |
      | { "FG.SerialNo": "31181922334", "Broker": [  ] } |
    And I should receive a response code of "200"

  @newport.broker.S5
  @ECO-4776.8
  Scenario: Message is provided for an unknown and unregistered device
    And I am an unknown device with the FlowGen serial number "42292033445"
    When the server is given the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                        |
      | { "FG.SerialNo": "42292033445", "SettingsId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7", "Set.Mode": "CPAP", "CPAP.Set.Press": 14.0, "CPAP.Set.StartPress": 8.0, "CPAP.Set.EPR.EPREnable": "On", "CPAP.Set.EPR.EPRType": "FullTime", "CPAP.Set.EPR.Level": 2, "CPAP.Set.Ramp.RampEnable": "On", "CPAP.Set.Ramp.RampTime": 30 } |
    Then I should receive a response code of "404"

  @newport.broker.S6
  @ECO-4776.8
  Scenario: Message is provided for an known and unregistered device
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    When the server is given the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                        |
      | { "FG.SerialNo": "20070811223", "SettingsId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7", "Set.Mode": "CPAP", "CPAP.Set.Press": 14.0, "CPAP.Set.StartPress": 8.0, "CPAP.Set.EPR.EPREnable": "On", "CPAP.Set.EPR.EPRType": "FullTime", "CPAP.Set.EPR.Level": 2, "CPAP.Set.Ramp.RampEnable": "On", "CPAP.Set.Ramp.RampTime": 30 } |
    Then I should receive a response code of "200"

  @newport.broker.S7
  @ECO-4776.8
  @ECO-5581.1
  Scenario: Message is provided for a known and registered device
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    When the server is given the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                        |
      | { "FG.SerialNo": "88800000001", "SettingsId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7", "Set.Mode": "CPAP", "CPAP.Set.Press": 14.0, "CPAP.Set.StartPress": 8.0, "CPAP.Set.EPR.EPREnable": "On", "CPAP.Set.EPR.EPRType": "FullTime", "CPAP.Set.EPR.Level": 2, "CPAP.Set.Ramp.RampEnable": "On", "CPAP.Set.Ramp.RampTime": 30 } |
    Then I should receive a response code of "200"

  @newport.broker.S8
  @ECO-5571.1 @ECO-5571.1a @ECO-5571.1b
  Scenario: Climate Settings SMS is resent after timeout from last SMS.
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    When the server is given the following climate settings to be sent to devices
      | json                                                                                                                                                                                                                                                                         |
      | { "FG.SerialNo": "88800000001", "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
    Then I should receive a response code of "200"
    And I should eventually receive a call home SMS within 10 seconds
    When I pause for 1 seconds
    Then I should eventually receive a call home SMS within 20 seconds

  @newport.broker.S9
  @ECO-5571.1 @ECO-5571.1a @ECO-5571.1b
  Scenario: Subscription SMS is resent after timeout from last SMS.
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    When the server is given the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | { "FG.SerialNo": "88800000001", "SubscriptionId":"E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
    Then I should receive a response code of "200"
    And I should eventually receive a call home SMS within 10 seconds
    When I pause for 1 seconds
    Then I should eventually receive a call home SMS within 20 seconds

  @newport.broker.S10
  @ECO-5571.1 @ECO-5571.1a @ECO-5571.1b
  Scenario: Therapy Settings SMS is resent after timeout from last SMS.
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    When the server is given the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                           |
      | { "FG.SerialNo": "88800000001", "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" } |
    Then I should receive a response code of "200"
    And I should eventually receive a call home SMS within 10 seconds
    When I pause for 1 seconds
    Then I should eventually receive a call home SMS within 20 seconds

  @newport.broker.S11
  @ECO-5571.1 @ECO-5571.1a @ECO-5571.1b
  Scenario: Upgrade SMS is resent after timeout from last SMS.
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    When the server is given the following upgrades to be sent to devices
      | json                                                                                                                                                                                                           |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
    Then I should receive a response code of "200"
    And I should eventually receive a call home SMS within 10 seconds
    When I pause for 1 seconds
    Then I should eventually receive a call home SMS within 20 seconds

  @newport.broker.S12
  @ECO-5789.1
  Scenario: Therapy Settings message should be removed from message broker request
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And the server is given the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                           |
      | { "FG.SerialNo": "88800000001", "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" } |
    When by requesting messages for FG "88800000001" by myself I should eventually receive the following results in 7 seconds
      | URI Fixed Part            | Content Identifier                   |
      | /api/v1/therapy/settings/ | 0091D329-9352-40B0-B34B-D5571242BF0C |
    Given device with FlowGen serial number "88800000001" has been unassigned
    When I request my broker requests
    Then I should eventually receive the following broker requests within 7 seconds
      | json                                             |
      | { "FG.SerialNo": "88800000001", "Broker": [  ] } |

  @newport.broker.S13
  @ECO-5789.1
  @ECO-6140
  Scenario: Therapy Settings message should be removed from message broker request
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And the server is given the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                           |
      | { "FG.SerialNo": "88800000001", "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" } |
    When by requesting messages for FG "88800000001" by myself I should eventually receive the following results in 7 seconds
      | URI Fixed Part            | Content Identifier                   |
      | /api/v1/therapy/settings/ | 0091D329-9352-40B0-B34B-D5571242BF0C |
    Given device with FlowGen serial number "88800000001" has been reassigned
    When I request my broker requests
    Then I should eventually receive the following broker requests within 7 seconds
      | json                                             |
      | { "FG.SerialNo": "88800000001", "Broker": [  ] } |

  @newport.broker.S14
  @ECO-6268.1
  @ECO-5572.1
  @ECO-5570.2
  Scenario: Silent mode configuration message should be removed from message broker. For a device with a CAM that is in silent mode at the time of manufacturing, send a wake up SMS when notified by ECX that the device has been added to patient.
    Given the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 11111114444               | 11111114444                     |
    # Device is created with default silent mode = silent and current silent mode = silent
    And I am a device with the FlowGen serial number "11111114444"
    # Registration is needed to ensure the call home message is generated
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                |
      | { "FG": {"SerialNo": "11111114444", "Software": "FGABCDEFH", "MID": 36, "VID": 25, "PCBASerialNo":"1A345678", "ProductCode":"37001", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "11111114444", "Software": "CAMABCDEFH", "PCBASerialNo":"123123444", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    # Device changes to current silent mode = active as result of this assign event
    And the following devices have been assigned
      | serialNumber | mid | vid |
      | 11111114444  | 36  | 25  |
    Then I should eventually receive a wake up SMS within 10 seconds
    # Device changes back to current silent mode = silent as result of this un-assign event
    When the following devices have been unassigned
      | serialNumber | mid | vid |
      | 11111114444  | 36  | 25  |
    Then I should eventually receive a call home SMS within 10 seconds
    # A silent config message is generated by server and queued for device as result of un-assign event
    When by requesting messages for FG "11111114444" by myself I should eventually receive the following results in 7 seconds
      | URI Fixed Part          | Content Identifier |
      | /api/v1/configurations/ | <ANY_UUID>         |
    And I request my last configuration brokered message
    Then I should receive the following configuration
      | json                                                                                    |
      | { "FG.SerialNo": "11111114444", "ConfigurationId": "<URL_UUID>", "Cam.Mode": "Silent" } |
    # A fresh new assignment event will resulting in the silent config message being removed.
    When the following devices have been assigned
      | serialNumber | mid | vid |
      | 11111114444  | 36  | 25  |
    And I pause for 2 seconds
    And I request my broker requests
    Then I should eventually receive the following broker requests within 7 seconds
      | json                                             |
      | { "FG.SerialNo": "11111114444", "Broker": [  ] } |

  @newport.broker.S15
  @ECO-7322.1
  @ECO-6248.1
  Scenario: All messages should be removed from message broker when Flow Generator is discarded. The Flow Generator is managed by this installation.
    Given the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 11111114444               | 11111114444                     |
    And I am a device with the FlowGen serial number "11111114444"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                |
      | { "FG": {"SerialNo": "11111114444", "Software": "FGABCDEFH", "MID": 36, "VID": 25, "PCBASerialNo":"1A345678", "ProductCode":"37001", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "11111114444", "Software": "CAMABCDEFH", "PCBASerialNo":"123123444", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    # Device changes to current silent mode = active as result of this assign event
    And the following devices have been assigned
      | serialNumber | mid | vid |
      | 11111114444  | 36  | 33  |
    Then I should eventually receive a wake up SMS within 10 seconds
    # Device changes back to current silent mode = silent as result of this un-assign event
    When the following devices have been unassigned
      | serialNumber | mid | vid |
      | 11111114444  | 36  | 33  |
    Then I should eventually receive a call home SMS within 10 seconds
    # A silent config message is generated by server and queued for device as result of un-assign event
    Given the server is given the following climate settings to be sent to devices
      | json                                                                                                                                                                                                                                                                         |
      | { "FG.SerialNo": "11111114444", "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
    And the server is given the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "11111114444", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
    And the server is given the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                           |
      | { "FG.SerialNo": "11111114444", "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" } |
    And the server is given the following upgrades to be sent to devices
      | json                                                                                                                                                                                                           |
      | { "FG.SerialNo": "11111114444", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
    Then by requesting messages for FG "11111114444" by myself I should eventually receive the following results in 30 seconds
      | URI Fixed Part            | Content Identifier                   |
      | /api/v1/climate/settings/ | 3588B987-3304-4D07-97A0-BEAC1A1D06D4 |
      | /api/v1/configurations/   | <ANY_UUID>                           |
      | /api/v1/subscriptions/    | E0C70BA1-FEE3-4445-9FF1-AD9942643F42 |
      | /api/v1/therapy/settings/ | 0091D329-9352-40B0-B34B-D5571242BF0C |
      | /api/v1/upgrades/         | B2AE8F06-1541-4616-AE6F-F9E4C079CC6E |
    When the following devices have been discarded
      | serialNumber | updatedOn           | EquipmentType  |
      | 11111114444  | 2015-01-12 16:36:45 | FLOW_GENERATOR |
    Then I should eventually receive the following broker requests within 7 seconds
      | json                                             |
      | { "FG.SerialNo": "11111114444", "Broker": [  ] } |

  @newport.broker.S16
  @ECO-8222.1
  Scenario: On successful scrap of a Flow Gen, all future requests for this Flow Gen shall be blocked.
    Given the server receives the following manufacturing unit detail
      | resource                                                                                  |
      | /data/manufacture/unit/detail/scrap/unit_detail_fg11111111111_cam11111111111_scrap.xml    |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 11111111111               | 11111111111                     |
    And I am a device with the FlowGen serial number "11111111111"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                  |
      | { "FG": {"SerialNo": "11111111111", "Software": "FGABCDEFH", "MID": 36, "VID": 25, "PCBASerialNo":"1A345678", "ProductCode":"37001", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "11111111111", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And the server is given the following climate settings to be sent to devices
      | json                                                                                                                                                                                                                                                                         |
      | { "FG.SerialNo": "11111111111", "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
    And the server is given the following configurations to be sent to devices
      | json                                                                                                                                                                                                                              |
      | { "FG.SerialNo": "11111111111", "ConfigurationId": "962CC963-43D8-44F9-A283-B114A184B4", "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/", "REGO-URI": "/v1/registrations/" } |
    And the server is given the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "11111111111", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
    And the server is given the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                           |
      | { "FG.SerialNo": "11111111111", "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" } |
    And the server is given the following upgrades to be sent to devices
      | json                                                                                                                                                                                                           |
      | { "FG.SerialNo": "11111111111", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
    And I request my broker requests
    Then I should eventually receive the following broker requests within 7 seconds
      | json                                             |
      | { "FG.SerialNo": "11111111111", "Broker": [  ] } |

  @newport.broker.S17
  @ECO-6248.1
  Scenario: Messages should not be processed for devices that are not managed by the installation.
    Given the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 11111111112               | 11111111112                     |
    And I am a device with the FlowGen serial number "11111111112"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                  |
      | { "FG": {"SerialNo": "11111111112", "Software": "FGABCDEFH", "MID": 36, "VID": 25, "PCBASerialNo":"1A345678", "ProductCode":"37001", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "11111111112", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00011", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And the server is given the following climate settings to be sent to devices
      | json                                                                                                                                                                                                                                                                         |
      | { "FG.SerialNo": "11111111112", "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
    And the server is given the following configurations to be sent to devices
      | json                                                                                                                                                                                                                              |
      | { "FG.SerialNo": "11111111112", "ConfigurationId": "962CC963-43D8-44F9-A283-B114A184B4", "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/", "REGO-URI": "/v1/registrations/" } |
    And the server is given the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "11111111112", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
    And the server is given the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                           |
      | { "FG.SerialNo": "11111111112", "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" } |
    And the server is given the following upgrades to be sent to devices
      | json                                                                                                                                                                                                           |
      | { "FG.SerialNo": "11111111112", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
    When I request my broker requests
    Then I should eventually receive the following broker requests within 7 seconds
      | json                                             |
      | { "FG.SerialNo": "11111111112", "Broker": [  ] } |

  @newport.broker.S18
  @ECO-4833.1 @ECO-4833.2 @ECO-4833.3
  Scenario: When requested by a device, brokered requests should not be returned if they have been either cancelled or acknowledged.
    Given the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000001"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
   #configuration
    And the server has the following configurations to be sent to devices
      | json                                                                                                                                                                                                                              |
      | { "FG.SerialNo": "88800000001", "ConfigurationId": "962CC963-43D8-44F9-A283-B114A184B4", "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/", "REGO-URI": "/v1/registrations/" } |
    And I request my broker requests
    Then I should receive a response code of "200"
    When I request the configuration with identifier "962CC963-43D8-44F9-A283-B114A184B4"
    And I acknowledge the configuration with identifier "962CC963-43D8-44F9-A283-B114A184B4"
      | json                                                                                                             |
      | { "FG.SerialNo": "88800000001",  "ConfigurationId": "962CC963-43D8-44F9-A283-B114A184B4", "Status": "Received" } |
    Then I should receive a server ok response
    When I request my last configuration brokered message
    Then I should receive a response code of "404"
    And the configuration response body should be empty
    # subscription
    And the server has the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
    And I request my broker requests
    Then I should receive a response code of "200"
    When I request the subscription with identifier "E0C70BA1-FEE3-4445-9FF1-AD9942643F42"
    And I acknowledge the subscription with identifier "E0C70BA1-FEE3-4445-9FF1-AD9942643F42"
      | json                                                                                                             |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "Status": "Received" } |
    Then I should receive a server ok response
    When I request my last subscription brokered message
    Then I should receive a response code of "404"
    And the subscription response body should be empty
    # therapy settings
    And the server has the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                           |
      | { "FG.SerialNo": "88800000001", "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" } |
    And I request my broker requests
    Then I should receive a response code of "200"
    When I request the therapy settings with identifier "0091D329-9352-40B0-B34B-D5571242BF0C"
    And I acknowledge the therapy settings with identifier "0091D329-9352-40B0-B34B-D5571242BF0C"
      | json                                                                                                         |
      | { "FG.SerialNo": "88800000001", "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C", "Status": "Received" } |
    Then I should receive a server ok response
    When I request my last therapy settings brokered message
    Then I should receive a response code of "404"
    And the therapy settings response body should be empty
    # Upgrade
    And the server has the following upgrades to be sent to devices
      | json                                                                                                                                                                                                           |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
    And I request my broker requests
    Then I should receive a response code of "200"
    When I request the upgrade with identifier "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E"
    And I acknowledge the upgrade with identifier "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E"
      | json                                                                                                                |
      | { "FG.SerialNo": "88800000001", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E" , "Status": "DownloadFailure" } |
    Then I should receive a server ok response
    When I request my last upgrade brokered message
    Then I should receive a response code of "404"
    And the upgrade response body should be empty
