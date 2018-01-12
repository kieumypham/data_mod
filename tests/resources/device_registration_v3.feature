@newport
@newport.registration.v3
@ECO-14749
@ECO-15303
@ECO-14752

Feature:

  (ECO-14749) As ECO
   As a clinical user I want to know that a malicious 3rd party cannot send messages to Machine Portal pretending to come from a machine
  so that the integrity of the system is preserved.

  (ECO-15303) As ECO
   As a clinical user I want to know that a malicious 3rd party cannot send messages to Machine Portal pretending to come from a machine
  so that the integrity of the system is preserved.

  (ECO-14752) As a clinical user
   I want to know that a malicious 3rd party cannot send messages to Machine Portal pretending to come from a Newport
  so that the integrity of the system is preserved.

# ACCEPTANCE CRITERIA: (ECO-14749)
# 1. The server shall receive cellular module registration information from an external cellular module not connected to a machine
# Note 7: This is for Geneva CAMBridges which can register on their own.
# Note 8: The URI will be "/api/v3/registrations/flowgenerators/none/cellularmodules/<guid>". The JSON format is as per ECO-9414.
# 2. The server shall receive machine registration information from machines with an attached cellular module
# Note 9: This is for Newport's internal cellular module and Geneva CAMBridges that have been attached to a ventilator.
# Note 10: The URI will be "/api/v3/registrations/flowgenerators/paired/cellularmodules/<guid>". The JSON format is as per ECO-9421.
# 3. The server shall receive machine pairing confirmation from machines still connected to an external cellular module
# Note 11: This is for Geneva CAMBridges that need to confirm their pairing state.
# Note 12: The URI will be "/api/v3/registrations/flowgenerators/paired/cellularmodules/<guid>". The JSON format is as per ECO-10070.

# ACCEPTANCE CRITERIA: (ECO-15303)
# 1. All response messages to a machine's request shall include a signature
# 1a. When the response contains message content, the signature shall be calculated over the message content
# 1b. When the response does not contain any message content, the signature shall be calculated over generated content
# Note 5: The generated content will be 32 securely random bytes.

# ACCEPTANCE CRITERIA: (ECO-14752)
# Note 1: Overview of Type 2 message authentication can be found at https://confluence.ec2.local/display/NGCS/Protocol+%3A+Sequence+%3A+Newport+%3A+Authentication+%3A+Type+2
# Note 2: Message authentication specification can be found at https://confluence.ec2.local/display/NGCS/00+05+Authentication
# Note 3: Security Token (Encryption and Signing) generation is implemented by ECO-14744. Signature validation is implemented by ECO-14745 and ECO-14746. Encryption validation is implemented by ECO-14748 and ECO-14747.
# Note 4: Once an in-field upgraded cellular module successfully registers with the V3 endpoint (https://confluence.ec2.local/display/NGCS/01+03+Registration) and Type 2 authentication, the cellular module should not be allowed to use Type 1 authentication against any endpoint in the future. Likewise, cellular modules manufactured with the firmware that implements Type 2 authentication and successfully registers with the V3 endpoint and Type 2 authentication should not be allowed to use Type 1 authentication against any endpoint in the future. Using registration instead of the get security token endpoint is preferable as the use of the security token endpoint could be used to lock all machines out of the system. This card implements the capture of the Type 2 "switch" for the cellular module and the check of the captured switch state.
# 1. When a machine successfully authenticates and registers using the version 3 registration endpoint, the server shall persist that the machine can no longer use Type 1 authentication
# 2. When a machine that can no longer use Type 1 authentication attempts to use Type 1 authentication, the request shall be rejected
# 2a. The client will get a HTTP response code of 401 (Unauthorized)
# 2b. The authentication failure will be logged
# Note 5: The logging will be an event sent to a JMS Dead Letter Queue (DLQ) including headers providing failure details (AuthenticationVetoPoint, AuthenticationFailureType, AuthenticationFailureReason. Optionally, AuthenticationExceptionStackTrace, and AuthenticationExceptionMessage)

   Background:

