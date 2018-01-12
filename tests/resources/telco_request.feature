@telco.request
@ECO-14261


Feature:
  (@ECO-14261) As a machine manager
  I want to know that machine requests are routed to the proper Telco so that communication with and management of machines is maintained.


# ACCEPTANCE CRITERIA: (ECO-14261)
# 1. When the Telco Manager receives a send SMS request for an Aeris machine, the Aeris Manager shall be given the send SMS request.
# 2. When the Telco Manager receives a send Scrap request for an Aeris machine, the Aeris Manager shall be given the send Scrap request.
# 3. When the Telco Manager receives a send SMS request for an Vodafone machine, the Vodafone Manager shall be given the send SMS request.
# 4. When the Telco Manager receives a send Scrap request for an Vodafone machine, the Vodafone Manager shall be given the send Scrap request.

  Background:
    Given the server receives the following manufacturing unit detail
      | resource                                                |
      | /data/manufacturing/unit_detail_006_10000000001_new.xml |
      | /data/manufacturing/unit_detail_010_10000000001_new.xml |
    Then the server should not produce device manufactured error
    And the server has the following flow generators
      | serialNo    | deviceNumber | mid | vid | productCode | hasCellularModule         | managedByThisSystem | status | software   |
      | 10000000001 | 121          | 36  | 25  | 37001       | true                      | true                | NEW    | SX567-0100 |
      | 10000000002 | 122          | 36  | 25  | 37001       | true                      | true                | NEW    | SX567-0100 |
    And the server has the following comm modules
      | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   | status      |
      | 10000000001 | 13152G00001  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 | PROVISIONED |
      | 10000000002 | 13152G00002  | ACTIVE             | ACTIVE             | VODAFONE             | SX558-0100 | PROVISIONED |
    And the cellular module requests security tokens and establishes authentication context
      | cellularModuleIdentifier             | manufacturingXmlFileName                                        |
      | 61c86bd6-044a-312b-8604-d810641fe1c0 | /data/manufacturing/unit_detail_006_10000000001_new.xml         |
    And I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
      | cellularModuleGuid                   | json                                                           |
      | 61c86bd6-044a-312b-8604-d810641fe1c0 | /data/newport/registration/10000000001.json |
    Then I should receive a server ok response
    And the cellular module requests security tokens and establishes authentication context
      | cellularModuleIdentifier             | manufacturingXmlFileName                                        |
      | 0629bd1a-3399-3ed1-9c1c-1a4c6b104173 | /data/manufacturing/unit_detail_010_10000000001_new.xml         |
    And I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
      | cellularModuleGuid                   | json                                                           |
      | 0629bd1a-3399-3ed1-9c1c-1a4c6b104173 | /data/newport/registration/10000000002.json |
    Then I should receive a server ok response
    And I verify that NGCS does not store any subscriptions for communication module with serial number "10000000001"
    And I verify that NGCS does not store any subscriptions for communication module with serial number "10000000002"


 @telco.request.S1
 @ECO-14261
   Scenario: Verify that the aeris manager is given a send sms request when the telco manager receives a send SMS request for an aeris machine.
   Given the aeris telco manager receives a send SMS request for a given flow gen serial number 10000000001
   Then there should be a jms message in aeris sms send message
     | moduleSerialNo  | flowGenSerialNo | messageType | vendorCode  | cdmaMdn            |
     |  10000000001    | 10000000001     | CALL_HOME    | AERIS      |  1000000000000000  |

 @telco.request.S2
 @ECO-14261
   Scenario: Verify that the aeris manager is given a send scrap request when the telco manager receives a send scrap request for an aeris machine.
   Given the aeris telco manager receives a send scrap request for a flow gen serial number 10000000001
   Then there should be a jms message in aeris admin message
     | serialNo        | software            | boot             | status         | pcbaSerialNo  | pcbaPartNo     | pcbaVersionNo  |   camHostName       |    camPortNo  |  internalCam    |  defaultSilentState |  currentSilentState   |   telcoCarrierProvider  |   activationDateTime      |  buildDateTime          |
     | 10000000001     | SX567-0100          | SX999-0123       | ACTIVE         |   13152G00001 | R379-702       | 01             |    10.10.134.45     |    31266      |     true        |   ACTIVE            |  ACTIVE               |    AERIS                |     2014-01-05T08:19:32Z  |  2014-01-22T14:48:55Z   |

 @telco.request.S3
 @ECO-14261
   Scenario: Verify that the vodafone manager is given an sms request when the telco manager receives an SMS request for a vodafone machine.
   Given the vodafone telco manager receives a send SMS request for a given flow gen serial number 10000000002
   Then there should be a jms message in vodafone sms send message
     | moduleSerialNo  | flowGenSerialNo | messageType | vendorCode    | cdmaMdn           |
     |  10000000002    | 10000000002     | CALL_HOME   | VODAFONE      | 1000000000000001  |

 @telco.request.S4
 Scenario: Verify that the vodafone manager is given a send scrap request when the telco manager receives a send scrap request for a vodafone machine.
   Given the vodafone telco manager receives a send scrap request for a flow gen serial number 10000000002
   Then there should be a jms message in vodafone admin message sender
     | serialNo        | software            | boot             | status         | pcbaSerialNo  | pcbaPartNo     | pcbaVersionNo  |   camHostName       |    camPortNo  |  internalCam    |  defaultSilentState |  currentSilentState   |   telcoCarrierProvider  |  activationDateTime      |  buildDateTime          |
     | 10000000002     | SX558-0100          | SX999-0123       | ACTIVE         |   13152G00002 | R379-703       | 02             |    10.10.134.45     |    31266      |     true        |   ACTIVE            |  ACTIVE               |    VODAFONE             |    2014-01-06T08:19:32Z  |  2014-01-23T14:48:55Z   |



