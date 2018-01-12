@subscription.blocking
@subscription.blocking.newport

@ECO-12457

Feature:
  (ECO-12457) As a clinical user
  I want to be able to cancel subscriptions
  so that I can make changes to a patient's schedule.

# ACCEPTANCE CRITERIA: (ECO-12457)
#  Note 1: This story extends ECO-10358 to allow data from a specified subscription to be blocked.
#  1. When a request to block a subscription is received, the request broker shall no longer accept data from the specified subscription UUID.
#  2. When a request to block a subscription is received, the subscription shall be cancelled as per ECO-5171.
#  Note 2: This creates a new PUT endpoint at /v1/newport/management/subscriptions/{subscriptionId} to allow for blocking of a specific subscription.
#  Note 3: Bulk blocking of subscription is not required
#  Note 4: Subsequent blocking requests may return a 2xx success response if the requested subscription uuid(s) are already blocked

  @subscription.blocking.newport.S1
  @ECO-12457.2
  Scenario: Blocking a subscription previously given to a device with internal CAM
    Given the server receives the following manufacturing unit detail
      | resource                                                             |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg20070811223_cam20102141732_new.xml |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    And the following subscription update is requested on management api
      | subscriptionId                       | requestBody      |
      | C1609ADE-1A71-4C25-91F7-1AEAB5177530 | {"Block": true } |
    Then I should receive a server ok response
    And the server eventually has a CALL_HOME SMS retry for flow generator 20070811223 within 5 seconds
    When by requesting messages for FG "20070811223" with internal CAM I should eventually receive the following results in 10 seconds
      | URI Fixed Part         | Content Identifier                   |
      | /api/v1/subscriptions/ | C1609ADE-1A71-4C25-91F7-1AEAB5177530 |
    And I request the subscription with identifier "C1609ADE-1A71-4C25-91F7-1AEAB5177530"
    Then I should receive the following subscription
      | json                                                                                                       |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "C1609ADE-1A71-4C25-91F7-1AEAB5177530", "Cancel": true } |
