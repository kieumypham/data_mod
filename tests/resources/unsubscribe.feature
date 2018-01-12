@newport
@newport.unsubscribe
@ECO-5171

Feature:
  (ECO-5171) As a clinical user
  I want to be able to cancel subscriptions
  In order that I can make changes to a patient's schedule.

  # ACCEPTANCE CRITERIA: (ECO-5171)
  # 1. When a request to cancel a subscription for a device is received then the request broker shall queue the cancel subscription request for the device.
  # 2. A request to cancel a subscription shall initiate an SMS to be sent to the device.
  # 3. When an acknowledgment to the cancel request is received from the device, the request broker shall remove the request from the list.
  #
  # Note 1: Protocol details: http://confluence.corp.resmed.org/x/awGz, http://confluence.corp.resmed.org/x/ZwGz

  Background:
    Given the cached device list and cached responses are cleared
    And the server receives the following manufacturing unit detail
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
    And the server is given the following subscriptions to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint": "/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
    Then by requesting messages for FG "88800000001" by myself I should eventually receive the following results in 10 seconds
      | URI Fixed Part         | Content Identifier                   |
      | /api/v1/subscriptions/ | E0C70BA1-FEE3-4445-9FF1-AD9942643F42 |
    And I request the subscription with identifier "E0C70BA1-FEE3-4445-9FF1-AD9942643F42"
    And I should receive the following subscription
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint": "/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
    And I acknowledge the subscription with content identifier "E0C70BA1-FEE3-4445-9FF1-AD9942643F42"
      | json                                                                                                             |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "Status": "Received" } |

  @newport.unsubscribe.S1
  @ECO-5171.1 @ECO-5171.2 @ECO-5171.3
  Scenario: Happy case, unsubscribe from previously delivered subscription.
    When the server is given the following subscriptions to be sent to devices
      | json                                                                                                       |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "Cancel": true } |
    Then I should receive a SMS with the following
      | purpose   |
      | CALL_HOME |
    And by requesting messages for FG "88800000001" by myself I should eventually receive the following results in 10 seconds
      | URI Fixed Part         | Content Identifier                   |
      | /api/v1/subscriptions/ | E0C70BA1-FEE3-4445-9FF1-AD9942643F42 |
    When I request the subscription with identifier "E0C70BA1-FEE3-4445-9FF1-AD9942643F42"
    Then I should receive the following subscription
      | json                                                                                                       |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "Cancel": true } |
    When I acknowledge the subscription with content identifier "E0C70BA1-FEE3-4445-9FF1-AD9942643F42"
      | json                                                                                                             |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "Status": "Received" } |
    And I request my broker requests
    Then I should receive the following broker requests
      | json                                             |
      | { "FG.SerialNo": "88800000001", "Broker": [  ] } |

  @newport.unsubscribe.S2
  @ECO-5171.1 @ECO-5171.2 @ECO-5171.3
  Scenario: Happy case, unsubscribe request remains on broker if not acknowledged.
    When the server is given the following subscriptions to be sent to devices
      | json                                                                                                       |
      | { "FG.SerialNo": "88800000001", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "Cancel": true } |
    Then I should receive a SMS with the following
      | purpose   |
      | CALL_HOME |
    And by requesting messages for FG "88800000001" by myself I should eventually receive the following results in 10 seconds
      | URI Fixed Part         | Content Identifier                   |
      | /api/v1/subscriptions/ | E0C70BA1-FEE3-4445-9FF1-AD9942643F42 |
    # Message had not been acknowledged, hence expect it being brokered again
    And by requesting messages for FG "88800000001" by myself I should eventually receive the following results in 10 seconds
      | URI Fixed Part         | Content Identifier                   |
      | /api/v1/subscriptions/ | E0C70BA1-FEE3-4445-9FF1-AD9942643F42 |
