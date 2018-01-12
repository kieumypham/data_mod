@sms.retry
@ECO-15504


Feature:
  (@ECO-15504) As a machine manager
  I want to know that machine retry SMSes are on the proper Telco specific schedule so that communication with and management of machines is maintained.


# ACCEPTANCE CRITERIA: (ECO-15504)
# Note 1: ECO-15148 was implemented to allow examination of retry SMSes. These endpoints should be used in preference to waiting for a message to show up on the Telco's manager JMS queues.
# 1. When the Telco Manager receives a send SMS request for a registered Aeris machine which does not already have a retry SMS, a retry SMS shall be scheduled for the Aeris specific number of days in the future.
# Note 2: The number of Aeris days is configurable, currently defaulted to 3 days.
# 2. When the Telco Manager receives a send SMS request for a registered Aeris machine which already has a retry SMS, the retry SMS shall be re-scheduled for the Aeris specific number of days in the future.
# 3. When the Telco Manager receives a send SMS request for a registered Vodafone machine which does not already have a retry SMS, a retry SMS shall be scheduled for the Vodafone specific number of days in the future.
# Note 3: The number of Vodafone days is configurable, currently defaulted to 7 days.
# 4. When the Telco Manager receives a send SMS request for a registered Vodafone machine which already has a retry SMS, the retry SMS shall be re-scheduled for the Vodafone specific number of days in the future.

  Background:
    Given the server receives the following manufacturing unit detail
      | resource                                                |
      | /data/manufacturing/unit_detail_001_10000000002_new.xml |
      | /data/manufacturing/unit_detail_001_10000000001_new.xml |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 10000000001               | 10000000001                     |
      | 10000000002               | 10000000002                     |
    And I am a device with the FlowGen serial number "10000000001"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                            |
      | { "FG": {"SerialNo": "10000000001", "Software": "SX567-0305", "MID": 36, "VID": 25, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030008", "ProductCode":"37001", "Configuration": "CX036-026-008-024-101-101-105" }, "CAM": {"SerialNo": "10000000001", "Software": "SX558-0100", "PCBASerialNo":"13152G00011","Subscriptions": ["B884F699-84ED-446E-10000000001"] }, "Hum": {"Software": "SX558-0305"} } |
    And I am a device with the FlowGen serial number "10000000002"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                            |
      | { "FG": {"SerialNo": "10000000002", "Software": "SX567-0306", "MID": 36, "VID": 25, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030009", "ProductCode":"37001", "Configuration": "CX036-026-008-024-101-101-106" }, "CAM": {"SerialNo": "10000000002", "Software": "SX558-0306", "PCBASerialNo":"13152G00012", "Subscriptions": ["B884F699-84ED-446E-10000000001"] }, "Hum": {"Software": "449000226"} } |

  @sms.retry.S1
  @ECO-15504.1
  Scenario: Verify that when the Telco Manager receives a send SMS request for a registered Aeris machine which does not
  already have a retry SMS, a retry SMS is scheduled for the Aeris specific number of days in the future.
    Given the aeris telco manager receives a send SMS request for a given flow gen serial number 10000000001
    Then the flowGen with serial number "10000000001" sms retry time in the database shall be scheduled for the Aeris 3 days from the time of the sms request

  @sms.retry.S2
  @ECO-15504.2
  Scenario: Verify that when the Telco Manager receives a send SMS request for a registered Aeris machine which
  already has a retry SMS, a retry SMS is scheduled for the Aeris specific number of days in the future.
    Given the aeris telco manager receives a send SMS request for a given flow gen serial number 10000000001
    And the aeris telco manager receives a send SMS request for a given flow gen serial number 10000000001
    Then the flowGen with serial number "10000000001" sms retry time in the database shall be scheduled for the Aeris 3 days from the time of the sms request
    And the sms retry count is 1

  @sms.retry.S3
  @ECO-15504.3
  Scenario: Verify that when the Telco Manager receives a send SMS request for a registered Vodafone machine which does not
  already have a retry SMS, a retry SMS is scheduled for the Vodafone specific number of days in the future.
    Given the vodafone telco manager receives a send SMS request for a given flow gen serial number 10000000002
    Then the flowGen with serial number "10000000002" sms retry time in the database shall be scheduled for the Vodafone 7 days from the time of the sms request

  @sms.retry.S4
  @ECO-15504.4
  Scenario: Verify that when the Telco Manager receives a send SMS request for a registered Vodafone machine which already has a retry SMS,
  a retry SMS shall be scheduled for the Vodafone specific number of days in the future.
    Given the aeris telco manager receives a send SMS request for a given flow gen serial number 10000000002
    And the aeris telco manager receives a send SMS request for a given flow gen serial number 10000000002
    Then the flowGen with serial number "10000000002" sms retry time in the database shall be scheduled for the Vodafone 7 days from the time of the sms request
    And the sms retry count is 1