###########################################################
#                      EXTERNAL CAM                       #
###########################################################

   @newport.registration.v3.S1
   @ECO-14749.1
   @ECO-15303.1b
   @ECO-14752.1 @ECO-14752.2 @ECO-14752.2a @ECO-14752.2b
   Scenario: Register CAMBridge (by itself, no flow generator at this stage)
      Given the server receives the following manufacturing unit detail
         | resource                                                                               |
         | /data/manufacture/unit/detail/build_new/geneva/cellularmodule/external/20170315895.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | communicationModuleSerialNumber |
         | 20170315895                     |
      And the unit is composed of cellular module "20170315895"
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                               |
         | 131fac75-6bc8-3685-a140-a0491059d99c | /data/manufacture/unit/detail/build_new/geneva/cellularmodule/external/20170315895.xml |
      When I send newport version 3 registration data with none paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | 131fac75-6bc8-3685-a140-a0491059d99c | /data/unit/geneva/registration/cellularmodule/20170315895.json |
      Then I should receive a server ok response
      And the response is signed by Authorization header based on its content with the following details
         | cellularModuleGuid                   |
         | 131fac75-6bc8-3685-a140-a0491059d99c |
      And the server has logged an external cam registration
      And the communication module with serial number "20170315895" should eventually have a status of "ACTIVE" within 6 seconds
      # Verify that the device can no longer authenticate with Type 1 authentication
      Given I send the following version 2 registration
          """
          {
            "Bridge": {
              "Software": "BRIDGE_SW",
              "MID": 51,
              "VID": 1,
              "ProductCode": "54263",
              "PCBASerialNo": "1A345678"
            },
            "CAM": {
              "SerialNo": "20170315895",
              "Software": "CAM_SOFTWARE",
              "PCBASerialNo": "622895031"
            }
          }
          """
      Then I should receive a server Unauthorized response
      And the following invalid newport authentication error was published
         | expect | authenticationVetoPoint | authenticationFailureType | authenticationFailureReason                                                                             | body |
         | yes    | AUTHENTICATION          | SIGNATURE_TYPE            | Device with serial "20170315895" is pinned to Type 2 authentication and cannot use Type 1 authentication|      |

