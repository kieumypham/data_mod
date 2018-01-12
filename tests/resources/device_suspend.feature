@newport
@newport.suspend.device
@ECO-12634
@ECO-12635
@ECO-13565
@ECO-12636

Feature:
  (ECO-12634) As ResMed
  I want to suspend Aeris-connected Air10 units that have been provisioned and that have never registered with ResMed before they become billable,
  so that I can save cost.

  (ECO-12635) As ResMed
  I want to suspend Aeris-connected Air10 units that are billable but have not transmitted data for a while,
  so that I can stop being charged.

  (ECO-13565) As Product Support
  I want to be able to use a FG serial number to determine whether an Aeris-connected device has been suspended or is active,
  so that I can avoid a more tedious lookup based on CAM serial numbe.

  (ECO-12636) As ResMed
  I want to keep suspended Aeris-connected Air10 units that are about to transition to billable only because of suspend status timeout on Aeris side,
  so that I can avoid start being charged.

  (ECO-18780) As a telco cost manager,
  I want to stop sending SMSes to a device when is suspended and resume when it gets active again,
  so that costs are reduced.


  # ACCEPTANCE CRITERIA: (ECO-12634)
  # Note 1: Design for this feature can be found at: https://confluence.ec2.local/display/ECO/ECO-12634+-+Design+-+Suspend+Aeris-connected+devices+that+are+provisioned+but+have+never+registered+to+ResMed
  # 1.  Machine Portal shall provide the capability to identify Aeris-connected devices that are provisioned but have not registered with NGCS within X days from manufacturing and suspend them.
  # 1.a The successful suspension of a device shall result into the CAM status to be SUSPENDED
  # 1.b The successful suspension of a device shall be recorded in Machine Portal
  # 1.c Recording of a successful suspension of a device shall include FG serial number, CAM serial number, date, time and Aeris response code
  # 1.d A failed suspension attempt of a device will result into the CAM status to be PROVISIONED
  # 1.e A failed suspension attempt shall be logged with an event sent to the DLQ.AerisAdminMessage queue, including headers providing failure details

  # Note 2: The number of days X shall be configurable, and set to 355 by default

  # ACCEPTANCE CRITERIA: (ECO-12635)
  # 1. Machine Portal shall provide the capability to identify Aeris-connected devices that have been registered more than 90 days from the current date, are ACTIVE, have not transmitted data for X days, and suspend them.
  # 1.a The successful suspension of a device shall result into the CAM status to be SUSPENDED
  # 1.b The successful suspension of a device shall be recorded in Machine Portal
  # 1.c Recording of a successful suspension of a device shall include CAM serial number, date, time and Aeris response code
  # 1.d A failed suspension attempt of a device will result into the CAM status to remain ACTIVE
  # 1.e A failed suspension attempt shall be logged with an event sent to the DLQ.AerisAdminMessage queue, including headers providing failure details
  # Note 1: The number of days X shall be configurable, and set to 42 (6 weeks) by default.

  # ACCEPTANCE CRITERIA: (ECO-13276)
  # 1. When Machine Portal suspends an Aeris-connected device, it shall include the FG serial number to the successful suspension record.
  # 1.a When the device is transitioned from provisioned to suspended, it shall include the FG serial number to the record.
  # 1.b When the device is transitioned from active to suspended, it shall include the FG serial number to the record.
  # Note 1. AC 1 adds FG serial number to AC 1.c of --ECO-12634--, ECO-12635, and ECO-12636.
  # 2. When Machine Portal transitions an Aeris-connected device to active, it shall include the FG serial number to the record.
  # 2.a When the device is transitioned from provisioned to active, it shall include the FG serial number to the record.
  # 2.b When the device is transitioned from suspended to active, it shall include the FG serial number to the record.
  # Note 2. AC 2 adds recording of FG serial number to all ACs of -ECO-13276-.

  # ACCEPTANCE CRITERIA: (ECO-12636)
  # 1. Machine Portal shall provide the capability to identify Aeris-connected devices that have been in the SUSPENDED status for X days and renew their SUSPENDED status.
  # 1.a The successful suspension of a device shall result into the CAM status to be SUSPENDED
  # 1.b The successful suspension of a device shall be recorded in Machine Portal
  # 1.c Recording of a successful suspension of a device shall include CAM serial number, date, time and Aeris response code
  # 1.d A failed suspension attempt of a device will result into the CAM status to be ACTIVE (to be verified with Chris and Eric)
  # 1.e A failed suspension attempt shall be logged with an event sent to the DLQ.AerisAdminMessage queue, including headers providing failure details

  # Note 1: The number of days X shall be configurable, and set to 360 by default

  # ACCEPTANCE CRITERIA: (ECO-18780)
  # Note 1: This story extends ECO-7321 and ECO-18746
  # Note 2: Recent bills from Aeris have shown a significant increase in the number of SMSes and have increased the size of the bill. The goal of this story is to manage SMS and retry SMSes based on the state of the cellular module.
  # Note 3: The cellular module state (e.g. PROVISIONED, ACTIVE, SUSPENDED, SCRAPPED) is not to be confused with the cellular module mode (e.g. SILENT, ACTIVE).
  # 1. When a cellular module's State transitions to ACTIVE and the machine has a pending broker request:
  # 1a. The server shall send a Call Home SMS to the machine
  # 1b. The server shall schedule a Call Home retry SMS for the machine
  # 2. When a cellular module's State transitions to SUSPENDED and the machine has a scheduled Call Home retry SMS, the server shall remove the scheduled retry SMS



  Background:
    Given the server receives the following manufacturing unit detail
      | resource                                                                                                        |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg19191911999_cam19191911998_new.xml  |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 19191911999               | 19191911998                     |
    And I am a device with the FlowGen serial number "19191911999"

  @manual
  @newport.suspend.device.S1
  @ECO-12634.1 @ECO-12634.1a @ECO-12634.1b @ECO-12634.1c
  @ECO-13565.1 @ECO-13565.1a
  Scenario: Suspend a provisioned Newport device successfully
    Given the Aeris Telco feature has been started by running "features:install ngcs-telco-aeris" in the Karaf console
    And the device with the following details has status of 'PROVISIONED' and is not registered within the maximum period allowed
      | FgSerialNo  | camSerial   | meId           | min        | mdn        |
      | 19191911999 | 19191911998 | A1000042F421C1 | 9392391711 | 5888385560 |
    When NGCS Scheduled Quartz job runs to suspend eligible devices through the telco aeris
    Then each device is suspended with a response code of 0 from the Aeris service found in the log
    And the CAM status is set to 'SUSPENDED' in the database
    And a new 'SUSPEND' event is created in the aeris_event_history table


  @manual
  @newport.suspend.device.S2
  @ECO-12634.1 @ECO-12634.1d @ECO-12634.1e
  Scenario: Unsuccessful attempt to Suspend a provisioned Newport device
    Given the Aeris Telco feature has been started by running "features:install ngcs-telco-aeris" in the Karaf console
    And device with the following details has status of 'PROVISIONED' and is not registered within the maximum period allowed
      | serialNo    | meId           | min        | mdn        |
      | 19191911999 | A1INVALID421C1 | 9132722351 | 5772582460 |
    When NGCS Scheduled Quartz job runs to suspend eligible devices through the telco aeris
    Then the suspend request fails for the device
    And the CAM status is 'PROVISIONED' in the database
    And a message describing the error is added to the DLQ.AerisAdminMessage queue

  @newport.suspend.device.S3
  @ECO-12635.1 @ECO-12635.1a @ECO-12635.1b @ECO-12635.1c
  @ECO-13565.1 @ECO-13565.1b
  Scenario: Successful suspension of an active device registered for more than 90 days and has not sent data for 42 days
    Given I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "19191911999", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "19191911998", "Software": "SX558-0100", "PCBASerialNo":"13152G00001", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    Then the server has the following comm modules
      | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   |
      | 19191911998 | 13152G00001  | SILENT             | SILENT             | AERIS                | SX558-0100 |
    And the communication module with serial number "19191911998" should eventually have a status of "ACTIVE" within 5 seconds
    And the communication module with serial number "19191911998" should eventually have a new message delivery event within 1 seconds
    When the server receives the following manufacturing unit detail
      | resource                                                                                                                |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111111112_cam11111111112_aeris_silent.xml |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 11111111112               | 11111111112                     |
    And I am a device with the FlowGen serial number "11111111112"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "11111111112", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "11111111112", "Software": "SX558-0100", "PCBASerialNo":"13152G00013", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    Then the server has the following comm modules
      | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   |
      | 11111111112 | 13152G00013  | SILENT             | SILENT             | AERIS                | SX558-0100 |
    And the communication module with serial number "11111111112" should eventually have a status of "ACTIVE" within 5 seconds
    And the communication module with serial number "11111111112" should eventually have a new message delivery event within 1 seconds

   # @manual
   #  And the device registration for communication module with serial "19191911998" is dated more than 90 days ago
   #  And the device last communication date for communication module with serial "19191911998" in the Message_Delivery table is dated 42 days ago or greater
   #  And the Aeris Telco feature is started by running "features:install ngcs-telco-aeris" in the Karaf console
   #  When NGCS Scheduled Quartz job suspendRegisteredActiveAerisDevicesJob runs to suspend eligible devices
   #  Then the suspend request succeeds for the device
   #  And the CAM status is 'SUSPENDED' in the COMM_MODULE database table
   #  And a new SUSPEND event is created in the aeris_event_history table
   #  And there is no message in the DLQ.AerisAdminMessage queue

  @newport.suspend.device.S4
  @ECO-12635.1
  Scenario: Active device registered for more than 90 days but has sent data within the last 42 days should not be suspended
    Given I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "19191911999", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "19191911998", "Software": "SX558-0100", "PCBASerialNo":"13152G00001", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And the server has the following comm modules
      | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   |
      | 19191911998 | 13152G00001  | SILENT             | SILENT             | AERIS                | SX558-0100 |
    And the communication module with serial number "19191911998" should eventually have a status of "ACTIVE" within 5 seconds
    And the communication module with serial number "19191911998" should eventually have a new message delivery event within 1 seconds

    # @manual
    # And the device registration for communication module with serial "19191911998" is dated more than 90 days ago
    # And the device last communication date for communication module with serial "19191911998" in the Message_Delivery table is dated less than 42 days ago
    # And the Aeris Telco feature is started by running "features:install ngcs-telco-aeris" in the Karaf console
    # When NGCS Scheduled Quartz job suspendRegisteredActiveAerisDevicesJob runs to suspend eligible devices
    # Then the device is not suspended and the CAM status is 'ACTIVE' in the COMM_MODULE database table
    # And no new event is created in the aeris_event_history table
    # And there is no message in the DLQ.AerisAdminMessage queue


  @newport.suspend.device.S5
  @ECO-12635.1
  Scenario: Active device registered for less than 90 days but has not sent data within the last 42 days should not be suspended
    Given I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "19191911999", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "19191911998", "Software": "SX558-0100", "PCBASerialNo":"13152G00001", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And the server has the following comm modules
      | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   |
      | 19191911998 | 13152G00001  | SILENT             | SILENT             | AERIS                | SX558-0100 |
    And the communication module with serial number "19191911998" should eventually have a status of "ACTIVE" within 5 seconds
    And the communication module with serial number "19191911998" should eventually have a new message delivery event within 1 seconds

   # @manual
   #  And the device registration for communication module with serial "19191911998" is dated 90 days ago
   #  And the device last communication date for communication module with serial "19191911998" in the Message_Delivery table is dated 42 days ago or greater
   #  And the Aeris Telco feature is started by running "features:install ngcs-telco-aeris" in the Karaf console
   #  When NGCS Scheduled Quartz job suspendRegisteredActiveAerisDevicesJob runs to suspend eligible devices
   #  Then the device is not suspended
   #  And the CAM status is 'ACTIVE' in the COMM_MODULE database table
   #  And no new event is created in the aeris_event_history table
   # And there is no message in the DLQ.AerisAdminMessage queue

  @newport.suspend.device.S6
  @ECO-12635.1
  Scenario: Active device registered for less than 90 days and has sent data within the last 42 days should not be suspended
    Given I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "19191911999", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "19191911998", "Software": "SX558-0100", "PCBASerialNo":"13152G00001", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And the server has the following comm modules
      | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   |
      | 19191911998 | 13152G00001  | SILENT             | SILENT             | AERIS                | SX558-0100 |
    And the communication module with serial number "19191911998" should eventually have a status of "ACTIVE" within 5 seconds
    And the communication module with serial number "19191911998" should eventually have a new message delivery event within 1 seconds

   # @manual
   #  And the device registration for communication module with serial "19191911998" is dated 90 days ago or less
   #  And the device last communication date for communication module with serial "19191911998" in the Message_Delivery table is dated 41 days ago or less
   #  And the Aeris Telco feature is started by running "features:install ngcs-telco-aeris" in the Karaf console
   #  When NGCS Scheduled Quartz job suspendRegisteredActiveAerisDevicesJob runs to suspend eligible devices
   #  Then the device is not suspended
   #  And the CAM status is 'ACTIVE' in the COMM_MODULE database table
   #  And no new event is created in the aeris_event_history table
   # And there is no message in the DLQ.AerisAdminMessage queue

  @newport.suspend.device.S7
  @ECO-12635.1
  Scenario: Scrapped device registered for more than 90 days and has not sent data within the last 42 days should not be suspended
    Given I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "19191911999", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "19191911998", "Software": "SX558-0100", "PCBASerialNo":"13152G00001", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And the server has the following comm modules
      | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   |
      | 19191911998 | 13152G00001  | SILENT             | SILENT             | AERIS                | SX558-0100 |
    And the communication module with serial number "19191911998" should eventually have a status of "ACTIVE" within 5 seconds
    And the communication module with serial number "19191911998" is scrapped

   # @manual
   # And the device registration for communication module with serial "19191911998" is dated more than 90 days ago
   # And the device last communication date for communication module with serial "19191911998" in the Message_Delivery table is dated 42 days ago or greater
   # And the Aeris Telco feature is started by running "features:install ngcs-telco-aeris" in the Karaf console
   # When NGCS Scheduled Quartz job suspendRegisteredActiveAerisDevicesJob runs to suspend eligible devices
   # Then the device is not suspended
   # And the CAM status is 'SCRAPPED' in the COMM_MODULE database table
   # And no new event is created in the aeris_event_history table
   # And there is no message in the DLQ.AerisAdminMessage queue

  @newport.suspend.device.S8
  @ECO-12635.1 @ECO-12635.1d @ECO-12635.1e
  Scenario: Exception occurs when there is an attempt to suspend an active device registered for more than 90 days which has not sent data within the last 42 days. Device should remain in active state
    Given the server receives the following manufacturing unit detail
      | resource                                                                                                              |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111111112_cam11111111112_aeris_active.xml|
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 11111111112               | 11111111112                     |
    And I am a device with the FlowGen serial number "11111111112"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "11111111112", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090043", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "11111111112", "Software": "SX558-0100", "PCBASerialNo":"13152G00013", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    Then the server has the following comm modules
      | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   |
      | 11111111112 | 13152G00013  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 |
    And the communication module with serial number "11111111112" should eventually have a status of "ACTIVE" within 5 seconds
    And the communication module with serial number "11111111112" should eventually have a new message delivery event within 1 seconds

   # @manual
   # And the device registration for communication module with serial "11111111112" is dated more than 90 days ago
   # And the device last communication date for communication module with serial "11111111112" in the Message_Delivery table is dated 42 days ago or greater
   # And the Aeris Telco feature is started by running "features:install ngcs-telco-aeris" in the Karaf console
   # When NGCS Scheduled Quartz job suspendRegisteredActiveAerisDevicesJob runs to suspend eligible devices
   # Then the device is not suspended
   # And the CAM status is 'ACTIVE' in the COMM_MODULE database table
   # And no new event is created in the aeris_event_history table for the device
   # And there is a message in the DLQ.AerisAdminMessage queue, including headers providing exception details

  @newport.suspend.device.S9
  @ECO-12636.1 @ECO-12636.1a @ECO-12636.1b @ECO-12636.1c
  Scenario: Successfully renew the suspension of a device that has been suspended for 360+ days
    Given I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "19191911999", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "19191911998", "Software": "SX558-0100", "PCBASerialNo":"13152G00001", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And the server has the following comm modules
      | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   |
      | 19191911998 | 13152G00001  | SILENT             | SILENT             | AERIS                | SX558-0100 |
    And an aeris event history record is created with the following data
      | camSerialNo | flowGenSerial | status    | eventResult | numberOfRecords |
      | 19191911998 | 19191911999   | ACTIVATED |             | 1               |
    And the communication module with serial number "19191911998" has suspended status for 360 days

   # @manual
   #  And the event date for the record with event type 'ACTIVATE' in the aeris_event_history table for communication module with serial "19191911998" is dated more 361 or more days ago (older than suspend event above)
   #  And the Aeris Telco feature is started by running "features:install ngcs-telco-aeris" in the Karaf console
   #  When NGCS Scheduled Quartz job renewDeviceSuspensionJob runs to suspend eligible devices
   #  Then the suspend request succeeds for the device
   #  And the CAM status remains 'SUSPENDED' in the COMM_MODULE database table with no update made to the row
   #  And a new SUSPEND event is created in the aeris_event_history table containing cam serial, event date and time and response code = 0
   #  And there is no message present for the device in the DLQ.AerisAdminMessage queue

  @newport.suspend.device.S10
  @ECO-12636.1
  Scenario: No suspension renewal for a device that has been suspended for less than 360 days
    Given I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "19191911999", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "19191911998", "Software": "SX558-0100", "PCBASerialNo":"13152G00001", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
    And the server has the following comm modules
      | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   |
      | 19191911998 | 13152G00001  | SILENT             | SILENT             | AERIS                | SX558-0100 |
    And an aeris event history record is created with the following data
      | camSerialNo | flowGenSerial | status    | eventResult | numberOfRecords |
      | 19191911998 | 19191911999   | ACTIVATED |             | 1               |
    And the communication module with serial number "19191911998" has suspended status for 359 days

   # @manual
   #  And the event date for the record with event type 'ACTIVATE' in the aeris_event_history table for communication module with serial "19191911998" is dated more 361 or more days ago (older than suspend event above)
   #  And the Aeris Telco feature is started by running "features:install ngcs-telco-aeris" in the Karaf console
   #  When NGCS Scheduled Quartz job renewDeviceSuspensionJob runs to suspend eligible devices
   #  Then there is no suspend request sent for the device
   #  And the CAM status remains 'SUSPENDED' in the COMM_MODULE database table, the last_updated_date column has not been updated
   #  No new SUSPEND event is created in the aeris_event_history table
   #  And there is no message present for the device in the DLQ.AerisAdminMessage queue

  @newport.suspend.device.S11
  @ECO-12636.1 @ECO-12636.1d @ECO-12636.1e
  Scenario: Exception causes failed request to Aeris for renewal suspension for device suspended more than 360 days, device remains suspended, DLQ should be populated
    Given the server receives the following manufacturing unit detail
      | resource                                                                                                                |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111111112_cam11111111112_aeris_active.xml  |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 11111111112               | 11111111112                     |
    And I am a device with the FlowGen serial number "11111111112"
    When I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "11111111112", "Software": "SX567-0100", "MID": 36, "VID": 25, "PCBASerialNo":"34090043", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "11111111112", "Software": "SX558-0100", "PCBASerialNo":"13152G00013", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |
    Then the server has the following comm modules
      | serialNo    | pcbaSerialNo | currentSilentState | defaultSilentState | telcoCarrierProvider | software   |
      | 11111111112 | 13152G00013  | ACTIVE             | ACTIVE             | AERIS                | SX558-0100 |
    And an aeris event history record is created with the following data
      | camSerialNo | flowGenSerial | status    | eventResult | numberOfRecords |
      | 11111111112 | 11111111112   | ACTIVATED |             | 1               |
    And the communication module with serial number "11111111112" has suspended status for 361 days

   # @manual
   #  And the event_date for the record with event_type 'ACTIVATE' in the aeris_event_history table for communication module with serial "11111111112" is dated more 362 or more days ago (should be older than suspend event above)
   #  And the Aeris Telco feature is started by running "features:install ngcs-telco-aeris" in the Karaf console
   #  When NGCS Scheduled Quartz job renewDeviceSuspensionJob runs to suspend eligible devices
   #  Then the suspend request should fail for the device
   #  The CAM's status remains 'SUSPENDED' in the COMM_MODULE database table
   #  And no new SUSPEND event is created in the aeris_event_history table for the device
   #  And the latest pre-existing SUSPEND event for the device in AERIS_EVENT_HISTORY table is dated 361 days ago or more
   #  And there is a message present for the device in the DLQ.AerisAdminMessage queue including headers providing exception details

  @newport.suspend.device.S12
  @ECO-18780.2
  Scenario: When a device is suspended, any pending SMS messages should be deleted.
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
    And the communication module with serial number "22161295306" should eventually have a new message delivery event within 1 seconds
     # Send Climate Setting
    When the server has the following climate settings to be sent to devices
      | json   |
      | { "FG.SerialNo": "22161295306",  "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |

    # @manual
    # After running the steps above, check that a broker message record and SMS retry record respectively are present in the database
    # Update the suspend job to run every 5 mins e.g "ngcs.telco.aeris.quartz.suspendRegisteredActiveDeviceCron = 0+0/5+*+*+*+?"
    # Update the suspend time cut off property as "ngcs.telco.aeris.suspendEndTime.hour = 23"
    # Update the device registration date to be more than 90 days ago
    # Update the device last communication date in the Message_Delivery table to be dated 42 days ago or greater
    # To enable debugging of the camel routes, enter the following commands at the Karaf console
        # "log:set DEBUG resmed.hi.ngcs.telco",
        # "log:set DEBUG deviceRegisteredEventCreateTelcoHistoryContext"
        # "log:set DEBUG ngcs.resmed.hi.activateDeviceIfSuspended.filter"
    # Start the Aeris Telco feature by running "features:install ngcs-telco-aeris" in the Karaf console
    # The device should be suspended when the job runs
    # The SMS record should be deleted
    # Check that there are no errors in the DLQ queues
    # Check that there are no errors in the NGCS log