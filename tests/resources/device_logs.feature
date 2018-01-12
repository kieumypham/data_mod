@device.logs
@cam
@newport
@newport.log
@ECO-5809
@ECO-13276

Feature:
  (ECO-5809) As technical services
  I want to request CAM and FG logs on demand
  so that I can provide technical support remotely for our customers/patients

  (ECO-13276) As the Machine Portal,
  I want to update a Suspended Cellular Module state to Activated when a message is received
  so that I known when the last communication occurred


  # ACCEPTANCE CRITERIA: (ECO-5809)
  # Note 1: The log information is going to be wrapped in JSON structure by the CAM.
  # Note 2: Normal communication validation and JSON structure validation are performed. If these validation checks fail, the log files will be thrown away as per normal NGCS functionality.
  # Note 3: Additional validation will be performed by Tech Services Portal.
  # 1. The log returned by the device shall be placed on the JMS Queue. Note: The Tech Services Portal will be connecting to the JMS Queue to collect the log file.
  # 2. If the returned message is not in valid JSON format, the message shall be discarded.
  # 3. The queue shall allow device log retrieval by device serial number.
  # Note 4: As this card is implemented, please document the interface in Confluence

  # ACCEPTANCE CRITERIA: (ECO-13276)
  # A Suspended Cellular Module will be updated to Activated when:
  # 1. A Registration is received
  # 2. An Alarm Setting is received
  # 3. A Climate Setting is received
  # 4. A Device Alarm is received
  # 5. A Device Erasure is received
  # 6. A Device Fault is received
  # 7. A Device Log is received
  # 8. A Settings Event is received
  # 9. A System Event is received
  # 10. A Therapy Detail is received
  # 11. A Therapy Setting is received
  # 12. A Therapy Summary is received

  Background:
    Given the server receives the following manufacturing unit detail
      | resource                                                             |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg20070811223_cam20102141732_new.xml |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 20070811223               | 20102141732                     |
    And I am a device with the FlowGen serial number "20070811223"
    And I send the following registration
      | json                                                                                                                                                                                                                                                                                                                                              |
      | { "FG": {"SerialNo": "20070811223", "Software": "SX567-0100", "MID": 36, "VID": 26, "PCBASerialNo":"34090044", "ProductCode":"37001", "Configuration": "CX036-001-001-001-100-100-100" }, "CAM": {"SerialNo": "20102141732", "Software": "SX558-0100", "PCBASerialNo":"13152G00009", "Subscriptions": [  ] }, "Hum": {"Software": "SX556-0100"} } |

  @device.logs.S1
  @ECO-5809.1 @ECO-5809.2
  Scenario Outline: Queue invalid json device log messages
    When I send the following device logs
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the server should log a device logs error
      | ValidationVetoPoint   | ValidationFailureType   | ValidationFailureReason   |
      | <ValidationVetoPoint> | <ValidationFailureType> | <ValidationFailureReason> |
    Examples: These are bad json messages by way of missing required element
      | JSON                                                                                                                                                                  | ValidationVetoPoint | ValidationFailureType | ValidationFailureReason                                                                                                                                                                                                                                                                                                                                |
      | {                               "SubscriptionId": "341D4CDF-3A1B-4369-93C0-BF07573A6F5E", "Date": "1 day ago", "CollectTime": "today 140302", "Log.Type": "Log.CAM" } | IDENTITY_VALIDATION | IDENTITY_FIELD        | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/identity-schema.json#","pointer":""},"instance":{"pointer":""},"domain":"validation","keyword":"required","message":"missing required property(ies)","required":["CollectTime","Date","FG.SerialNo","SubscriptionId"],"missing":["FG.SerialNo"]} ] }    |
      | { "FG.SerialNo": "20070811223",                                                           "Date": "1 day ago", "CollectTime": "today 140302", "Log.Type": "Log.CAM" } | IDENTITY_VALIDATION | IDENTITY_FIELD        | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/identity-schema.json#","pointer":""},"instance":{"pointer":""},"domain":"validation","keyword":"required","message":"missing required property(ies)","required":["CollectTime","Date","FG.SerialNo","SubscriptionId"],"missing":["SubscriptionId"]} ] } |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "341D4CDF-3A1B-4369-93C0-BF07573A6F5E",                      "CollectTime": "today 140302", "Log.Type": "Log.CAM" } | IDENTITY_VALIDATION | IDENTITY_FIELD        | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/identity-schema.json#","pointer":""},"instance":{"pointer":""},"domain":"validation","keyword":"required","message":"missing required property(ies)","required":["CollectTime","Date","FG.SerialNo","SubscriptionId"],"missing":["Date"]} ] }           |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "341D4CDF-3A1B-4369-93C0-BF07573A6F5E", "Date": "1 day ago"                               , "Log.Type": "Log.CAM" } | IDENTITY_VALIDATION | IDENTITY_FIELD        | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/identity-schema.json#","pointer":""},"instance":{"pointer":""},"domain":"validation","keyword":"required","message":"missing required property(ies)","required":["CollectTime","Date","FG.SerialNo","SubscriptionId"],"missing":["CollectTime"]} ] }    |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "341D4CDF-3A1B-4369-93C0-BF07573A6F5E", "Date": "1 day ago", "CollectTime": "today 140302"                        } | FIELD_VALIDATION    | DEVICE_LOG_FIELD      | Invalid json: { "messages": [ {"level":"error","schema":{"loadingURI":"resource:/resmed/schema/device-log-schema.json#","pointer":""},"instance":{"pointer":""},"domain":"validation","keyword":"required","message":"missing required property(ies)","required":["Log.Type"],"missing":["Log.Type"]} ] }                                              |

  @device.logs.S2
  @ECO-5809.1 @ECO-5809.3
  Scenario Outline: Check the message queue by device serial number
    When I send the following device logs
      | json   |
      | <JSON> |
    Then I should receive a server ok response
    And the following device data received events have been published
      | JMSType    | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json   |
      | DEVICE_LOG | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | <JSON> |
    Examples: These are good json messages
      | JSON                                                                                                                                                                                                                                                                                                                               |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "341D4CDF-3A1B-4369-93C0-BF07573A6F5E", "Date": "1 day ago", "CollectTime": "today 140302", "FG.SoftwareID": "XS567-0400", "Log.Type": "Log.CAM", "Log.Level": "INFO", "Data": [ "Raw log data, [line one],", "one line at a time, no newline characters,", "until complete."] } |
    Examples: Only required fields are present in a good json message
      | JSON                                                                                                                                                                  |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "341D4CDF-3A1B-4369-93C0-BF07573A6F5E", "Date": "1 day ago", "CollectTime": "today 140302", "Log.Type": "Log.CAM" } |
    Examples: These are acceptable json messages by way of an extra element
      | JSON                                                                                                                                                                                                                                                                                                                                                     |
      | { "Log.ExtraField": 10, "FG.SerialNo": "20070811223", "SubscriptionId": "341D4CDF-3A1B-4369-93C0-BF07573A6F5E", "Date": "1 day ago", "CollectTime": "today 140302", "FG.SoftwareID": "XS567-0400", "Log.Type": "Log.CAM", "Log.Level": "INFO", "Data": [ "Raw log data, [line one],", "one line at a time, no newline characters,", "until complete."] } |

  @device.logs.S3
  @ECO-13276.7
  Scenario: Device log event from a suspended device should change status to active
    Given the communication module with serial number "20102141732" has suspended status for 1 days
    When I send the following device logs
      | json                                                                                                                                                                   |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "341D4CDF-3A1B-4369-93C0-BF07573A6F5E", "Date": "2 days ago", "CollectTime": "today 130302", "Log.Type": "Log.CAM" } |
    Then the following device data received events have been published
      | JMSType    | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                  |
      | DEVICE_LOG | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId": "341D4CDF-3A1B-4369-93C0-BF07573A6F5E", "Date": "2 day ago", "CollectTime": "today 130302", "Log.Type": "Log.CAM" } |
    Then the communication module with serial number "20102141732" should eventually have a status of "ACTIVE" within 5 seconds
    # If device is scrapped, Device log event received should still be stored
    When the communication module with serial number "20102141732" is scrapped
    And I send the following device logs
      | json                                                                                                                                                                  |
      | { "FG.SerialNo": "20070811223", "SubscriptionId": "341D4CDF-3A1B-4369-93C0-BF07573A6F5E", "Date": "1 day ago", "CollectTime": "today 140302", "Log.Type": "Log.CAM" } |
    Then the following device data received events have been published
      | JMSType    | JMSXGroupID | DeviceDataSource | DeviceFlowGenSerialNumber | DeviceMetadataIdentifier | DeviceVariantIdentifier | json                                                                                                                                                                  |
      | DEVICE_LOG | 20070811223 | DEVICE           | 20070811223               | 36                       | 26                      | { "FG.SerialNo": "20070811223", "SubscriptionId": "341D4CDF-3A1B-4369-93C0-BF07573A6F5E", "Date": "1 day ago", "CollectTime": "today 140302", "Log.Type": "Log.CAM" } |