###########################################################
#                      INTERNAL CAM                       #
###########################################################

   @newport.registration.v3.S2
   @ECO-14749.2
   @ECO-15303.1b
   @ECO-14752.1 @ECO-14752.2 @ECO-14752.2a @ECO-14752.2b
   Scenario: Registration of device with internal CAM, using v3 interface, first time for FG and for CAM
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 22161295306               | 22161295306                     |
      And the unit is composed of flow generator "22161295306"
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      Then I should receive a server ok response
      When I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
      Then I should receive a server ok response
      And the response is signed by Authorization header based on its content with the following details
         | cellularModuleGuid                   |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
      And 1 count of registration history where flow generator has an paired communication module has been added

   @newport.registration.v3.S3
   @ECO-14749.3
   @ECO-15303.1b
   Scenario: Received pairing message from registered communication module with its currently paired flow generator.
      Given the server receives the following manufacturing unit detail
         | resource                                                                               |
         | /data/manufacture/unit/detail/build_new/geneva/flowgenerator/22170938807.xml           |
         | /data/manufacture/unit/detail/build_new/geneva/flowgenerator/22170939918.xml           |
         | /data/manufacture/unit/detail/build_new/geneva/cellularmodule/external/20170315895.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 22170938807               | 20170315895                     |
      And the unit is composed of flow generator "22170938807" and cellular module "20170315895"
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                               |
         | 131fac75-6bc8-3685-a140-a0491059d99c | /data/manufacture/unit/detail/build_new/geneva/cellularmodule/external/20170315895.xml |
      And I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                                      |
         | 131fac75-6bc8-3685-a140-a0491059d99c | /data/unit/geneva/registration/flowgenerator/22170938807_20170315895.json |
      Then I should receive a server ok response
      And the response is signed by Authorization header based on its content with the following details
         | cellularModuleGuid                   |
         | 131fac75-6bc8-3685-a140-a0491059d99c |
      Then 1 count of registration history where flow generator has an paired communication module has been added
      And the communication module with serial number "20170315895" should be paired with the flow generator with serial number "22170938807"
      When the cellular module updates authentication context
      And I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                                              |
         | 131fac75-6bc8-3685-a140-a0491059d99c | /data/unit/geneva/registration/flowgenerator/22170938807_20170315895_pairing.json |
      Then 1 count of registration history where flow generator has an paired communication module is found
      Then I should receive a server ok response
      # Verifying pairing is preserved (unchanged from last registration)
      And the communication module with serial number "20170315895" should be paired with the flow generator with serial number "22170938807"
      And the server should not log an invalid registration
      #Ensure that the sms retry record for a previous flowgen/ventilator is removed if the communication module is paired with a different flowgen/ventilator
      And the server has the following subscriptions to be sent to devices
       | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
       | { "FG.SerialNo": "22170938807", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
     And there exists 1 sms retry entry for flowGen with serial number "22170938807"
     And the following units are cached for local use
       | flowGeneratorSerialNumber | communicationModuleSerialNumber |
       | 22170939918               | 20170315895                     |
     And the unit is composed of flow generator "22170939918" and cellular module "20170315895"
     And the cellular module requests security tokens and establishes authentication context
       | cellularModuleIdentifier             | manufacturingXmlFileName                                                               |
       | 131fac75-6bc8-3685-a140-a0491059d99c | /data/manufacture/unit/detail/build_new/geneva/cellularmodule/external/20170315895.xml |
     And I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
       | cellularModuleGuid                   | json                                                                      |
       | 131fac75-6bc8-3685-a140-a0491059d99c | /data/unit/geneva/registration/flowgenerator/22170939918_20170315895.json |
     Then I should receive a server ok response
     And the communication module with serial number "20170315895" should be paired with the flow generator with serial number "22170939918"
     And I pause for 5 seconds
     And there exists 0 sms retry entry for flowGen with serial number "22170938807"

   @newport.registration.v3.S4
   @ECO-14749.3
   @ECO-15303.1b
   Scenario: Received pairing message from registered communication module with a flow generator not currently paired.
      Given the server receives the following manufacturing unit detail
         | resource                                                                               |
         | /data/manufacture/unit/detail/build_new/geneva/flowgenerator/22170938807.xml           |
         | /data/manufacture/unit/detail/build_new/geneva/flowgenerator/22170939918.xml           |
         | /data/manufacture/unit/detail/build_new/geneva/cellularmodule/external/20170315895.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 22170938807               | 20170315895                     |
      And the unit is composed of flow generator "22170938807" and cellular module "20170315895"
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                               |
         | 131fac75-6bc8-3685-a140-a0491059d99c | /data/manufacture/unit/detail/build_new/geneva/cellularmodule/external/20170315895.xml |
      And I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                                      |
         | 131fac75-6bc8-3685-a140-a0491059d99c | /data/unit/geneva/registration/flowgenerator/22170938807_20170315895.json |
      Then I should receive a server ok response
      And the response is signed by Authorization header based on its content with the following details
         | cellularModuleGuid                   |
         | 131fac75-6bc8-3685-a140-a0491059d99c |
      Then 1 count of registration history where flow generator has an paired communication module has been added
      And the communication module with serial number "20170315895" should be paired with the flow generator with serial number "22170938807"
      When the cellular module updates authentication context
      And I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                                              |
         | 131fac75-6bc8-3685-a140-a0491059d99c | /data/unit/geneva/registration/flowgenerator/22170939918_20170315895_pairing.json |
      Then I should receive a response code of "424"
      # Verifying pairing is preserved (unchanged from last registration and undamaged from unsuccessful pairing)
      And the communication module with serial number "20170315895" should be paired with the flow generator with serial number "22170938807"
      # Verify that the device can no longer authenticate with Type 1 authentication
      Given I am a device with the FlowGen serial number "22170938807"
      And I send the following registration
         | json                                                                                                                                                                                                                                                                                                                              |
         | { "FG": {"SerialNo": "22170938807", "Software": "SX558-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030008", "ProductCode":"27093", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20000000006", "Software": "SX558-0100", "PCBASerialNo":"23152G00005", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
      Then I should receive a server Unauthorized response
      And the following invalid newport authentication error was published
         | expect | authenticationVetoPoint | authenticationFailureType | authenticationFailureReason                                                                             | body |
         | yes    | AUTHENTICATION          | SIGNATURE_TYPE            | Device with serial "20170315895" is pinned to Type 2 authentication and cannot use Type 1 authentication|      |
      And I am a device with the FlowGen serial number "22170938807"
      When I send the following version 2 registration
      """
      {
        "FG":{"SerialNo": "22170938807", "Software": "SX558-0100", "MID": 36, "VID": 33, "PCBASerialNo":"(90)R370-7224(91)P3(21)41030008",
              "ProductCode":"27093", "Configuration": "CX036-001-001-001-100-100-100"},
        "CAM": {"SerialNo": "20170315895", "Software": "SX558-0100", "PCBASerialNo":"622895031"},
        "Hum": {"Software": "SX556-0100"},
        "Subscriptions": []
      }
      """
      Then I should receive a server Unauthorized response
      And the following invalid newport authentication error was published
         | expect | authenticationVetoPoint | authenticationFailureType | authenticationFailureReason                                                                             | body |
         | yes    | AUTHENTICATION          | SIGNATURE_TYPE            | Device with serial "20170315895" is pinned to Type 2 authentication and cannot use Type 1 authentication|      |
