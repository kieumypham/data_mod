@newport
@newport.update
@ECO-5510
@ECO-5789
@ECO-6140

Feature:
  (ECO-5510) In NGCS, create and read from the Newport management queue and add the message to the broker.

  (ECO-5789) As a clinical user
  I want ECO to cancel any outstanding wireless settings if I remove the device from the patient
  so that the settings cannot be accidentally applied to a subsequent patient

  (@ECO-6140) Race condition when an S10 device is reassigned to a patient

  # ACCEPTANCE CRITERIA: (ECO-5510)
  # In NGCS, create and read from the Newport management queue and add the message to the broker.

  # ACCEPTANCE CRITERIA: (ECO-5789)
  # Note 1: For S9 devices CAL cancels settings requests when a schedule is cancelled as per ECO-1541.  This story provides equivalent functionality for Newport devices
  # 1. When a Newport therapy device is removed from a patient then any wireless settings change requests awaiting collection by the device shall be deleted.  Note: This applies even if the device is being implicitely removed such as when the device is added to patient B and removed from patient A after confirmation.
  # Note 2: The settings and settings status (i.e. changes pending) are not shown in the Prescription panel if the patient does not have a device.  It is assumed that if this device or another was added back to the patient after removal then the settings status would not still show that changes are pending.

  # ACCEPTANCE CRITERIA: (ECO-6140)
  # When an S10 Newport device is reassigned to a patient, ECO publishes both device activation event and device unassigned event to the corresponding topics, one for the newly assigned device and the other for the unassignment. The intention in reassignment case is that we first want to unassign the device (and put it back to silent state for EU) and then to activate the device (and wake up for EU).
  # However, due to the asynchronous nature of the event driven communication model, there is no guarantee for the order of the processing of these events. Therefore, when the device unassigment event is processed after the activation, the device will be considered inactive and new settings requests(if any) will be cancelled along with the old ones. In addition, in EU case the device will also be put to silent mode, even though it's expected to be in active mode.

  Background:
    Given the server receives the following manufacturing unit detail
      | resource                                                             |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg88800000001_cam88810000001_new.xml |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 88800000001               | 88810000001                     |
    And I am a device with the FlowGen serial number "88800000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |

  @newport.update.S1
  @ECO-5510
  Scenario:
    Given the following update request is placed on the server's management queue for delivery to a newport device
      | requestType     | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | CLIMATE_SETTING | { "FG.SerialNo": "88800000001", "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" }                                                                                                                                                                                           |
      | CLIMATE_SETTING | { "FG.SerialNo": "88800000001", "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" }                                                                                                                                                                                           |
      | SUBSCRIPTION    | { "FG.SerialNo": "88800000001", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | SUBSCRIPTION    | { "FG.SerialNo": "88800000001", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | THERAPY_SETTING | { "FG.SerialNo": "88800000001", "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" }                                                         |
      | THERAPY_SETTING | { "FG.SerialNo": "88800000001", "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" }                                                         |
      | THERAPY_SETTING | { "FG.SerialNo": "88800000001", "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" }                                                         |
    Then by requesting messages for FG "88800000001" by myself I should eventually receive the following results in 30 seconds
      | URI Fixed Part            | Content Identifier                   |
      | /api/v1/climate/settings/ | 3588B987-3304-4D07-97A0-BEAC1A1D06D4 |
      | /api/v1/subscriptions/    | E0C70BA1-FEE3-4445-9FF1-AD9942643F42 |
      | /api/v1/therapy/settings/ | 0091D329-9352-40B0-B34B-D5571242BF0C |

  @newport.update.S2
  @ECO-5789.1
  Scenario: Device requests a settings message that does not exist and receives a 404 response
    And the server has the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "88800000001", "SettingsId": "CPAPSettings01","Set.Mode": "CPAP","CPAP.Set.Press":14.0,"CPAP.Set.StartPress":8.0,"CPAP.Set.EPR.EPREnable":"On","CPAP.Set.EPR.EPRType":"FullTime","CPAP.Set.EPR.Level":2,"CPAP.Set.Ramp.RampEnable":"On","CPAP.Set.Ramp.RampTime":30 } |
    And device with FlowGen serial number "88800000001" has been unassigned
    When I pause for 3 seconds
    And I request the therapy settings with identifier "CPAPSettings01"
    Then I should receive a response code of "404"

  @newport.update.S3
  @ECO-5789.1
  Scenario: Device acknowledges a settings message that does not exist and receives a 200 response
    And the server has the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                   |
      | { "FG.SerialNo": "88800000001", "SettingsId": "CPAPSettings01","Set.Mode": "CPAP","CPAP.Set.Press":14.0,"CPAP.Set.StartPress":8.0,"CPAP.Set.EPR.EPREnable":"On","CPAP.Set.EPR.EPRType":"FullTime","CPAP.Set.EPR.Level":2,"CPAP.Set.Ramp.RampEnable":"On","CPAP.Set.Ramp.RampTime":30 } |
    And device with FlowGen serial number "88800000001" has been unassigned
    When I pause for 3 seconds
    And I acknowledge the therapy settings with content identifier "CPAPSettings01"
      | json                                                                                   |
      | { "FG.SerialNo": "88800000001", "SettingsId": "CPAPSettings01", "Status": "Received" } |
    Then I should receive a response code of "200"

  @newport.update.S4
  @ECO-5789.1
  @ECO-6140
  Scenario: Device requests a settings message that does not exist and receives a 404 response
    And the server has the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                         |
      | { "FG.SerialNo": "88800000001", "SettingsId": "194BB1AE-8037-42FE-8186-9EC388F79526","Set.Mode": "CPAP","CPAP.Set.Press":14.0,"CPAP.Set.StartPress":8.0,"CPAP.Set.EPR.EPREnable":"On","CPAP.Set.EPR.EPRType":"FullTime","CPAP.Set.EPR.Level":2,"CPAP.Set.Ramp.RampEnable":"On","CPAP.Set.Ramp.RampTime":30 } |
    And device with FlowGen serial number "88800000001" has been reassigned
    When I pause for 3 seconds
    And I request the therapy settings with identifier "194BB1AE-8037-42FE-8186-9EC388F79526"
    Then I should receive a response code of "404"

  @newport.update.S5
  @ECO-5789.1
  @ECO-6140
  Scenario: Device acknowledges a settings message that does not exist and receives a 200 response
    And the server has the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                         |
      | { "FG.SerialNo": "88800000001", "SettingsId": "194BB1AE-8037-42FE-8186-9EC388F79526","Set.Mode": "CPAP","CPAP.Set.Press":14.0,"CPAP.Set.StartPress":8.0,"CPAP.Set.EPR.EPREnable":"On","CPAP.Set.EPR.EPRType":"FullTime","CPAP.Set.EPR.Level":2,"CPAP.Set.Ramp.RampEnable":"On","CPAP.Set.Ramp.RampTime":30 } |
    And device with FlowGen serial number "88800000001" has been reassigned
    When I pause for 3 seconds
    And I acknowledge the therapy settings with content identifier "194BB1AE-8037-42FE-8186-9EC388F79526"
      | json                                                                                                         |
      | { "FG.SerialNo": "88800000001", "SettingsId": "194BB1AE-8037-42FE-8186-9EC388F79526", "Status": "Received" } |
    Then I should receive a response code of "200"

  @newport.update.S6
  Scenario: Test that an unknown message goes on DLQ.NewportManagement
    When the following update request is placed on the server's management queue for delivery to a newport device
      | requestType  | json                                                                                                                                                                                                                                                                        |
      | UNKNOWN_TYPE | { "FG.SerialNo": "88800000001", "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D5", "Set.ClimateControl": "Auto", "Set.HumEnable": "On", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 24, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
    And I pause for 3 seconds
    Then the server should log the following invalid broker request
      | brokeredMessageErrorCode | brokeredMessageType | jsonMessage                                                                                                                                                                                                                                                                 |
      | UNKNOWN_MESSAGE_TYPE     | UNKNOWN_TYPE        | { "FG.SerialNo": "88800000001", "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D5", "Set.ClimateControl": "Auto", "Set.HumEnable": "On", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 24, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
