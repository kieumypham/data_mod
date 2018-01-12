@cellular.module.network.state
@ECO-17431

Feature:
  (ECO-17431) As a fleet manger
  I want to receive cellular module network state
  so that I can monitor cellular module network performance

  # ACCEPTANCE CRITERIA: (ECO-17431)
  #  Note 1: Cellular module network state service specification (HTTP method, URI, etc) can be found at https://confluence.ec2.local/display/NGCS/16+00+Cellular+Module
  #  Note 2: Implementation notes are provided to capture and consolidate the current NGCS machine data workflow patterns
  #
  #  1. The server shall receive network state publications from machines
  #  1a. The server shall authenticate the request using Type 2 Authentication protocol
  #  Note 3: Message authentication specification can be found at https://confluence.ec2.local/display/NGCS/00+05+Authentication. This has been implemented as various interceptors and should simply be configuration of a new CXF bean.
  #  1b. The server shall redirect an authenticated request if necessary
  #  Note 4: Cellular module redirect specification can be found at https://confluence.ec2.local/display/NGCS/15+00+Redirect. This has been implemented as an interceptor and should simply be configuration of the new CXF bean.
  #  1c. The server shall authorize acceptance of an authenticated request using the Authorization protocol
  #  Note 5: Message authorization specification can be found at https://confluence.ec2.local/display/NGCS/01+01+Authorization. This has been implemented as an interceptor and should simply be configuration of the new CXF bean.
  #  Note 6: The endpoint needs to add NGCS standard Camel headers when passing the accepted message and notify the system that a machine has delivered a message. This has been implemented as a Camel route and should simply be the calling of "direct-vm:prepareDeviceDataReception". Additionally, the response needs to have all HTTP headers removed - this should be done by simply calling the existing "direct-vm:prepareNewportResponse" Camel route.
  #  1d. The server shall return a HTTP response code of 202 (Accepted) for accepted (authenticated and authorized) network state messages
  #  Note 7: Accepted network state messages should be placed on a "to be validated" JMS queue (CellularModuleNetworkStateValidation).
  #
  #  2. When an accepted network state message does not pass validation, the server shall reject the message
  #  Note 8: Standard validation (see https://confluence.ec2.local/display/NGCS/Machine+Data+Validation for overview) should be incorporated by using the "direct-vm:validateIdentityAndSubscription" Camel route and checking for a ValidationVetoPoint value (not null) from the calling Camel route. Field validation is described in the cellular module network state specification at https://confluence.ec2.local/display/NGCS/16+00+Cellular+Module and should use the existing NGCS JSON Schema based validation library.
  #  Note 9: Rejected messages should be "logged" to a JMS queue (InvalidCellularModuleNetworkState) with sufficient JMS headers (i.e. ValidationVetoPoint, ValidationFilureType, etc.) for validation failure identification
  #
  #  3. The server shall send a cellular module network state received event for valid network state messages
  #  Note 10: Valid messages will be published to a JMS queue (CellularModuleNetworkState) with appropriate JMS headers (i.e. JMSXGroupID) as the event. No consumption of this JMS queue will be implemented in NGCS. In other words, this new message type will not be stored in HI Cloud.
  #
  #  Note 11: New subscription template needs to be added to https://stash.ec2.local/projects/AV/repos/system-specification/browse/Devices:
  #  {
  #  "FG.SerialNo": "%SERIAL_NUMBER%",
  #  "SubscriptionId": "%UUID%",
  #  "ServicePoint": "/api/v1/cellularmodules/networks/states",
  #  "Trigger": {
  #  "Collect": [
  #  "HALO"
  #  ],
  #  "Conditional": {},
  #  "OnlyOnChange": false,
  #  },
  #  "Schedule": {
  #  "StartDate": null,
  #  "EndDate": null
  #  },
  #  "Data": [
  #  "Val.CamSerial",
  #  "Val.CamSid",
  #  "Val.ModuleType",
  #  "Val.Connected",
  #  "Val.ConnectClass",
  #  "Val.CarrierName",
  #  "Val.SignalDBm",
  #  "Val.AvailableCarriers"
  #  ]
  #  }
  #


  Background:

  @cellular.module.network.state.S1
  @ECO-17431.1a @ECO-17431.1b @ECO-17431.1c @ECO-17431.1d @ECO-17431.2 @ECO-17431.3
  Scenario: Cellular module network state data post from device with type 2 authentication
    Given the server receives the following manufacturing unit detail
      | resource                                                                      |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 22161295306               | 22161295306                     |
    And I am a device with the FlowGen serial number "22161295306"
    And the cellular module requests security tokens and establishes authentication context
      | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
    When I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
      | cellularModuleGuid                   | json                                                           |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
    Then I should receive a server ok response
    And the server waits for all related device registration queues to be empty
    And I pause for 30 seconds
    When the newport management queue received the following "SUBSCRIPTION" messages
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "ac4ef513-13de-4f82-9c49-e6385f887dfe", "ServicePoint": "/api/v1/cellularmodules/networks/states", "Trigger": { "Collect": [ "HALO" ], "Conditional": {}, "OnlyOnChange": false }, "Schedule": { "StartDate": null, "EndDate": null }, "Data": ["Val.CamSerial", "Val.CamSid", "Val.Connected"] } |
    Then the server has a CALL_HOME SMS retry for flow generator 22161295306
    And the cellular module requests security tokens and establishes authentication context
      | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
    And I request version 2 broker requests for paired cellular module with sufficient type 2 authentication
      | cellularModuleGuid                   |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    And the response is signed by Authorization header based on its content with the following details
      | cellularModuleGuid                   |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    Then I should receive the following version 2 broker requests
      | json                                                                                                                                                  |
      | { "CAM.UniversalIdentifier": "4b9c0f45-11e9-3e0b-9fa1-c943b4d53398", "FG.SerialNo": "22161295306", "Broker": [ "/api/v1/subscriptions/<ANY_UUID>" ] } |
    And I should receive a server ok response
    When the cellular module updates authentication context
    And the machine sends the following network state with type 2 authentication
      | json                                                                                                                                                                                                                                 |
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "ac4ef513-13de-4f82-9c49-e6385f887dfe","CollectTime": "today 010101","Date": "1  day ago", "Val.CamSerial" : "22161295306", "Val.Connected": true, "Val.CamSid": "Some Sid Value"} |
    Then I should receive a server Accepted response
    And the following device network state events have been published
      | JMSType      | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                                                                                 |
      | NETWORK_STATE| 22161295306 | DEVICE           | 22161295306               | 36                       | 39                      | { "FG.SerialNo": "22161295306", "SubscriptionId": "ac4ef513-13de-4f82-9c49-e6385f887dfe","CollectTime": "today 010101","Date": "1  day ago", "Val.CamSerial" : "22161295306", "Val.Connected": true, "Val.CamSid": "Some Sid Value"} |
    When the cellular module updates authentication context
    And the machine sends the following network state with type 2 authentication
      | json                                                                                                                                                                                                        |
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "ac4ef513-13de-4f82-9c49-e6385f887dfe","CollectTime": "today 010101","Date": "1  day ago", "Val.CamSerial" : 22161295306, "Val.CamSid": "Some Sid Value"} |
    Then I should receive a server Accepted response
    And the following device invalid network state events have been published
      | JMSType       | JMSXGroupID | DeviceDataSource | flowGenSerialNumber | ValidationVetoPoint| ValidationFailureType | json                                                                                                                                                                                                       |
      | NETWORK_STATE | 22161295306 | DEVICE           | 22161295306         | FIELD_VALIDATION   | NETWORK_STATE_FIELD   | { "FG.SerialNo": "22161295306", "SubscriptionId": "ac4ef513-13de-4f82-9c49-e6385f887dfe","CollectTime": "today 010101","Date": "1  day ago", "Val.CamSerial" : 22161295306, "Val.CamSid": "Some Sid Value"}|
    When the cellular module updates authentication context
    And the machine sends the following network state with type 2 authentication
      | json                                                                                                                                                                                                        |
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "ac4ef513-13de-4f82-9c49-e6385f887dfe","CollectTime": "today 010101","Date": "1  day ago", "Val.CamSerial" : 22161295306, "Val.CamSid": "Some Sid Value"} |
    Then the following device invalid network state events have been published
      | ValidationFailureReason                                                                                                                                                                                                                                                                                                                                        |
      | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/definitions.json#","pointer":"/definitions/resmedSerialNumber"},"instance":{"pointer":"/Val.CamSerial"},"domain":"validation","keyword":"type","message":"instance type does not match any allowed primitive type","expected":["string"],"found":"integer"} ] } |
    When the cellular module updates authentication context
    And the machine sends the following network state with type 2 authentication
      | json                                                                                                                                                                                                                                 |
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "ac4ef513-13de-4f82-9c49-e6385f887dfe","CollectTime": "today 010101","Date": "1  day ago", "Val.CamSerial" : "22161295306", "Val.CamSid": "Some Sid Value", "Val.Connected": True} |
    Then the following device invalid network state events have been published
      | JMSType       |  DeviceDataSource | ValidationVetoPoint| ValidationFailureType |
      | NETWORK_STATE | DEVICE            | IDENTITY_VALIDATION| IDENTITY_FIELD        |
    When Fleet manager sends the following redirect descriptors to be persisted
      | cellularModuleGuid                   | jsonFile                                                                   | responseCode |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/management/redirect/cellularmodule/redirect_descriptor_create_3.json | 201          |
    And the cellular module updates authentication context
    And the machine sends the following network state with type 2 authentication
      | json                                                                                                                                                                                                                                 |
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "ac4ef513-13de-4f82-9c49-e6385f887dfe","CollectTime": "today 010101","Date": "1  day ago", "Val.CamSerial" : "22161295306", "Val.Connected": true, "Val.CamSid": "Some Sid Value"} |
    Then I should receive a server Permanent Redirect response
    And the response is signed by Authorization header based on its content with the following details
      | cellularModuleGuid                   |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    And I should receive the following message in the response body
      | jsonFile                                                          |
      | /data/management/redirect/cellularmodule/redirect_response_3.json |