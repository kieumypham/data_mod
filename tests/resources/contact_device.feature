@cam
@newport
@newport.contact
@contact.device
@ECO-5572
@ECO-5570
@ECO-5837
@ECO-7489
@ECO-7321
@ECO-18746
@ECO-18780

Feature:
  (ECO-5572) As EU ECO
   I want to send an SMS to an S10 device so that it can establish communications

  (ECO-5570) As EU ECO
   I want to return a device to Silent mode
  so that a patient's data is no longer being sent.

  (ECO-7489) As EU ECO
   I want to send an SMS to an S10 device
  so that it can establish communications.

  (ECO-7321) As ECO
   I want to ensure that a CAM scrapped during field service or through the manufacturing interface has its pending SMS's cancelled and further SMS's prevented
  so that I do not send unnecessary SMS's.

  (ECO-18746) As a telco cost manager,
   I want to reduce the number of SMSes sent to unavailable machines
   so that costs are reduced.

  (ECO-18780) As a telco cost manager,
   I want to stop sending SMSes to a device when is suspended and resume when it gets active again,
   so that costs are reduced.

  # ACCEPTANCE CRITERIA: (ECO-5572)
  # 1. When an S10 device is added to a patient and the device's CAM is in a silent state at time of manufacture (see note 4), an SMS shall be sent to the device. Note 1: On the Vodafone network, this may be accomplished using a wake-up trigger.
  # Note 3: Due to privacy regulations in the EU, a device cannot post data to ECO without having consent from the patient. Thus these EU devices are set to a "silent" mode at manufacture and the addition of the device to an ECO patient constitutes consent to collecting data.
  # Note 4: The silent state may be determined by the field CamSilentState as indicated in D379-513.

  # ACCEPTANCE CRITERIA: (ECO-5837)
  # 1. If the S10 device being added has not registered within n days, a new SMS shall be sent.
  # 1a. On the Vodafone network, the number of days n shall be 7 days. Note 2: the new SMS should be a replacement to the previously sent SMS, rather than a new one.
  # 1b. On the Aeris network, the number of days n shall be 3 days.

  # ACCEPTANCE CRITERIA: (ECO-5570)
  # 1. When an S10 device is removed from a patient and the device's CAM was in a silent state at time of manufacture (see note 2), a request shall be queued to return it to a silent state.
  # 2. When a patient with an S10 device is deleted and the device's CAM was in a silent state at time of manufacture, a request shall be queued to return it to a silent state.
  # Note 1: Due to privacy regulations in the EU, a device cannot post data to ECO without having consent from the patient. Thus these EU devices are set to a "silent" mode at manufacture and the deletion of the device from an ECO patient constitutes withdrawing consent from collecting data.
  # Note 2: The silent state may be determined by the field CamSilentState as indicated in D379-513.
  # Note 3: It is important that the SMS generated from the request to return the CAM to silent state is retried if unsuccessful.
  # Note 4: The sequence diagram for the configuration workflow is at http://confluence.corp.resmed.org/download/attachments/13993414/Newport+Sequence+v15+09+01+Configuration.pdf?version=1&modificationDate=1393895280842

  # ACCEPTANCE CRITERIA: (ECO-5570)
  # 1. When an S10 device is removed from a patient and the device's CAM was in a silent state at time of manufacture (see note 2), a request shall be queued to return it to a silent state.
  # 2. When a patient with an S10 device is deleted and the device's CAM was in a silent state at time of manufacture, a request shall be queued to return it to a silent state.
  # Note 1: Due to privacy regulations in the EU, a device cannot post data to ECO without having consent from the patient. Thus these EU devices are set to a "silent" mode at manufacture and the deletion of the device from an ECO patient constitutes withdrawing consent from collecting data.
  # Note 2: The silent state may be determined by the field CamSilentState as indicated in D379-513.
  # Note 3: It is important that the SMS generated from the request to return the CAM to silent state is retried if unsuccessful.
  # Note 4: The sequence diagram for the configuration workflow is at http://confluence.corp.resmed.org/download/attachments/13993414/Newport+Sequence+v15+09+01+Configuration.pdf?version=1&modificationDate=1393895280842

  # ACCEPTANCE CRITERIA: (ECO-7489)
  # Note 1: This story extends device silent/awake functionality to support myAir EU. See the attached email chain for discussion in this area.
  # 1. When a Newport device's CAM is in a silent state, an SMS shall be sent to the device for any of the following actions:
  # 1a. The device is added to a patient through ECX2.
  # 1b. An integrator subscribes to notifications for the device serial number. Note: See createDeviceSubscription API.
  # Note: Adding to a patient through the UI is covered by ECO-5572 AC#1.
  # 2. When a Newport device's CAM was in a silent state at time of manufacture, a request shall be queued to return it to a silent state when all of the following conditions are met:
  # 2a. The device is not assigned to a patient in AirView
  # 2b. No integrators are subscribed to notifications for the device serial number
  # Note: This supersedes ECO-5570 AC#1 and AC#2. See deleteSubscription API.
  # Note 2: Notifications by device serial number is an API that's restricted to internalGlobal integrators who are under ResMed's control. We can ensure that they have patient permission to collect their data.
  # Note 3: Subscriptions to patients (by ecn) have no impact on a device's asleep/awake status.
  # Note 4: See https://confluence.ec2.local/display/EE/JSON+Schemas for the APIs mentioned in this card.

  # ACCEPTANCE CRITERIA: (ECO-7321)
  # Note 1: This story extends ECO-6090 and ECO-6637
  # 1. When a CAM is scrapped in ECO (either through the Manufacturing Interface per ECO-6090 or during a field service per ECO-6637 AC2)
  # 1a. Any pending SMS's for this CAM shall be cancelled
  # 1b. It shall be ensured that no further SMS's can be sent to this CAM

  # ACCEPTANCE CRITERIA: (ECO-18746)
  # Note 1: This story extends ECO-7321
  # Note 2: Recent bills from Aeris have shown a significant increase in the number of SMSes and have increased the size of the bill. The goal of this story is to manage SMS and retry SMSes based on the state of the cellular module.
  # Note 3: The cellular module state (e.g. PROVISIONED, ACTIVE, SUSPENDED, SCRAPPED) is not to be confused with the cellular module mode (e.g. SILENT, ACTIVE).
  # 1. When a broker request for a machine is added and the cellular module is not in an ACTIVE State:
  # 1a. The server shall not send a Call Home SMS to the machine
  # 1b. The server shall not schedule a Call Home retry SMS for the machine

  # ACCEPTANCE CRITERIA: (ECO-18780)
  # Note 1: This story extends ECO-7321 and ECO-18746
  # Note 2: Recent bills from Aeris have shown a significant increase in the number of SMSes and have increased the size of the bill. The goal of this story is to manage SMS and retry SMSes based on the state of the cellular module.
  # Note 3: The cellular module state (e.g. PROVISIONED, ACTIVE, SUSPENDED, SCRAPPED) is not to be confused with the cellular module mode (e.g. SILENT, ACTIVE).
  # 1. When a cellular module's State transitions to ACTIVE and the machine has a pending broker request:
  # 1a. The server shall send a Call Home SMS to the machine
  # 1b. The server shall schedule a Call Home retry SMS for the machine
  # 2. When a cellular module's State transitions to SUSPENDED and the machine has a scheduled Call Home retry SMS, the server shall remove the scheduled retry SMS

  @contact.device.S1
  @ECO-5572.1
   Scenario: For a device with a CAM that is not in silent mode at the time of manufacturing, do not send a wake up SMS when notified by ECX that the device has been added to patient.
      Given the server receives the following manufacturing unit detail
         | resource                                                                                                        |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg22222222222_cam22222222222_new.xml|
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 22222222222               | 22222222222                     |
      And I am a device with the FlowGen serial number "22222222222"
      When the following devices have been assigned
         | serialNumber | mid | vid | setupDate  | updatedOn           |
         | 22222222222  | 36  | 25  | 2014-01-01 | 2014-01-01 13:07:45 |
      Then I should not receive a SMS

  @contact.device.S2
  @ECO-5837.1
  @ECO-5837.1a
  @ECO-5837.1b
   Scenario: Device on Mock Telco has not responded to the X days (actually uses 1 second)
      Given the server receives the following manufacturing unit detail
         | resource                                                                                                       |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg33333333333_cam33333333333_new.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 33333333333               | 33333333333                     |
      And I am a device with the FlowGen serial number "33333333333"
      When the following devices have been assigned
         | serialNumber | mid | vid |
         | 33333333333  | 36  | 25  |
      Then I should eventually receive a wake up SMS within 10 seconds

  @contact.device.S3
  @ECO-5837.1
  @ECO-5837.1a
  @ECO-5837.1b
   Scenario: Device on Mock Telco has responded to the SMS so no retry is made
      Given the server receives the following manufacturing unit detail
         | resource                                                                                                            |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111111111_cam11111111111_003_new.xml  |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 11111111111               | 11111111111                     |
      And I am a device with the FlowGen serial number "11111111111"
      When the following devices have been assigned
         | serialNumber | mid | vid |
         | 11111111111  | 36  | 25  |
      Then I should eventually receive a wake up SMS within 10 seconds
      When I send the following registration
         | json                                                                                                                                                                                                                                                                                                                                                                                                                         |
         | { "FG": {"SerialNo": "11111111111", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "11111111111", "Software": "SX558-0100", "PCBASerialNo":"13152G00001", "Subscriptions": ["70FA4707-EB88-4A21-82C5-DB1F2AB7732D","3D12B449-68A2-4D03-A4E8-D09F41CCA04F"] }, "Hum": {"Software": "SX556-0100"} } |
      And I pause for 7 seconds
      Then the server has no SMS retry for flow generator 11111111111

  @contact.device.S4
  @ECO-5570.1
  @ECO-5570.2
   Scenario: Do not contact device to return to SILENT state
      Given the server receives the following manufacturing unit detail
         | resource                                                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg22222222222_cam22222222222_new.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 22222222222               | 22222222222                     |
      And I am a device with the FlowGen serial number "22222222222"
      And I send the following registration
         | json                                                                                                                                                                                                                                                                                                                              |
         | { "FG": {"SerialNo": "22222222222", "Software": "FGABCDEFH", "MID": 36, "VID": 25, "PCBASerialNo":"1A345678", "ProductCode":"37001", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "22222222222", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
      When the following update request is placed on the server's management queue for delivery to a newport device
         | requestType   | json                                                                                                                                                                                                                               |
         | CONFIGURATION | { "FG.SerialNo": "22222222222", "ConfigurationId": "00OU812-9352-40B0-B34B-D5571242BF0C", "Cam.Mode": "Silent", "REGO": "", "URL": "localhost", "PORT": "31622", "BROKER-URI": "/v1/requests/", "REGO-URI": "/v1/registrations/" } |
      Then I should not receive a SMS
      When I request my broker requests
      Then I should receive a response code of "200"
      And I should receive the following broker requests
         | json                                            |
         | { "FG.SerialNo": "22222222222", "Broker": [ ] } |

  @contact.device.S5
  @ECO-5570.1
  @ECO-5570.2
   Scenario: Contact device to return to SILENT state and have a successful workflow
      Given the server receives the following manufacturing unit detail
         | resource                                                             |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111114444_cam11111114444_new.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 11111114444               | 11111114444                     |
      And I am a device with the FlowGen serial number "11111114444"
    # Device changes to current silent mode = active as result of this assign event
    When the following devices have been assigned
         | serialNumber | mid | vid |
         | 11111114444  | 36  | 25  |
      Then I should eventually receive a wake up SMS within 10 seconds
      Given I send the following registration
         | json                                                                                                                                                                                                                                                                                                                              |
         | { "FG": {"SerialNo": "11111114444", "Software": "FGABCDEFH", "MID": 36, "VID": 25, "PCBASerialNo":"1A345678", "ProductCode":"37001", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "11111114444", "Software": "CAMABCDEFH", "PCBASerialNo":"123123444", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
      When the following devices have been unassigned
         | serialNumber | mid | vid | ConfigurationId                    |
         | 11111114444  | 36  | 25  | 00ABCDE-9352-40B0-B34B-D5571242BF0C|
      Then I should eventually receive a call home SMS within 10 seconds
      And by requesting messages for FG "11111114444" by myself I should eventually receive the following results in 7 seconds
         | URI Fixed Part          | Content Identifier                  |
         | /api/v1/configurations/ | 00ABCDE-9352-40B0-B34B-D5571242BF0C                          |
      And I should receive a response code of "200"
      When I request my last configuration brokered message
      Then I should receive the following configuration
         | json                                                                                                             |
         | { "FG.SerialNo": "11111114444", "ConfigurationId": "00ABCDE-9352-40B0-B34B-D5571242BF0C", "Cam.Mode": "Silent" } |
      When I acknowledge the configuration with content identifier "00ABCDE-9352-40B0-B34B-D5571242BF0C"
         | json                                                                                                             |
         | { "FG.SerialNo": "11111114444", "ConfigurationId": "00ABCDE-9352-40B0-B34B-D5571242BF0C", "Status": "Received" } |
      Then I should receive a response code of "200"
      And the server should not log a configuration error

  @contact.device.S6
  @ECO-7489.1 @ECO-7489.1a
   Scenario: A previously silent device will receive an SMS when it is being assigned to a patient
      Given the server receives the following manufacturing unit detail
         | resource                                                             |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111114444_cam11111114444_new.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 11111114444               | 11111114444                     |
      And I am a device with the FlowGen serial number "11111114444"
      When the following devices have been assigned
         | serialNumber | mid | vid |
         | 11111114444  | 36  | 25  |
      Then I should eventually receive a wake up SMS within 10 seconds

  @contact.device.S7
  @ECO-7489.1 @ECO-7489.1b
   Scenario: A previously silent device will receive an SMS when an integrator subscribes to it
      Given the server receives the following manufacturing unit detail
         | resource                                                             |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111114444_cam11111114444_new.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 11111114444               | 11111114444                     |
      And I am a device with the FlowGen serial number "11111114444"
      When the following subscription is added for the following device
         | subscriptionId | fgSerialNo  | totalSubscriberCount | updatedOn           |
         | 77777777777777 | 11111114444 | 1                    | 2014-01-01 13:07:45 |
      Then I should eventually receive a wake up SMS within 10 seconds

  @contact.device.S8
  @ECO-7489.2 @ECO-7489.2a
   Scenario: An assigned device become unassigned
      Given the server receives the following manufacturing unit detail
         | resource                                                             |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111115555_cam11111115555_new.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 11111115555               | 11111115555                     |
      And I am a device with the FlowGen serial number "11111115555"
      And I send the following registration
         | json                                                                                                                                                                                                                                                                                                                                            |
         | { "FG": {"SerialNo": "11111115555", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "11111115555", "Software": "SX558-0100", "PCBASerialNo":"123123444", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
      And the following devices have been assigned
         | serialNumber | mid | vid |
         | 11111115555  | 36  | 25  |
      Then I should eventually receive a wake up SMS within 10 seconds
      When the following devices have been unassigned
         | serialNumber | mid | vid |  ConfigurationId                     |
         | 11111115555  | 36  | 25  |  1111111-2222-3333-4444-555555555555 |
      And I pause for 3 seconds
      Then I should eventually receive a call home SMS within 10 seconds
      And by requesting messages for FG "11111115555" by myself I should eventually receive the following results in 7 seconds
         | URI Fixed Part          | Content Identifier                  |
         | /api/v1/configurations/ | 1111111-2222-3333-4444-555555555555 |
      And I request the configuration with identifier "1111111-2222-3333-4444-555555555555"
      And I should receive the following configuration
         | json                                                                                                             |
         | { "FG.SerialNo": "11111115555", "ConfigurationId": "1111111-2222-3333-4444-555555555555", "Cam.Mode": "Silent" } |

  @contact.device.S9
  @ECO-7489.2 @ECO-7489.2b
   Scenario: A subscribed device become unsubscribed - original
      Given the server receives the following manufacturing unit detail
         | resource                                                             |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111115555_cam11111115555_new.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 11111115555               | 11111115555                     |
      And I am a device with the FlowGen serial number "11111115555"
      And I send the following registration
         | json                                                                                                                                                                                                                                                                                                                                            |
         | { "FG": {"SerialNo": "11111115555", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "11111115555", "Software": "SX558-0100", "PCBASerialNo":"123123444", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
      And the following subscription is added for the following device
         | subscriptionId | fgSerialNo  | totalSubscriberCount |
         | 77777777777777 | 11111115555 | 1                    |
      Then I should eventually receive a wake up SMS within 10 seconds
      When the following subscription is removed for the following device
         | subscriptionId | fgSerialNo  | totalSubscriberCount | configurationId                     |
         | 77777777777777 | 11111115555 | 0                    | 1111111-2222-3333-4444-555555555555 |
      And I pause for 5 seconds
      Then I should eventually receive a call home SMS within 10 seconds
      And by requesting messages for FG "11111115555" by myself I should eventually receive the following results in 7 seconds
         | URI Fixed Part          | Content Identifier                  |
         | /api/v1/configurations/ | 1111111-2222-3333-4444-555555555555 |
      When I request the configuration with identifier "1111111-2222-3333-4444-555555555555"
      Then I should receive the following configuration
         | json                                                                                                             |
         | { "FG.SerialNo": "11111115555", "ConfigurationId": "1111111-2222-3333-4444-555555555555", "Cam.Mode": "Silent" } |

  # This test fails intermittently with some unknown timing issues
  @contact.device.S10
  @ECO-7489.2 @ECO-7489.2a @ECO-7489.2b
   Scenario: A device with subscription & assigned to patient, unassign the device then remove subscription last
      Given the server receives the following manufacturing unit detail
         | resource                                                             |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111115555_cam11111115555_new.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 11111115555               | 11111115555                     |
      And I am a device with the FlowGen serial number "11111115555"
      When I send the following registration
         | json                                                                                                                                                                                                                                                                                                                                            |
         | { "FG": {"SerialNo": "11111115555", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "11111115555", "Software": "SX558-0100", "PCBASerialNo":"123123444", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
      And the following devices have been assigned
         | serialNumber | mid | vid |
         | 11111115555  | 36  | 25  |
      And I pause for 1 seconds
      And the following subscription is added for the following device
         | subscriptionId | fgSerialNo  | totalSubscriberCount |
         | 77777777777777 | 11111115555 | 1                    |
      And I pause for 1 seconds
      And the following devices have been unassigned
         | serialNumber | mid | vid |
         | 11111115555  | 36  | 25  |
      And I pause for 1 seconds
      And the following subscription is removed for the following device
         | subscriptionId | fgSerialNo  | totalSubscriberCount | configurationId                     |
         | 77777777777777 | 11111115555 | 0                    | 1111111-2222-3333-4444-555555555555 |
      And I pause for 5 seconds
      Then I should eventually receive a call home SMS within 10 seconds
      And by requesting messages for FG "11111115555" by myself I should eventually receive the following results in 7 seconds
         | URI Fixed Part          | Content Identifier                  |
         | /api/v1/configurations/ | 1111111-2222-3333-4444-555555555555 |
      When I request the configuration with identifier "1111111-2222-3333-4444-555555555555"
      Then I should receive the following configuration
         | json                                                                                                             |
         | { "FG.SerialNo": "11111115555", "ConfigurationId": "1111111-2222-3333-4444-555555555555", "Cam.Mode": "Silent" } |

  @contact.device.S11
  @ECO-7489.2 @ECO-7489.2a @ECO-7489.2b
   Scenario: A device with subscription & assigned to patient, remove subscription last then unassign the device
      Given the server receives the following manufacturing unit detail
         | resource                                                             |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111115555_cam11111115555_new.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 11111115555               | 11111115555                     |
      And I am a device with the FlowGen serial number "11111115555"
      And I send the following registration
         | json                                                                                                                                                                                                                                                                                                                                            |
         | { "FG": {"SerialNo": "11111115555", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "11111115555", "Software": "SX558-0100", "PCBASerialNo":"123123444", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
      And the following devices have been assigned
         | serialNumber | mid | vid |
         | 11111115555  | 36  | 25  |
      And I pause for 1 seconds
      And the following subscription is added for the following device
         | subscriptionId | fgSerialNo  | totalSubscriberCount |
         | 77777777777777 | 11111115555 | 1                    |
      And I pause for 1 seconds
      When the following subscription is removed for the following device
         | subscriptionId | fgSerialNo  | totalSubscriberCount | configurationId                     |
         | 77777777777777 | 11111115555 | 0                    | 00ABCDE-9352-40B0-B34B-D5571242BF0C |
      And I pause for 1 seconds
      And the following devices have been unassigned
         | type       | serialNumber | mid | vid | ConfigurationId                     |
         | unassigned | 11111115555  | 36  | 25  | 1111111-2222-3333-4444-555555555555 |
      And I pause for 5 seconds
      Then I should eventually receive a call home SMS within 10 seconds
      And by requesting messages for FG "11111115555" by myself I should eventually receive the following results in 7 seconds
         | URI Fixed Part          | Content Identifier                  |
         | /api/v1/configurations/ | 1111111-2222-3333-4444-555555555555 |
      And I request the configuration with identifier "1111111-2222-3333-4444-555555555555"
      And I should receive the following configuration
         | json                                                                                                             |
         | { "FG.SerialNo": "11111115555", "ConfigurationId": "1111111-2222-3333-4444-555555555555", "Cam.Mode": "Silent" } |

  @contact.device.S12
  @ECO-7321.1 @ECO-7321.1.1b
   Scenario: Ensure that no SMS messages can be sent to a scrapped CAM (wake-up call)
      Given the server receives the following manufacturing unit detail
         | resource                                                                                                        |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg91111111111_cam91111111111_new.xml  |
      And the server should not produce device manufactured error
      Given the server receives the following manufacturing unit detail
         | resource                                                                                |
         | /data/manufacture/unit/detail/scrap/unit_detail_fg91111111111_cam91111111111_scrap.xml  |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 91111111111               | 91111111111                     |
      And I am a device with the FlowGen serial number "91111111111"
      When the following devices have been assigned
         | serialNumber | mid | vid | setupDate  |
         | 91111111111  | 36  | 25  | 2014-01-01 |
      Then I should not receive a wake up SMS within 7 seconds

  @contact.device.S13
  @ECO-7321.1 @ECO-7321.1.1b
  @ECO-18746.1 @ECO-18746.1a @ECO-18746.1b
   Scenario: Ensure that SMS messages cannot be sent to a non-active CAM with status scrapped, provisioned or suspended (call home)
      Given the server receives the following manufacturing unit detail
         | resource                                                                                                            |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg91111111111_cam91111111111_016_new.xml  |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 91111111111               | 91111111111                     |
      And I am a device with the FlowGen serial number "91111111111"
      And I send the following registration
         | json                                                                                                                                                                                                                                                                                                                              |
         | { "FG": {"SerialNo": "91111111111", "Software": "FGABCDEFH", "MID": 36, "VID": 25, "PCBASerialNo":"1A345678", "ProductCode":"37001", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "91111111111", "Software": "CAMABCDEFH", "PCBASerialNo":"13152G00001", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
      And the server receives the following manufacturing unit detail
         | resource                                                                                    |
         | /data/manufacture/unit/detail/scrap/unit_detail_fg91111111111_cam91111111111_016_scrap.xml  |
      And the server should not produce device manufactured error
    # send sms to scrapped device
    When the server is given the following subscriptions to be sent to devices
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
         | { "FG.SerialNo": "91111111111", "SubscriptionId":"E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      Then I should receive a response code of "200"
      And  I should not receive a call home SMS within 7 seconds
      When the server receives the following manufacturing unit detail
         | resource                                                                        |
         | /data/manufacturing/unit_detail_new_cam19191911998_fg19191911999.xml            |
         | /data/manufacturing/unit_detail_new_cam10000000001_fg20070811223.xml            |
      And the server waits for the device manufactured queue to be empty
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                             |
         | 23994273-e01e-4d23-9d3e-2140bcf10d79 | /data/manufacturing/unit_detail_new_cam10000000001_fg20070811223.xml |
      And I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | 23994273-e01e-4d23-9d3e-2140bcf10d79 | /data/newport/registration/20070811223.json |
      Then I should receive a server ok response
      When the communication module with serial number "10000000001" has suspended status for 1 days
    # send sms to suspended device
    And the server is given the following subscriptions to be sent to devices
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
         | { "FG.SerialNo": "20070811223", "SubscriptionId":"B0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/subscriptions/", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      Then I should receive a response code of "200"
      And  I should not receive a call home SMS within 7 seconds
    # send sms to provisioned device
    When the server is given the following subscriptions to be sent to devices
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
         | { "FG.SerialNo": "19191911999", "SubscriptionId":"F0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/subscriptions/", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      Then I should receive a response code of "200"
      And  I should not receive a call home SMS within 7 seconds

  @contact.device.S14
  @ECO-7321.1 @ECO-7321.1.1a
   Scenario: Pending SmS messages for a scrapped device will be cancelled (wake up from silent state)
      Given the server receives the following manufacturing unit detail
         | resource                                                             |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111114444_cam11111114444_new.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 11111114444               | 11111114444                     |
      And I am a device with the FlowGen serial number "11111114444"
      When the following devices have been assigned
         | serialNumber | mid | vid | setupDate  |
         | 11111114444  | 36  | 25  | 2014-01-01 |
      Then I should eventually receive a wake up SMS within 10 seconds
      When the communication module with serial number "11111114444" is scrapped
      And the server is given the following subscriptions to be sent to devices
         | json                                                                                                       |
         | { "FG.SerialNo": "11111114444", "SubscriptionId": "E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "Cancel": true } |
      Then  I should not receive a call home SMS within 7 seconds

  @contact.device.S15
  @ECO-7321.1 @ECO-7321.1.1a
   Scenario: Pending SmS messages for a scrapped device will be cancelled (active state - call home)
      Given the server receives the following manufacturing unit detail
         | resource                                                             |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg88800000001_cam88810000001_new.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 88800000001               | 88810000001                     |
      And I am a device with the FlowGen serial number "88800000001"
      And I send the following registration
         | json                                                                                                                                                                                                                                                                                                                             |
         | { "FG": {"SerialNo": "88800000001", "Software": "FGABCDEFH", "MID": 36, "VID": 1, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "88810000001", "Software": "CAMABCDEFH", "PCBASerialNo":"1B3456789", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
      When the server is given the following climate settings to be sent to devices
         | json                                                                                                                                                                                                                                                                         |
         | { "FG.SerialNo": "88800000001", "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
      Then I should receive a response code of "200"
      And I should eventually receive a call home SMS within 10 seconds
      When the communication module with serial number "88810000001" is scrapped
      And the server is given the following climate settings to be sent to devices
         | json                                                                                                                                                                                                                                                                         |
         | { "FG.SerialNo": "88800000001", "SettingsId": "35D21334-3518-4888-803E-9D389FCA5B40", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
      Then  I should not receive a call home SMS within 7 seconds

  @contact.device.S16
   Scenario: Testing that SMSs are not sent to silent devices
      Given the server receives the following manufacturing unit detail
         | resource                                                             |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111114444_cam11111114444_new.xml |
      And the server should not produce device manufactured error
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 11111114444               | 11111114444                     |
      And I am a device with the FlowGen serial number "11111114444"
      When the server is given the following climate settings to be sent to devices
         | json                                                                                                                                                                                                                                                                         |
         | { "FG.SerialNo": "11111114444", "SettingsId": "35D21334-3518-4888-803E-9D389FCA5B40", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
      Then  I should not receive a call home SMS within 7 seconds

  @contact.device.S17
  @ECO-18780.1 @ECO-18780.1a @ECO-18780.1b
  @ECO-18780.2
   Scenario: A cellular module's State transitions to SUSPENDED and the machine has a scheduled Call Home retry SMS and then the cellular module's State transitions from SUSPENDED to ACTIVE and the machine has a pending broker request
      Given the server bulk load the following devices and modules
         | /data/manufacturing/batch_new_fg2008_cam2008.xml |
      And manufacture verify the status of the job
         | status           |
         | COMPLETE-SUCCESS |
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 20080811223               | 20080811223                     |
      And I am a device with the FlowGen serial number "20080811223"
      When I send the following registration
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
         | { "FG": {"SerialNo": "20080811223", "Software": "SX567-0302", "MID": 36, "VID": 26, "PCBASerialNo":"(90)R370-7341(91)2(21)4Z244018", "ProductCode":"37067", "Configuration": "CX036-026-008-024-101-101-100" }, "CAM": {"SerialNo": "20080811223", "Software": "SX558-0308", "PCBASerialNo":"449000222", "Subscriptions": [ "30B59434-BF4F-4788-9678-A00FF860C038", "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "018A5655-81C6-4888-A2AD-6480087BE3B7", "1D1771B2-890B-4576-8863-FC8559C03040", "12A64E97-6E6F-4C18-A78D-7844A827BF28", "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "1C166B19-01FA-4D7D-A825-A25682C7CB0C", "2896C763-FE94-4B3F-AD6C-305583FD4210", "21C219CD-EB66-43E7-B677-50E858BB851B", "28D54873-A79C-47A5-A08F-D55D979418F0", "23268714-645A-4A38-85C3-AE691D62907A", "2B04744B-1676-42DE-97ED-199205723183", "24208A76-16A4-427E-BBCF-149A49D9623E", "24208A76-16A4-427E-BBCF-179A49D9718B", "24208A76-16A4-427E-BBCF-179A49D3564C", "2C7CF86E-4E4C-4AEF-97D1-407D23FA9245", "2DD86205-45B5-4023-84D6-40772455902C", "2E30A610-741A-465D-AF65-299CD62BBB1A", "2FADA80D-8094-491C-9481-3CCC471F0372" ] }, "Hum": {"Software": "SX556-0203"} } |
      Then the communication module with serial number "20080811223" should eventually have a status of "ACTIVE" within 5 seconds
      When the server is given the following subscriptions to be sent to devices
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
         | { "FG.SerialNo": "20080811223", "SubscriptionId":"E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      Then the server has a CALL_HOME SMS retry for flow generator 20080811223
      When the communication module with serial number "20080811223" gets suspended
      And the server receives the following device "20080811223" state changed to suspended event
      Then I pause for 7 seconds
      And the server has no SMS retry for flow generator 20080811223
      And the server should not log a device state changed error
      When the server is given the following subscriptions to be sent to devices
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
         | { "FG.SerialNo": "20080811223", "SubscriptionId":"E0C70BA1-FEE3-4445-9FF1-AD9942643F43", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      And I send the following registration
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
         | { "FG": {"SerialNo": "20080811223", "Software": "SX567-0302", "MID": 36, "VID": 26, "PCBASerialNo":"(90)R370-7341(91)2(21)4Z244018", "ProductCode":"37067", "Configuration": "CX036-026-008-024-101-101-100" }, "CAM": {"SerialNo": "20080811223", "Software": "SX558-0308", "PCBASerialNo":"449000222", "Subscriptions": [ "30B59434-BF4F-4788-9678-A00FF860C038", "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "018A5655-81C6-4888-A2AD-6480087BE3B7", "1D1771B2-890B-4576-8863-FC8559C03040", "12A64E97-6E6F-4C18-A78D-7844A827BF28", "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "1C166B19-01FA-4D7D-A825-A25682C7CB0C", "2896C763-FE94-4B3F-AD6C-305583FD4210", "21C219CD-EB66-43E7-B677-50E858BB851B", "28D54873-A79C-47A5-A08F-D55D979418F0", "23268714-645A-4A38-85C3-AE691D62907A", "2B04744B-1676-42DE-97ED-199205723183", "24208A76-16A4-427E-BBCF-149A49D9623E", "24208A76-16A4-427E-BBCF-179A49D9718B", "24208A76-16A4-427E-BBCF-179A49D3564C", "2C7CF86E-4E4C-4AEF-97D1-407D23FA9245", "2DD86205-45B5-4023-84D6-40772455902C", "2E30A610-741A-465D-AF65-299CD62BBB1A", "2FADA80D-8094-491C-9481-3CCC471F0372" ] }, "Hum": {"Software": "SX556-0203"} } |
      Then the communication module with serial number "20080811223" should eventually have a status of "ACTIVE" within 5 seconds
      And I should eventually receive a call home SMS within 20 seconds
      And the server has a CALL_HOME SMS retry for flow generator 20080811223
      And the server should not log a device state changed error

  @contact.device.S18
  @ECO-18780.1 @ECO-18780.1a @ECO-18780.1b
   Scenario: A cellular module's State transitions from PROVISIONED to ACTIVE and the machine has a pending broker request
      Given the server bulk load the following devices and modules
         | /data/manufacturing/batch_new_fg2008_cam2008.xml |
      And manufacture verify the status of the job
         | status           |
         | COMPLETE-SUCCESS |
      And the following units are cached for local use
         | flowGeneratorSerialNumber | communicationModuleSerialNumber |
         | 20080811223               | 20080811223                     |
      And I am a device with the FlowGen serial number "20080811223"
      And the server is given the following subscriptions to be sent to devices
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
         | { "FG.SerialNo": "20080811223", "SubscriptionId":"E0C70BA1-FEE3-4445-9FF1-AD9942643F42", "ServicePoint":"/api/v1/therapy/summaries", "Trigger":"HALO", "Schedule":{ "StartDate":"10 days ago", "EndDate":null }, "Data":[ "Val.Mode", "Val.Duration", "Val.MaskOn", "Val.MaskOff", "Val.AHI", "Val.AI", "Val.HI", "Val.OAI", "Val.CAI", "Val.UAI", "Val.Leak.50", "Val.Leak.95", "Val.Leak.Max", "Val.CSR", "Val.Humidifier", "Val.HeatedTube", "Val.AmbHumidity" ] } |
      When I send the following registration
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
         | { "FG": {"SerialNo": "20080811223", "Software": "SX567-0302", "MID": 36, "VID": 26, "PCBASerialNo":"(90)R370-7341(91)2(21)4Z244018", "ProductCode":"37067", "Configuration": "CX036-026-008-024-101-101-100" }, "CAM": {"SerialNo": "20080811223", "Software": "SX558-0308", "PCBASerialNo":"449000222", "Subscriptions": [ "30B59434-BF4F-4788-9678-A00FF860C038", "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "018A5655-81C6-4888-A2AD-6480087BE3B7", "1D1771B2-890B-4576-8863-FC8559C03040", "12A64E97-6E6F-4C18-A78D-7844A827BF28", "12CE1A82-93A9-4839-948A-E3F8FD51C9FE", "1C166B19-01FA-4D7D-A825-A25682C7CB0C", "2896C763-FE94-4B3F-AD6C-305583FD4210", "21C219CD-EB66-43E7-B677-50E858BB851B", "28D54873-A79C-47A5-A08F-D55D979418F0", "23268714-645A-4A38-85C3-AE691D62907A", "2B04744B-1676-42DE-97ED-199205723183", "24208A76-16A4-427E-BBCF-149A49D9623E", "24208A76-16A4-427E-BBCF-179A49D9718B", "24208A76-16A4-427E-BBCF-179A49D3564C", "2C7CF86E-4E4C-4AEF-97D1-407D23FA9245", "2DD86205-45B5-4023-84D6-40772455902C", "2E30A610-741A-465D-AF65-299CD62BBB1A", "2FADA80D-8094-491C-9481-3CCC471F0372" ] }, "Hum": {"Software": "SX556-0203"} } |
      Then the communication module with serial number "20080811223" should eventually have a status of "ACTIVE" within 5 seconds
      And I should eventually receive a call home SMS within 20 seconds
      And the server has a CALL_HOME SMS retry for flow generator 20080811223
      And the server should not log a device state changed error