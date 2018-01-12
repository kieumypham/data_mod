@newport
@newport.v2.broker
@ECO-15304
@ECO-4833

Feature:
  (@ECO-15304) As a clinical user
   I want to know that a malicious 3rd party cannot send messages to Machine Portal pretending to come from a machine
  so that the integrity of the system is preserved.

  (ECO-4833) As a clinician,
  I would like requests to be removed from the request broker when they are received by the device
  so they do not get delivered a second time

  # ACCEPTANCE CRITERIA: (ECO-15304)
  # Note 1: Overview of Type 2 message signing can be found at https://confluence.ec2.local/display/NGCS/Protocol+%3A+Sequence+%3A+Newport+%3A+Authentication+%3A+Type+2
  # Note 2: Message signing specification can be found at https://confluence.ec2.local/display/NGCS/00+05+Authentication
  # Note 3: Request broker endpoint specification can be found at https://confluence.ec2.local/display/NGCS/02+03+Request+Broker
  # Note 4: This card relates to ECO-4776, ECO-9423, and ECO-9855 and does not obsolete any of those ACs.
  # Note 5: Existing behavior will be re-used. For example, registration check, request queuing and ordering (FIFO), SMS sending, and only providing requests for the authorized machine will all be maintained.
  # Note 6: These endpoints will be authenticated by ECO-14745/ECO-14746 when completed.
  # 1. The request broker shall return the list of queued requests (FIFO) for the flow generator on record as being currently registered to the requesting cellular module
  # Note 7: This is for Newport's internal cellular module and Geneva CAMBridges that have been attached to a ventilator.
  # Note 8: The URI will be "/api/v2/requests/flowgenerators/paired/cellularmodules/<guid>".
  # Note 9: An example JSON response is
  # {
  #   "CM.UniversalIdentifier": "{guid}",
  #   "FG.SerialNo": "{serial number}",
  #   "Broker": [
  #     "/api/v1/upgrades/{uuid-A}",
  #     "/api/v1/subscriptions/{uuid-B}",
  #     "/api/v1/subscriptions/{uuid-C}",
  #     "/api/v1/subscriptions/{uuid-D}",
  #     "/api/v1/subscriptions/{uuid-E}",
  #     "/api/v1/subscriptions/{uuid-F}",
  #     "/api/v1/subscriptions/{uuid-G}",
  #     "/api/v1/subscriptions/{uuid-H}",
  #     "/api/v1/subscriptions/{uuid-I}",
  #     "/api/v1/subscriptions/{uuid-J}",
  #     "/api/v1/subscriptions/{uuid-K}",
  #     "/api/v1/therapy/settings/{uuid-L}",
  #     "/api/v1/climate/settings/{uuid-M}",
  #     "/api/v1/configurations/{uuid-N}",
  #     "/api/v1/subscriptions/{uuid-R}",
  #     "/api/v1/subscriptions/{uuid-S}",
  #     "/api/v1/subscriptions/{uuid-T}",
  #     "/api/v1/subscriptions/{uuid-U}",
  #     "/api/v1/subscriptions/{uuid-V}",
  #     "/api/v1/subscriptions/{uuid-W}",
  #     "/api/v1/subscriptions/{uuid-X}",
  #     "/api/v1/subscriptions/{uuid-Y}",
  #     "/api/v1/subscriptions/{uuid-Z}"
  #   ]
  # }
  # 2. The request broker shall return the list of queued requests (FIFO) for a requesting external cellular module
  # Note 10: This is for Geneva CAMBridges.
  # Note 11: The URI will be "/api/v2/requests/flowgenerators/none/cellularmodules/<guid>".
  # Note 12: An example JSON response is
  # {
  #   "CM.UniversalIdentifier": "{guid}",
  #   "Broker": [
  #     "/api/v1/upgrades/{uuid-A}",
  #     "/api/v1/configurations/{uuid-N}",
  #   ]
  # }

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

   @newport.v2.broker.S1
   @ECO-15304.1
   Scenario: For the given Cellular Module, Machine Portal shall be able to request version 2 brokered requests for paired machines with type 2 authentication
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
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
      When the server is given the following climate settings to be sent to devices
         | json                                                                                                                                                                                                                                                                          |
         | { "FG.SerialNo": "22161295306",  "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
      Then I should receive a server ok response
      When the server is given the following upgrades to be sent to devices
         | json                                                                                                                                                                                                           |
         | { "FG.SerialNo": "22161295306", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
      Then I should receive a server ok response
      When the server is given the following therapy settings to be sent to devices
         | json                                                                                                                                                                                                                                                                                                                        |
         | { "FG.SerialNo": "22161295306", "SettingsId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7", "Set.Mode": "CPAP", "CPAP.Set.Press": 14.0, "CPAP.Set.StartPress": 8.0, "CPAP.Set.EPR.EPREnable": "On", "CPAP.Set.EPR.EPRType": "FullTime", "CPAP.Set.EPR.Level": 2, "CPAP.Set.Ramp.RampEnable": "On", "CPAP.Set.Ramp.RampTime": 30 } |
      Then I should receive a server ok response
      When the cellular module updates authentication context
      And I request version 2 broker requests for paired cellular module with sufficient type 2 authentication
         | cellularModuleGuid                   |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
      And the response is signed by Authorization header based on its content with the following details
         | cellularModuleGuid                   |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
      Then I should receive the following version 2 broker requests
         | json                                                                                                                                                                      |
         | {"CAM.UniversalIdentifier":"4b9c0f45-11e9-3e0b-9fa1-c943b4d53398","FG.SerialNo":"22161295306","Broker":["/api/v1/climate/settings/3588B987-3304-4D07-97A0-BEAC1A1D06D4", "/api/v1/upgrades/B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "/api/v1/therapy/settings/DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7"]} |
      And I should receive a server ok response

   @newport.v2.broker.S2
   @ECO-15304.2
   Scenario: For the given Cellular Module, Machine Portal shall be able to request version 2 brokered requests for none paired machines with type 2 authentication
      Given the server receives the following manufacturing unit detail
         | resource                                                                               |
         | /data/manufacture/unit/detail/build_new/geneva/cellularmodule/external/20170315895.xml |
      And the server should not produce device manufactured error
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                               |
         | 131fac75-6bc8-3685-a140-a0491059d99c | /data/manufacture/unit/detail/build_new/geneva/cellularmodule/external/20170315895.xml |
      And I send newport version 3 registration data with none paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | 131fac75-6bc8-3685-a140-a0491059d99c | /data/unit/geneva/registration/cellularmodule/20170315895.json |
      Then I should receive a server ok response
      When the server is given the following upgrades to be sent to devices
         | json                                                                                                                                                                                                           |
         | { "CAM.SerialNo": "20170315895", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "CAM",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
      Then I should receive a server ok response
      When the server is given the following configurations to be sent to devices
         | json                                                                                                                                                                                                                                      |
         | {"CAM.SerialNo": "20170315895", "ConfigurationId": "962cc963-43d8-44f9-a283-b114a184b4AB", "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/cams/", "REGO-URI": "/v1/registrations/" }  |
      Then I should receive a server ok response
      When the server is given the following upgrades to be sent to devices
         | json                                                                                                                                                                                                             |
         | { "CAM.SerialNo": "20170315895", "UpgradeId": "C2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "CAM",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
      Then I should receive a server ok response
      When the cellular module updates authentication context
      And I request version 2 broker requests for none paired cellular module with sufficient type 2 authentication
         | cellularModuleGuid                   |
         | 131fac75-6bc8-3685-a140-a0491059d99c |
      And the response is signed by Authorization header based on its content with the following details
         | cellularModuleGuid                   |
         | 131fac75-6bc8-3685-a140-a0491059d99c |
      Then I should receive the following version 2 broker requests
         | json                                                                                                                                                                                                                                                          |
         | {"CAM.UniversalIdentifier":"131fac75-6bc8-3685-a140-a0491059d99c","Broker":["/api/v1/upgrades/B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "/api/v1/configurations/962cc963-43d8-44f9-a283-b114a184b4AB", "/api/v1/upgrades/C2AE8F06-1541-4616-AE6F-F9E4C079CC6E"]} |
      And I should receive a server ok response

   @newport.v2.broker.S3
   @ECO-4833.1 @ECO-4833.2 @ECO-4833.3
   Scenario: When requested by a cellular module, V2 Brokered requests should not be returned if they have been either cancelled or acknowledged.
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      Then I should receive a server ok response
      When I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
      Then I should receive a server ok response
      When the server has the following configurations to be sent to devices
         | json                                                                                                                                                                                                                              |
         | { "FG.SerialNo": "22161295306", "ConfigurationId": "962CC963-43D8-44F9-A283-B114A184B4", "Cam.Mode": "Active", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/", "REGO-URI": "/v1/registrations/" } |
      Then I should receive a server ok response
      When the cellular module updates authentication context
      And as a cellular module I acknowledge the configuration with identifier "962CC963-43D8-44F9-A283-B114A184B4" using type 2 authentication
         | json                                                                                                         |
         | { "FG.SerialNo": "22161295306", "ConfigurationId": "962CC963-43D8-44F9-A283-B114A184B4", "Status": "Received" } |
      Then I should receive a server ok response
      And the cellular module updates authentication context
      And as a cellular module I request a previous configuration with identifier "962CC963-43D8-44F9-A283-B114A184B4" using type 2 authentication
      Then I should receive a response code of "404"
      And the configuration response body should be empty
      #Climate Setting
      When the server has the following climate settings to be sent to devices
         | json   |
         | { "FG.SerialNo": "22161295306",  "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
      When the cellular module updates authentication context
      And as a cellular module I acknowledge the climate settings with identifier "3588B987-3304-4D07-97A0-BEAC1A1D06D4" using type 2 authentication
         | json                                                                                                         |
         | { "FG.SerialNo": "22161295306", "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4", "Status": "Received" } |
      Then I should receive a server ok response
      And the cellular module updates authentication context
      And as a cellular module I request a previous climate settings with identifier "3588B987-3304-4D07-97A0-BEAC1A1D06D4" using type 2 authentication
      Then I should receive a response code of "404"
      And the climate settings response body should be empty
      #Upgrades
      When the server has the following upgrades to be sent to devices
         | json                                                                                                                                                                                                           |
         | { "FG.SerialNo": "22161295306", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
      When the cellular module updates authentication context
      And as a cellular module I acknowledge the upgrade with identifier "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E" using type 2 authentication
         | json                                                                                                         |
         | { "FG.SerialNo": "22161295306", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E"  , "Status": "Received" } |
      Then I should receive a server ok response
      And the cellular module updates authentication context
      And as a cellular module I request a previous upgrade with identifier "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E" using type 2 authentication
      Then I should receive a response code of "404"
      And the upgrade response body should be empty

   @newport.v2.broker.S4
   @ECO-15304.1
   Scenario: Message Broker V2 will return flow generator serial number even if no requests exist (ECO-17077)
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
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
      When the cellular module updates authentication context
      And I request version 2 broker requests for paired cellular module with sufficient type 2 authentication
         | cellularModuleGuid                   |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
      And the response is signed by Authorization header based on its content with the following details
         | cellularModuleGuid                   |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
      Then I should receive the following version 2 broker requests
         | json                                                                                                              |
         | { "CAM.UniversalIdentifier": "4b9c0f45-11e9-3e0b-9fa1-c943b4d53398", "FG.SerialNo": "22161295306", "Broker": [] } |
      And I should receive a server ok response

   @newport.v2.broker.S5
   @ECO-15304.1
   Scenario: Message Broker V2 will return flow generator serial number even if only acknowledged requests exist (ECO-17212)
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
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
      When the server is given the following therapy settings to be sent to devices
         | json                                                                                                                                                                                                                                                                                                                        |
         | { "FG.SerialNo": "22161295306", "SettingsId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7", "Set.Mode": "CPAP", "CPAP.Set.Press": 14.0, "CPAP.Set.StartPress": 8.0, "CPAP.Set.EPR.EPREnable": "On", "CPAP.Set.EPR.EPRType": "FullTime", "CPAP.Set.EPR.Level": 2, "CPAP.Set.Ramp.RampEnable": "On", "CPAP.Set.Ramp.RampTime": 30 } |
      Then I should receive a server ok response
      When the cellular module updates authentication context
      And I request version 2 broker requests for paired cellular module with sufficient type 2 authentication
         | cellularModuleGuid                   |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
      And the response is signed by Authorization header based on its content with the following details
         | cellularModuleGuid                   |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
      Then I should receive the following version 2 broker requests
         | json                                                                                                                                                                               |
         | { "CAM.UniversalIdentifier": "4b9c0f45-11e9-3e0b-9fa1-c943b4d53398", "FG.SerialNo": "22161295306", "Broker": [ "/api/v1/therapy/settings/DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7" ] } |
      And I should receive a server ok response
      When the cellular module updates authentication context
      And as a cellular module I acknowledge the therapy settings with identifier "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7" using type 2 authentication
         | json                                                                                                         |
         | { "FG.SerialNo": "22161295306", "SettingsId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7", "Status": "Received" } |
      Then I should receive a server ok response
      When the cellular module updates authentication context
      And I request version 2 broker requests for paired cellular module with sufficient type 2 authentication
         | cellularModuleGuid                   |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
      And the response is signed by Authorization header based on its content with the following details
         | cellularModuleGuid                   |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
      Then I should receive the following version 2 broker requests
         | json                                                                                                              |
         | { "CAM.UniversalIdentifier": "4b9c0f45-11e9-3e0b-9fa1-c943b4d53398", "FG.SerialNo": "22161295306", "Broker": [] } |
      And I should receive a server ok response
