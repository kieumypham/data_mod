@therapy.data.from.program.enabled.devices
@ECO-10173

Feature:
  (@ECO-10173) As a clinical user I want to add a Astral 100 device to a patient
               so that I can monitor my patient's therapy.

#  Note 1: For supported data items refer to https://objective.resmedglobal.com/id:A2590135/document/versions/19.5 or see attached Excel workbook.
#  Note 2: CAL metadata needs to be updated for this VID using the attached xml. See ECO-6726.
#  Note 3: CamSim should be updated as per ECO-10545.
#  Note 4: Astral USB MSD will not be supported in AirView. Only wireless data is available for Astral devices.
#  Note 5: The default mode for this device is ACV.
#  Note 6: This VID supports 2 programs and as such data for both programs will eventually need to be requested and stored.  However, for the purposes of this card, ignore the programs and just receive data for the single program.  Also, for the purposes of this card, the program number does not need to be stored in the database.
#
#  1. Users shall be able to add an Astral 100 (MID30, VID5) to new or existing patients and receive data from the device as per ECO-7292.
#
#  Note 7: Normally, product display name is specified however it is now expected that the name displayed is read off the device (node PNA).  Default name for this variant is Astral 100.
#  Note 8: US Product Code is 27007 and EU Product Code 27011.
#  Note 9: Device image is attached.
#
#  2. Users shall be able to generate excel exports for an Astral 100 (MID30, VID5) device as per ECO-7295.
#  3. Incoming data from an Astral 100 (MID30, VID5) device shall be validated as per ECO-7296.
#
#  Note 10: Astral devices do NOT support settings changes. Hiding the settings change links is covered in ECO-10499.
#  Note 11: Incoming alarm logs from Astral 100 (MID30, VID5) device will be stored as per ECO-9545.
#  Note 12: Incoming alarm related settings from Astral 100 (MID 30, VID5) device will be stored as per ECO-9545.
#  Note 13: The ACs in the generic stories (ECO-7292 - ECO-7296) have been updated to reflect the Lumis, Stellar and Astral platforms. These ACs will need to be updated in feature files where they are present.

