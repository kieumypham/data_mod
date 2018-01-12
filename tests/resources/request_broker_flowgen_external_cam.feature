@cam
@newport
@newport.broker
@newport.broker.flowgen.external.cam
@ECO-9423

Feature:
  (ECO-9423) As ECO
  I want to generate subscriptions for a CAMBridge device customised
  to its connected flow generator so that the device can talk to ECO

# ACCEPTANCE CRITERIA: (ECO-9423)
#  1. The server shall provide a request broker for external CAMs connected to a device to collect requests.
#     *Note:* URL is to be /api/v1/requests/{fgserialnumber}/cams/{cam serial number}.
#  2. When any request is queued for a CAMBridge for a device then an SMS shall be sent to the connected CAMBridge.
#  3. The request broker shall return the list of queued requests (FIFO) to the CAMBridge that are relevant to the request's device and CAMBridge serial number context.
#  4. The request broker shall return an error (HTTP412) if a GET request is received from an unknown CAMBridge or device.
#  5. If the device or CAMBridge are not currently registered as a pair then an error (HTTP424) shall be returned to the CAMBridge when it queries the request broker.

#  Note 1: Protocol details: http://confluence.corp.resmed.org/display/CA/Requests+-+new
#  Note 2: The messages delivered to the broker are assumed to be correct. This card will not validate the content.

  Background:
    Given devices with following properties have been manufactured
      | moduleSerial | authKey                          | flowGenSerial | deviceNumber | mid | vid | pcbaSerialNo | regionId | productCode | internalCommModule |
      | 20102141732  | 201913483157AAAAAAAAAAAAAAAAAAAA | 20070811223   | 123          | 36  | 26  | 123123123    | 1        | 9745        | true               |
    And the server waits for the device manufactured queue to be empty
    And the server should not produce device manufactured error
    And the server receives the following manufacturing unit detail
      | resource                                                             |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg88800000001_cam88810000001_new.xml |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 88800000001               |
    And the communication module "88810000001" uses mock Telco
    And the communication module "20102141732" uses mock Telco

  @newport.broker.flowgen.external.cam.S1
  @ECO-9423.1 @ECO-9423.2 @ECO-9423.3
  Scenario: Queued requests (subscription, therapy settings, erasure, etc) should be sent to external CAM with connected device. New queued requests will trigger a SMS being sent to the external CAM.
    Given I am a device with the FlowGen serial number "88800000001"
    And I have been connected with CAM with serial number "88810000001" with authentication key "190802372046IFPCHKCJAOXLD0XINPS0"
    And I send the following version 2 registration
  """
    {
      "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678",
            "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" },
      "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789" },
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
  """
    # Above is internal CAM-FG registration for first time, so no Device Configuration Change event is triggered
    When I request my broker requests for flow generator and external cam
    # Receiving empty list since no requested ie queued yet
    Then I should receive the following broker requests
      | json                                           |
      | { "FG.SerialNo": "88800000001", "Broker": [] } |
    Given the server has the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | { "FG.SerialNo": "88800000001", "CAM.SerialNo": "88810000001", "SubscriptionId": "3E05F22E-F1B1-4BA4-A89D-01398C41F775", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.TgtIPAP.50", "Val.TgtIPAP.95", "Val.TgtIPAP.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "7E293B00-9396-48A8-945E-A61712BAD67E", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] }                                                                                       |
      | { "FG.SerialNo": "88800000001", "CAM.SerialNo": "88810000001", "SubscriptionId": "02ea52a6-b826-4749-ae9b-8c5fbc7d43c5",  "ServicePoint": "/api/v1/erasures", "Trigger": { "Collect": [ "HALO" ], "OnlyOnChange": true }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                                  |
    And the following update requests are queued for delivery to the device
      | requestType     | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | SUBSCRIPTION    | { "FG.SerialNo": "88800000001", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | THERAPY_SETTING | { "FG.SerialNo": "88800000001", "SettingsId": "0091D329-9352-40B0-B34B-D5571242BF0C", "Set.Mode": "AutoSet", "AutoSet.Set.MinPress": 7.0, "AutoSet.Set.MaxPress": 15.0, "AutoSet.Set.StartPress": 8.0, "AutoSet.Set.EPR.EPREnable": "On", "AutoSet.Set.EPR.EPRType": "Ramp", "AutoSet.Set.EPR.Level": 3, "AutoSet.Set.Ramp.RampEnable": "Auto", "AutoSet.Set.Ramp.RampTime": 15, "AutoSet.Set.Comfort": "On" }                                                         |
    Then I should eventually receive a call home SMS within 10 seconds
    # Receiving a mix of requests (subscriptions, settings, etc)
    And by requesting messages for FG "88800000001" with external CAM I should eventually receive the following results in 30 seconds
      | URI Fixed Part            | Content Identifier                   |
      | /api/v1/subscriptions/    | 3E05F22E-F1B1-4BA4-A89D-01398C41F775 |
      | /api/v1/subscriptions/    | 02ea52a6-b826-4749-ae9b-8c5fbc7d43c5 |
      | /api/v1/subscriptions/    | E0C70BA1-FEE3-4445-9FF1-AD9942643F42 |
      | /api/v1/therapy/settings/ | 0091D329-9352-40B0-B34B-D5571242BF0C |

  @newport.broker.flowgen.external.cam.S2
  @ECO-9423.4 @ECO-9423.5
  Scenario: Error code 412 and 424 should be returned for requests from unknown FG or CAM, and unpaired FG and CAM
    Given I am a device with the FlowGen serial number "88800000001"
    And the server has the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | { "FG.SerialNo": "88800000001", "CAM.SerialNo": "88810000001", "SubscriptionId": "3E05F22E-F1B1-4BA4-A89D-01398C41F775", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.TgtIPAP.50", "Val.TgtIPAP.95", "Val.TgtIPAP.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "7E293B00-9396-48A8-945E-A61712BAD67E", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] }                                                                                       |
      | { "FG.SerialNo": "88800000001", "CAM.SerialNo": "88810000001", "SubscriptionId": "02ea52a6-b826-4749-ae9b-8c5fbc7d43c5",  "ServicePoint": "/api/v1/erasures",         "Trigger": { "Collect": [ "HALO" ], "OnlyOnChange": true }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                          |
    # Both FlowGen and CommModule are unknown
    When I make a random broker requests with flow generator serial "88800000002" and communication module serial "88810000003" and authentication key "somekey"
    Then I should receive a response code of "412"
    # FlowGen is known, CommModule is unknown
    When I make a random broker requests with flow generator serial "88800000001" and communication module serial "88810000003" and authentication key "somekey"
    Then I should receive a response code of "412"
    # FlowGen is unknown, CommModule is known
    When I make a random broker requests with flow generator serial "88800000002" and communication module serial "88810000001" and authentication key "190802372046IFPCHKCJAOXLD0XINPS0"
    Then I should receive a response code of "424"
    When I am a device with the FlowGen serial number "88800000001"
    And I have been connected with CAM with serial number "88810000001" with authentication key "190802372046IFPCHKCJAOXLD0XINPS0"
    And I send the following version 2 registration
  """
    {
      "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678",
            "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" },
      "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789" },
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
  """
    And the following units are cached for local use
      | flowGeneratorSerialNumber |
      | 20070811223               |
    And I am a device with the FlowGen serial number "20070811223"
    And I request my broker requests for flow generator and external cam
    Then I should receive a response code of "424"

  @newport.broker.flowgen.external.cam.S3
  @ECO-9423.5
  Scenario: Error code 424 should be returned for requests for not currently paired FG or CAM
    Given I am a device with the FlowGen serial number "88800000001"
    When I have been connected with CAM with serial number "88810000001" with authentication key "190802372046IFPCHKCJAOXLD0XINPS0"
    And I send the following version 2 registration
  """
    {
      "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678",
            "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" },
      "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789" },
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
  """
    And the server has the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | { "FG.SerialNo": "88800000001", "CAM.SerialNo": "88810000001", "SubscriptionId": "3E05F22E-F1B1-4BA4-A89D-01398C41F775", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.TgtIPAP.50", "Val.TgtIPAP.95", "Val.TgtIPAP.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "7E293B00-9396-48A8-945E-A61712BAD67E", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] }                                                                                       |
      | { "FG.SerialNo": "88800000001", "CAM.SerialNo": "88810000001", "SubscriptionId": "02ea52a6-b826-4749-ae9b-8c5fbc7d43c5",  "ServicePoint": "/api/v1/erasures",         "Trigger": { "Collect": [ "HALO" ], "OnlyOnChange": true }, "Data": [ "Val.LastEraseDate" ] }                                                                                                                                                                                                                                                                                          |
    When I make a random broker requests with flow generator serial "88800000001" and communication module serial "88810000001" and authentication key "190802372046IFPCHKCJAOXLD0XINPS0"
    Then I should eventually receive broker requests for flow generator 88800000001 with the following details within 7 seconds
      | URI Fixed Part         | Content Identifier                   |
      | /api/v1/subscriptions/ | 3E05F22E-F1B1-4BA4-A89D-01398C41F775 |
      | /api/v1/subscriptions/ | 02ea52a6-b826-4749-ae9b-8c5fbc7d43c5 |
    When I am a device with the FlowGen serial number "20070811223"
    And I have been connected with CAM with serial number "20102141732" with authentication key "201913483157AAAAAAAAAAAAAAAAAAAA"
    And I send the following version 2 registration
  """
    {
      "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678",
            "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" },
      "CAM": {"SerialNo": "20102141732", "Software": "CAMABCDEFH", "PCBASerialNo":"123123123" },
      "Hum": {"Software": "HUMABCDEFH"},
      "Subscriptions": []
    }
  """
    And I make a random broker requests with flow generator serial "88800000001" and communication module serial "88810000001" and authentication key "190802372046IFPCHKCJAOXLD0XINPS0"
    Then I should receive a response code of "424"