Background:
  Given the server completed bulk load the following devices and modules with status
    | jobFile                                           | jobStatus        |
    | /data/manufacturing/batch_new_cam1000_bdg2215.xml | COMPLETE-SUCCESS |
    | /data/manufacturing/batch_new_fg1000.xml          | COMPLETE-SUCCESS |
  And the communication module "10000000001" uses mock Telco
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
      "CAM": {"SerialNo": "10000000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1A345678"},
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
    """
  Then the server should get the following device configuration change
    | json                                                                                                                                                      |
    | { "serialNo": "10000000003", "mid": 36, "vid": 33, "communicationModuleMode": "", "updateSubscriptionsRequired": true, "variantIdentifierChanged": false} |
  Given the newport management queue received the following "SUBSCRIPTION" messages
    | { "FG.SerialNo": "10000000003", "SubscriptionId": "STRADIDailyTriggerValvedSettingsData", "ServicePoint": "/api/v1/therapy/settings", "Trigger": {"Collect": [ "HALO" ], "OnlyOnChange": true, "Conditional": {"Setting": "Val.Mode", "Value": "AutoSet"}},  "Data": ["Val.Alarm.LowExpTidVolume", "Val.TiMin", "Val.Apnea.Interval", "Val.MinEPAP", "Val.Mode", "Val.Alarm.HighSpO2", "Val.ApneaVent.PressAssist", "Val.SafetyTidVolume", "Val.TiMax", "Val.Mask", "Val.PeakFlow", "Val.Alarm.HighExpMinVentilation", "Val.Trigger", "Val.PatientType", "Val.Alarm.HighPulseRate", "Val.CycleThresh", "Val.Apnea.Response", "Val.Circuit", "Program", "Val.Sigh.Enable", "Val.MaxEPAP", "Val.Alarm.HighRespRate", "Val.ApneaVent.Freq", "Val.MaxPS", "Val.Alarm.LowFiO2", "Val.RespRate", "Val.Alarm.HighFiO2", "Val.TidalVolume", "Val.Alarm.HighInspTidVolume", "Val.TargetAlveolarVent", "Val.iVAPS.MinPS", "Val.ApneaVent.PeakInspFlow", "Val.ApneaVent.Ti", "Val.Alarm.LowInspTidVolume", "Val.Alarm.DiscoActTime", "Val.ManualMag", "Val.Alarm.DiscoAutoTime", "Val.ManualBreathEnable", "Val.Apnea.BreathType", "Val.EPAP", "Val.RiseTime", "Val.FlowShape", "Val.iVAPS.MaxPS", "Val.Alarm.VentStop", "Val.HeightCM", "Val.Alarm.LowInspMinVentilation", "Val.DurationOption", "Val.TrigThresh", "Val.TargetRate", "Val.Ti", "Val.Alarm.LowExpMinVentilation", "Val.Sigh.Mag", "Val.Alarm.LowPressThresh", "Val.Alarm.HighInspMinVentilation", "Val.Alarm.DiscoEnable", "Val.Interface", "Val.Alarm.HighPressure", "Val.AutoEPAP", "Val.Alarm.HighExpTidVolume", "Val.ApneaVent.TidVolume", "Val.PressAssist", "Val.Sigh.Interval", "Val.IPAP", "Val.Alarm.LowRespRate", "Val.TriggerType", "Val.Alarm.LeakThreshVented", "Val.PressSupport", "Val.Alarm.LowPulseRate", "Val.Press", "Val.Alarm.NonVentedMaskEnable", "Val.Alarm.LowPressEnable", "Val.Sigh.Alert", "Val.Alarm.LowSpO2", "Val.Alarm.LowPEEP", "Val.Alarm.LeakThreshValved", "Val.Alarm.DiscoLeakTol"] } |
    | { "FG.SerialNo": "10000000003", "SubscriptionId": "STRADIDailyTriggerValvedSummaryData", "ServicePoint": "/api/v1/therapy/summaries", "Trigger": {"Collect": [ "HALO" ], "Conditional": { "Setting": "Val.Mode", "Value": "CPAP" }, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": [ "Val.Duration", "Val.ProgUsage", "Val.FiO2.5", "Val.SpO2.95", "Val.MeanPressure.95", "Val.MaxInspFlow.5", "Val.SpO2.50", "Val.PeakInspPress.5", "Val.HI", "Val.AHI", "Val.EndExpPressure.50", "Val.IERatio.95", "Val.EndExpPressure.5", "Val.EndExpPressure.95", "Val.LeakValved.95", "Program", "Val.MeanPressure.50", "Val.LeakValved.50", "Val.SpO2.5", "Val.PulseRate.5", "Val.IERatio.50", "Val.RespRate.5", "Val.RespRate.50", "Val.TidVol.95", "Val.RespRate.95", "Val.TidVol.50", "Val.AI", "Val.FiO2.50", "Val.TidVol.5", "Val.ExpTime.5", "Val.ExpTime.95", "Val.MeanPressure.5", "Val.PulseRate.95", "Val.MaxInspFlow.50", "Val.PulseRate.50", "Val.Ti.5", "Val.MaxInspFlow.95", "Val.PeakInspPress.50", "Val.PeakInspPress.95", "Val.MinVent.5", "Val.ExpTime.50", "Val.Ti.95", "Val.MinVent.50", "Val.MinVent.95", "Val.Ti.50", "Val.FiO2.95", "Val.LeakValved.5", "Val.IERatio.5" ] }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
  Then I should eventually receive a call home SMS within 10 seconds
  And by requesting messages for FG "10000000003" with external CAM I should eventually receive the following results in 7 seconds
    | URI Fixed Part         | Content Identifier                   |
    | /api/v1/subscriptions/ | STRADIDailyTriggerValvedSettingsData |
    | /api/v1/subscriptions/ | STRADIDailyTriggerValvedSummaryData  |

@therapy.data.from.program.enabled.devices.S1
@ECO-10173.1 @ECO-10173.2
Scenario Outline: Set program header from device data for program enabled devices
  Given I sent the following device data and received ok responses
    | Type       | Json File   |
    | <dataType> | <jsonFile>  |
  Then the following device data received events have been published
    | JMSType   | PROGRAM   | JMSXGroupID     | DeviceDataSource   | DeviceFlowGenSerialNumber | json file  |
    | <jmsType> | <program> | <flowGenSerial> | <deviceDataSource> | <flowGenSerial>           | <jsonFile> |
  Examples:
    | dataType          | jsonFile                              | jmsType         | program | flowGenSerial | deviceDataSource |
    | therapy summaries | /data/astral/astral_summary_000.json  | THERAPY_SUMMARY | <NULL>  | 10000000003   | DEVICE           |
    | therapy summaries | /data/astral/astral_summary_001.json  | THERAPY_SUMMARY | 1       | 10000000003   | DEVICE           |
    | therapy summaries | /data/astral/astral_summary_002.json  | THERAPY_SUMMARY | 2       | 10000000003   | DEVICE           |
    | therapy summaries | /data/astral/astral_summary_003.json  | THERAPY_SUMMARY | 3       | 10000000003   | DEVICE           |
    | therapy summaries | /data/astral/astral_summary_004.json  | THERAPY_SUMMARY | 4       | 10000000003   | DEVICE           |
    | therapy settings  | /data/astral/astral_settings_000.json | THERAPY_SETTING | <NULL>  | 10000000003   | DEVICE           |
    | therapy settings  | /data/astral/astral_settings_001.json | THERAPY_SETTING | 1       | 10000000003   | DEVICE           |
    | therapy settings  | /data/astral/astral_settings_002.json | THERAPY_SETTING | 2       | 10000000003   | DEVICE           |
    | therapy settings  | /data/astral/astral_settings_003.json | THERAPY_SETTING | 3       | 10000000003   | DEVICE           |
    | therapy settings  | /data/astral/astral_settings_004.json | THERAPY_SETTING | 4       | 10000000003   | DEVICE           |
