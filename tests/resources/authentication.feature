@newport
@newport.authentication
@ECO-4832
@ECO-5581
@ECO-5913
@ECO-5879
@ECO-14744
@ECO-14745
@ECO-14746
@ECO-15303
@ECO-14748
@ECO-14747
@ECO-17969

Feature:
  (ECO-4832) As a clinical user
   I want to know that a malicious 3rd party cannot send messages to ECO pretending to come from a device or to a device pretending to have come from ECO
  so that the integrity of the system is preserved.

  (ECO-5581) As ECO
   I want to be able to receive CAM subscriptions on registration
  so that registration operations do not fail

  (ECO-5879) As a clinical user
   I want to see the settings shown for a day that correspond to those used during treatment for the day
  so that I am not misled about the patients therapy

  (ECO-11891) As a Cellular Module,
   I want more explicit HTTP response codes on failures,
  so that I can react appropriately

  (ECO-14744) As a clinical user
   I want to know that a malicious 3rd party cannot send messages to Machine Portal pretending to come from a machine
  so that the integrity of the system is preserved.

  (ECO-14745) As a clinical user
   I want to know that a malicious 3rd party cannot send messages to Machine Portal pretending to come from a Monaco
  so that the integrity of the system is preserved.

  (ECO-15303) As ECO
   As a clinical user I want to know that a malicious 3rd party cannot send messages to Machine Portal pretending to come from a machine
  so that the integrity of the system is preserved.

  (ECO-14748) As ECO
   As a clinical user I want to know that a malicious 3rd party cannot send messages to Machine Portal pretending to come from a Newport
  so that the integrity of the system is preserved.

  (ECO-14747) As ECO
   As a clinical user I want to know that a malicious 3rd party cannot send messages to Machine Portal pretending to come from a Newport
   so that the integrity of the system is preserved.

  (ECO-17969) As a clinical user
  I want to know that a malicious 3rd party cannot send messages to Machine Portal pretending to come from a machine
  so that the integrity of the system is preserved.

    # ACCEPTANCE CRITERIA: (ECO-4832)
    # 1. Any incoming message from a device for which the calculated MD5 checksum does not match the value in the message shall be discarded i.e. the X-Hash field in the HTTP header. Note 1: An error does NOT need to be returned to the user in this event.
    # 2. Any incoming message from a device without the MD5 checksum shall be treated as an MD5 checksum failure.
    # 3. All outgoing messages for a device shall contain an MD5 checksum field. Note 2: Exceptions are the responses to POST and PUT commands which do not require the MD5 checksum field.
    # 4. The MD5 checksum shall be calculated using the message content or URI and an authentication key for the individual device as specified at http://confluence.corp.resmed.org/display/CA/Hash+Algorithms+-+new
    # 5. An MD5 checksum failure shall be logged including device details (serial number, IP address if possible). Note 3: The INFO level is appropriate.
    # 6. Add a switch to turn authentication on/off for incoming message from a device.
    # Note 4: The MD5 checksum is the X-Hash field in the HTTP header as per http://confluence.corp.resmed.org/display/CA/HTTP+Headers+-+new
    # Note 5: The authentication keys will generally be provided via the manufacturing interface when that is available.

    # ACCEPTANCE CRITERIA: (ECO-5581)
    # 1. CAM subscription information during Registration should be able to be received as per http://confluence.corp.resmed.org/x/YwGz
    #
    # Note 1: It is not necessary at this stage to do anything with the CAM subscription information. The important thing is to prevent all registrations failing.

    # ACCEPTANCE CRITERIA: (ECO-5913)
    # Note 1: This story relates to the NGCS to CAM interface interface.
    # 1. ECO shall return a 412 HTTP response code if message authentication fails due to the X-CAMSerialNo HTTP header value is not known to NGCS
    # 2. ECO shall return a 200 HTTP response code if message authentication fails due to the hash calculated, using the authentication key known to NGCS, does not match the X-Hash HTTP header valuer

    # ACCEPTANCE CRITERIA: (ECO-5879)
    # Note 1: The purpose of this story is to change the settings received that update the settings stored for the day in ECO and that are shown on reports. As per https://confluence.ec2.local/x/MZKeAQ the intent is to receive therapy session settings using a "Val" prefix whereas when writing settings a "Set" prefix should be used.
    # 1. ECO shall update the settings for a day of data when it receives the settings from the therapy session from the device. Note 2: These will use the "Val" prefix rather than the "Set" prefix but otherwise be unchanged from those received currently. The "Val" settings are received in a separate message to the "Set" settings - see Note 4 for an example.
    # Note 3: Once this card is implemented then acknowledgment of wireless settings will not work until ECO-5880 is complete.
    # Note 4: Example CPAP "Val" settings POST to ECO is as follows:
    # POST /api/v1/therapy/settings HTTP/1.1
    # X-CamSerialNo: {serial number}
    # X-Hash: {hash}
    #
    # {
    # "FG.SerialNo": "{serial number}",
    # "SubscriptionId": "{uuid-D}",
    # "Date": "20130429",
    # "CollectTime": "20130430 140302",
    # "Val.Mode": "CPAP",
    # "CPAP.Val.Press": 12.2,
    # "CPAP.Val.StartPress": 8.0,
    # "CPAP.Val.EPR.EPREnable":"On",
    # "CPAP.Val.EPR.EPRType": "FullTime",
    # "CPAP.Val.EPR.Level": 2,
    # "CPAP.Val.Ramp.RampEnable": "Off",
    # "CPAP.Val.Ramp.RampTime": 0
    # }
    # Note 5: This full list of new "Val" settings to be received are as follows:
    # "Val.Mode"
    # "CPAP.Val.Press"
    # "CPAP.Val.StartPress"
    # "CPAP.Val.EPR.EPREnable"
    # "CPAP.Val.EPR.EPRType"
    # "CPAP.Val.EPR.Level"
    # "CPAP.Val.Ramp.RampEnable"
    # "CPAP.Val.Ramp.RampTime"
    # "AutoSet.Val.MinPress"
    # "AutoSet.Val.MaxPress"
    # "AutoSet.Val.StartPress"
    # "AutoSet.Val.EPR.EPREnable"
    # "AutoSet.Val.EPR.EPRType"
    # "AutoSet.Val.EPR.Level"
    # "AutoSet.Val.Ramp.RampEnable"
    # "AutoSet.Val.Ramp.RampTime"
    # "AutoSet.Val.Comfort"
    # "HerAuto.Val.MinPress"
    # "HerAuto.Val.MaxPress"
    # "HerAuto.Val.StartPress"
    # "HerAuto.Val.EPR.EPREnable"
    # "HerAuto.Val.EPR.EPRType"
    # "HerAuto.Val.EPR.Level"
    # "HerAuto.Val.Ramp.RampEnable"
    # "HerAuto.Val.Ramp.RampTime"
    # "Val.ClimateControl"
    # "Val.HumEnable"
    # "Val.HumLevel"
    # "Val.TempEnable"
    # "Val.Temp",
    # "Val.Tube",
    # "Val.Mask",
    # "Val.SmartStart"

    # ACCEPTANCE CRITERIA: (ECO-11891)
    # 1. On an authentication failure, NGCS will return to Newport and Geneva cellular modules a non-200 HTTP response code
    # 1a. When the X-CamSerialNo HTTP Header is not provided or the value is blank, a 202 shall be returned
    # 1b. When the X-Hash HTTP Header is not provided or the value is blank, a 406 shall be returned
    # 1c. When content for PUT or POST fails due to Content-Length mismatch, a 400 shall be returned
    # 1d. When the server calculated hash and client hash do not match, a 401 shall be returned
    # Note 1: These response codes shall be configurable with the default as indicated above. Implementation shall use a container managed property so that changes do not require an OSGI bundle restart or node restart, but take immediate effect.
    # Note 2: When no content is provided on a PUT or POST, a 400 shall be returned. This is not testable via cucumber as Java/Jetty will thrown an exception and not enter the block of code currently implemented.
    # Note 3: When content for PUT or POST fails due to a timeout, a 408 shall be returned. This is not testable via cucumber, but a manual scenario will be introduced that will require inspection of the NGCS log.
    # Note 4: When the HTTP Method is not GET, PUT, or POST, a 405 shall be returned. This is not testable as Jetty will block the request before getting to the CXF interceptor. This is required in case a new HTTP method is introduced into NGCS and the interceptor has not been updated (safety valve).

    # ACCEPTANCE CRITERIA: (ECO-14744)
    # Note 1: Overview of Type 2 message signing can be found at https://confluence.ec2.local/display/NGCS/Protocol+%3A+Sequence+%3A+Newport+%3A+Authentication+%3A+Type+2
    # Note 2: Message signing specification can be found at https://confluence.ec2.local/display/NGCS/00+05+Authentication
    # Note 3: The term Security Tokens refers to both an Encryption Key Token and Signing Key Token
    # 1. The server shall provide Security Tokens
    # Note 4: An Encryption Key Token and a Signing Key Token will be specific to a Cellular Module
    # Note 5: Cellular Modules will be identified by a Globally Unique IDentifier (GUID) calculated by the Cellular Module and the server. Serial numbers must not be used in Production.
    # Note 6: The endpoint URI will be "/v1/cloud/access/cellularmodules/<GUID>". The HTTP method will be PUT.
    # Note 7: The algorithm to calculate the GUID has not yet been determined. Therefore, an additional endpoint that uses Cellular Module Serial Numbers will be created and removed in a subsequent card. The serial number based endpoint URI will be "/v1/cloud/access/cellularmodules/serialnumbers/<serialNumber>". The HTTP method will be PUT.
    # 1a. The response shall provide the identifier of the Cellular Module
    # 1b. The response shall provide the Encryption Key secret key offset location
    # 1c. The response shall provide the Encryption Key secret key length
    # 1d. The response shall provide the Encryption Key Token
    # 1e. The response shall provide the Encryption Key Token issuance date and time
    # 1f. The response shall provide the Encryption Key Token issuance expiry
    # 1g. The response shall provide the Signing Key secret key offset location
    # 1h. The response shall provide the Signing Key secret key length
    # 1i. The response shall provide the Signing Key Token
    # 1j. The response shall provide the Signing Key Token issuance date and time
    # 1k. The response shall provide the Signing Key Token issuance expiry
    # 1l. A response will be provided for all known Cellular Modules
    # 1m. A response will be provided for all unknown Cellular Modules
    # 1n. Requests for unknown Cellular Modules will be logged
    # Note 8: The secret key offset will be determined at token issuance. In order to facilitate feature synchronization with the Cellular Module team, the key offset will be configurable, initially defaulted to zero (0). A value of "-1" will perform a random choice of the offset.
    # Note 9: The secret key length will be configurable
    # Note 10: The Encryption Key Token expiry will be configurable, defaulted to 5 seconds for automated testing purposes. The Production environment value will be 5 minutes (5 x 60 = 300 seconds).
    # Note 11: The Signing Key Token expiry will be configurable (separate from the Encryption Key Token expiry), defaulted to 5 seconds for automated testing purposes. The Production environment value will be 5 minutes (5 x 60 = 300 seconds).
    # Note 12: If the Cellular Module is known, an Encryption Key will be generated from the Encryption Key Token and Cellular Module Secret.
    # Note 13: If the Cellular Module is known, a Signing Key will be generated from the Signing Key Token and Cellular Module Secret.
    # Note 14: The Encryption Key and Signing Key will be cluster cached (Hazelcast), separately, keyed by the Cellular Module GUID. The cache will be used to look up the Security Keys for validating the message signature and decryption.
    # Note 15: The logging will be an event sent to a JMS Dead Letter Queue (DLQ) including headers providing failure details.

    # ACCEPTANCE CRITERIA: (ECO-14745)
    # Note 1: Overview of Type 2 message signing can be found at https://confluence.ec2.local/display/NGCS/Protocol+%3A+Sequence+%3A+Newport+%3A+Authentication+%3A+Type+2
    # Note 2: Message signing specification can be found at https://confluence.ec2.local/display/NGCS/00+05+Authentication
    # Note 3: Signing Token generation is implemented by ECO-14744
    # Note 4: This is an additional message signing validation - both Type 1 and Type 2 Newport Authentication protocols will co-exist for the foreseeable future. It will not be possible to firmware upgrade 100% of machines in the field (e.g. out of communications, sitting at the bottom of the ocean, etc). However, the code should be structured to keep the two implementations separate for flexibility in deployment. The choice of validation will be determined from the machine provided HTTP headers - X-CamSerialNo and X-Hash must invoke Type 1 validation while Authorization must invoke Type 2 validation.
    # 1. Any incoming message from a machine for which the calculated signature matches the signature provided is an authentication success and the client will get a 2xx series HTTP response code from the backing service.
    # Note 5: The message signature will be calculated using the message content and the cluster cached Signing Key for the Cellular Module as documented in the specification.
    # 2. Any incoming message from a machine without a signature or insufficient signature is an authentication failure
    # Note 6: Only GET, PUT, and POST HTTP methods will be supported. If the method is not supported, the client will get a HTTP response code of 405 (Method Not Allowed) and an Allow HTTP header that specifies "POST". An error event will be sent to a JMS Dead Letter Queue (DLQ) including headers providing failure details.
    # Note 7: The HTTP Authorization header will be used to provide the signature: "Authorization: Signature cellularModule="<CM GUID>", signature="<signature>"
    # 2a. The client will get a HTTP response code of 401 (Unauthorized)
    # 2b. The client will get a WWW-Authenticate HTTP header that specifies a "Signature" challenge
    # 2c. The authentication failure will be logged
    # Note 8: The logging will be an event sent to a JMS Dead Letter Queue (DLQ) including headers providing failure details (AuthenticationVetoPoint, AuthenticationFailureType, AuthenticationFailureReason. Optionally, AuthenticationExceptionStackTrace, and AuthenticationExceptionMessage)
    # 3. Any incoming message from a machine for which the server side signature could not be calculated is an authentication failure
    # Note 9: For example, no Signing Key found in the cluster cache
    # Note 10: On first use, the Signing Key will expire in a configurable number of seconds, defaulted to 5 for automated testing purposes. The Production environment value will be 10 minutes (10 x 60 = 600 seconds).
    # 3a. The client will get a HTTP response code of 401 (Unauthorized)
    # 3b. The client will get a WWW-Authenticate HTTP header that specifies a "Signature" challenge
    # 3c. The authentication failure will be logged
    # 4. Any incoming message from a machine for which the calculated signature does not match the signature provided is an authentication failure
    # 4a. The client will get a HTTP response code of 401 (Unauthorized)
    # 4b. The client will get a WWW-Authenticate HTTP header that specifies a "Signature" challenge
    # 4c. The authentication failure will be logged
    # Note 11: For performance testing purposes, a configuration property will be introduced to allow invalid signatures for incoming message. By default, the configuration property should turn signature authentication on for all incoming messages. In order to give the most realistic performance test results, the scope of this configuration property should be limited to simply allowing an invalid signature - all other code must be exercised (i.e. database lookup, cluster cache lookup, signature calculations, etc).

    # ACCEPTANCE CRITERIA: (ECO-15303)
    # 1. All response messages to a machine's request shall include a signature
    # 1a. When the response contains message content, the signature shall be calculated over the message content
    # 1b. When the response does not contain any message content, the signature shall be calculated over generated content
    # Note 5: The generated content will be 32 securely random bytes.

    # ACCEPTANCE CRITERIA: (ECO-14748)
    # 1. Any incoming message from a machine for which the encrypted content is decrypted is an authentication success and the client will get a 2xx series HTTP response code from the backing service.
    # Note 7: Decryption will use the communicated initialization vector and the cluster cached Encryption Key for the Cellular Module as documented in the specification.
    # 2. Any incoming message from a machine without encryption details or insufficient encryption details is an authentication failure
    # Note 8: Only GET, PUT, and POST HTTP methods will be supported. If the method is not supported, the client will get a HTTP response code of 405 (Method Not Allowed) and an Allow HTTP header that specifies "POST". An error event will be sent to a JMS Dead Letter Queue (DLQ) including headers providing failure details.
    # Note 9: The HTTP Authorization header will be used to provide the encryption details: "Authorization: Encryption cellularModule="<CM GUID>" initializationVector="<vector>"
    # 2a. The client will get a HTTP response code of 401 (Unauthorized)
    # 2b. The client will get a WWW-Authenticate HTTP header that specifies a "Encryption" challenge
    # 2c. The authentication failure will be logged
    # Note 10: The logging will be an event sent to a JMS Dead Letter Queue (DLQ) including headers providing failure details (AuthenticationVetoPoint, AuthenticationFailureType, AuthenticationFailureReason. Optionally, AuthenticationExceptionStackTrace, and AuthenticationExceptionMessage)
    # 3. Any incoming message from a machine for which the server side does not have the necessary cryptography detail for decryption is an authentication failure
    # Note 11: For example, no Encryption Key found in the cluster cache
    # Note 12: On first use, the Encryption Key will expire in a configurable number of seconds, defaulted to 5 for automated testing purposes. The Production environment value will be 10 minutes (10 x 60 = 600 seconds).
    # 3a. The client will get a HTTP response code of 401 (Unauthorized)
    # 3b. The client will get a WWW-Authenticate HTTP header that specifies a "Encryption" challenge
    # 3c. The authentication failure will be logged
    # 4. Any incoming message from a machine for which the encrypted content could not be correctly decrypted with all inputs is an authentication failure
    # 4a. The client will get a HTTP response code of 401 (Unauthorized)
    # 4b. The client will get a WWW-Authenticate HTTP header that specifies a "Encryption" challenge
    # 4c. The authentication failure will be logged
    # Note 13: For performance testing purposes, a configuration property will be introduced to allow invalid decryption for incoming message. By default, the configuration property should turn decryption authentication on for all incoming messages. In order to give the most realistic performance test results, the scope of this configuration property should be limited to simply allowing an invalid decryption - all other code must be exercised (i.e. database lookup, cluster cache lookup, signature calculations, etc).

    # ACCEPTANCE CRITERIA: (ECO-14747)
    # 1. All responses to a request shall be encrypted
    # 1a. When the response contains message content, the message content shall be encrypted prior to transmission
    # 1b. When the response does not contain any message content, the generated content shall be encrypted prior to transmission
    # 1c. The signature shall be calculated over the encrypted content

    # ACCEPTANCE CRITERIA: (ECO-17969)
    # Note 1: Overview of Type 2 message signing can be found at https://confluence.ec2.local/display/NGCS/Protocol+%3A+Sequence+%3A+Newport+%3A+Authentication+%3A+Type+2
    # Note 2: Message signing specification can be found at https://confluence.ec2.local/display/NGCS/00+05+Authentication
    # Note 3: New Newport and Geneva cellular modules will be manufactured with 128 bytes of security data instead of a 32 byte authentication key. The Version 1 Manufacturing Interface changes are implemented by ECO-16986. The goal is to update Type 2 Authentication to use a cellular module's 128 byte security data for private keys if present; otherwise, default back to using the 32 byte authentication key.
    # Note 4: To mitigate a harvesting attack vector, the token offset will be randomly generated from 0 to 1023, inclusive. The token offset will be mapped into the cellular module's 32 or 128 byte range.
    # 1. The server shall select a private key, for use in an encryption key or a signing key, from a cellular module's 128 byte security data when the cellular module 128 byte security data is available.
    # 2. The server shall select a private key, for use in an encryption key or signing key, from a cellular module's 32 byte authentication key when no cellular module 128 byte security data is available.

   Background:
      Given devices with following properties have been manufactured
         | moduleSerial | authKey                          | flowGenSerial | deviceNumber | mid | vid | pcbaSerialNo | internalCommModule | cellularModuleUid                    | productCode |
         | 20102141732  | 20191348315797634967219568325609 | 20070811223   | 123          | 36  | 26  | 1A345678     | true               | d5682a7c-4ca8-4c60-85fc-2d7717667ff8 | 9745        |
     And the server waits for the device manufactured queue to be empty
     And the server should not produce device manufactured error
     And I am a device with the FlowGen serial number "20070811223"

  @newport.authentication.S1
  @ECO-4832.1 @ECO-4832.2 @ECO-4832.4
  @ECO-5913.2
  @ECO-11891.1 @ECO-11891.1b @ECO-11891.1d
   Scenario Outline: Device receives appropriate response with no message content when a GET request is sent without a valid  X-Hash header.
      Given the server has authentication flag true
      And the server has the following upgrades to be sent to devices
         | json                                                                                                                                                                                                           |
         | { "FG.SerialNo": "20070811223", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
      When I request the upgrade with identifier "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E" and following X-Hash header
         | xHashHeader |
         | <HASH>      |
      Then I should receive the following authentication response
         | responseCode   | xHashHeader | typeName | messageContent |
         | <ResponseCode> |             | upgrade  |                |
      And the following invalid newport authentication error was published
         | expect | authenticationVetoPoint   | authenticationFailureType   | authenticationFailureReason   | body   |
         | <DLQ>  | <AuthenticationVetoPoint> | <AuthenticationFailureType> | <AuthenticationFailureReason> | <BODY> |
      Then the upgrade response body should be empty
      Examples:
         | HASH     | ResponseCode | DLQ | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                           | BODY                                                  |
         |          | 406          | yes | HEADER                  | MISSING_HEADER            | Required HTTP header X-Hash is missing                |                                                       |
         | ABCD1234 | 401          | yes | HASH                    | HASH_MISMATCH             | Calculated signature does not match request signature | /api/v1/upgrades/B2AE8F06-1541-4616-AE6F-F9E4C079CC6E |

  @newport.authentication.S2
  @ECO-4832.1 @ECO-4832.2 @ECO-4832.4
  @ECO-5913.2
  @ECO-5581.1
  @ECO-11891.1 @ECO-11891.1b @ECO-11891.1d
   Scenario Outline: Device receives appropriate response with no message content when a PUT request is sent without a valid X-Hash header, registration happens for valid XHash only
      Given the server has authentication flag true
      When I send the following registration and X-Hash header
         | xHashHeader | json                                                                                                                                                                                                                                                                                                                              |
         | <HASH>      | { "FG": {"SerialNo": "20070811223", "Software": "FGABCDEFH", "MID": 36, "VID": 26, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "20102141732", "Software": "CAMABCDEFH", "PCBASerialNo":"1A345678", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
      Then I should receive the following authentication response
         | responseCode   | xHashHeader | typeName | messageContent |
         | <ResponseCode> |             |          |                |
      And the following invalid newport authentication error was published
         | expect | authenticationVetoPoint   | authenticationFailureType   | authenticationFailureReason   | body   |
         | <DLQ>  | <AuthenticationVetoPoint> | <AuthenticationFailureType> | <AuthenticationFailureReason> | <BODY> |
      And the device <IS> registered
      Examples:
         | ResponseCode | HASH     | IS     | DLQ | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                           | BODY                                                                                                                                                                                                                                                                                                                              |
         | 200          | 58F51BFF | is     | no  |                         |                           |                                                       |                                                                                                                                                                                                                                                                                                                                   |
         | 406          |          | is not | yes | HEADER                  | MISSING_HEADER            | Required HTTP header X-Hash is missing                |                                                                                                                                                                                                                                                                                                                                   |
         | 401          | ABCD1234 | is not | yes | HASH                    | HASH_MISMATCH             | Calculated signature does not match request signature | { "FG": {"SerialNo": "20070811223", "Software": "FGABCDEFH", "MID": 36, "VID": 26, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "20102141732", "Software": "CAMABCDEFH", "PCBASerialNo":"1A345678", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |

  @newport.authentication.S3
  @ECO-4832.1 @ECO-4832.2 @ECO-4832.4
  @ECO-5913.2
  @ECO-5879.1
  @ECO-11891.1 @ECO-11891.1b @ECO-11891.1d
   Scenario Outline: Device receives appropriate response with no message content when a POST request is sent without a valid  X-Hash header.
      Given the server has authentication flag true
      And these devices have the following <Type>
         | json   |
         | <Body> |
      When I send the <Type> from 1 days ago with X-Hash header "<HASH>"
      Then I should receive the following authentication response
         | responseCode   | xHashHeader | typeName | messageContent |
         | <ResponseCode> |             | <Type>   |                |
      And no device data received events have been published
      Examples:
         | ResponseCode | HASH     | Type              | Body                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
         | 406          |          | therapy summaries | { "FG.SerialNo": "20070811223", "SubscriptionId": "SummaryCPAP", "Date": "1 day ago", "CollectTime": "today 010101", "Val.Mode": "CPAP", "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":7.3, "Val.Leak.Max":12.3, "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
         | 401          | ABCD1234 | therapy summaries | { "FG.SerialNo": "20070811223", "SubscriptionId": "SummaryCPAP", "Date": "1 day ago", "CollectTime": "today 010101", "Val.Mode": "CPAP", "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":7.3, "Val.Leak.Max":12.3, "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
         | 401          | ABCD1234 | therapy settings  | { "FG.SerialNo": "20070811223", "SubscriptionId": "SettingCPAP", "Date": "1 day ago", "CollectTime": "today 010101", "Val.Mode": "CPAP", "CPAP.Val.Press":12.3,"CPAP.Val.StartPress":8.1,"CPAP.Val.EPR.EPREnable":"On","CPAP.Val.EPR.EPRType":"FullTime","CPAP.Val.EPR.Level":2,"CPAP.Val.Ramp.RampEnable":"Off","CPAP.Val.Ramp.RampTime":0 }                                                                                                                                    |

  @newport.authentication.S4
  @ECO-4832.1 @ECO-4832.2 @ECO-4832.6
  @ECO-5913.2
  @ECO-11891.1 @ECO-11891.1b
   Scenario: When device sends GET request without X-Hash header and server has authentication is turned off, it receives the correct upgrade .
      Given the server has authentication flag false
      And the server has the following upgrades to be sent to devices
         | json                                                                                                                                                                                                           |
         | { "FG.SerialNo": "20070811223", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
      When I request the upgrade with identifier "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E" and following X-Hash header
         | xHashHeader |
         |             |
      Then I should receive the following authentication response
         | responseCode | typeName |
         | 406          | upgrade  |
      And the upgrade response body should be empty
      And the following invalid newport authentication error was published
         | expect | authenticationVetoPoint | authenticationFailureType | authenticationFailureReason            | body |
         | yes    | HEADER                  | MISSING_HEADER            | Required HTTP header X-Hash is missing |      |

  @newport.authentication.S5 @manual-verify
  @ECO-4832.1 @ECO-4832.2 @ECO-4832.4 @ECO-4832.5
  @ECO-5913.2
  @ECO-11891.1 @ECO-11891.1b @ECO-11891.1d
   Scenario Outline: Device receives appropriate response with no message content when a GET request is sent without a valid  X-Hash header.
      Given the server has authentication flag true
      And the server has the following upgrades to be sent to devices
         | json                                                                                                                                                                                                           |
         | { "FG.SerialNo": "20070811223", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
      When I request the upgrade with identifier "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E" and following X-Hash header
         | xHashHeader |
         | <HASH>      |
      Then I should receive the following authentication response
         | responseCode   | xHashHeader | typeName | messageContent |
         | <ResponseCode> |             | upgrade  |                |
      And the following invalid newport authentication error was published
         | expect | authenticationVetoPoint   | authenticationFailureType   | authenticationFailureReason   | body   |
         | <DLQ>  | <AuthenticationVetoPoint> | <AuthenticationFailureType> | <AuthenticationFailureReason> | <BODY> |
      And I manually verify that the message required <Message> to the server log
      Examples:
         | HASH     | Message                      | ResponseCode | DLQ | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                           | BODY                                                  |
         |          | X-Hash is missing in headers | 406          | yes | HEADER                  | MISSING_HEADER            | Required HTTP header X-Hash is missing                |                                                       |
         | ABCD1234 | authentication FAILED        | 401          | yes | HASH                    | HASH_MISMATCH             | Calculated signature does not match request signature | /api/v1/upgrades/B2AE8F06-1541-4616-AE6F-F9E4C079CC6E |

  @newport.authentication.S6 @manual-verify
  @ECO-4832.1 @ECO-4832.2 @ECO-4832.4 @ECO-4832.5
  @ECO-5913.2
  @ECO-5581.1
  @ECO-11891.1 @ECO-11891.1b @ECO-11891.1d
   Scenario Outline: Device receives appropriate response with no message content when a PUT request is sent without a valid X-Hash header.
      Given the server has authentication flag true
      When I send the following registration and X-Hash header
         | xHashHeader | json                                                                                                                                                                                                                                                                                                                              |
         | <HASH>      | { "FG": {"SerialNo": "20070811223", "Software": "FGABCDEFH", "MID": 36, "VID": 26, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "20102141732", "Software": "CAMABCDEFH", "PCBASerialNo":"1A345678", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
      Then I should receive the following authentication response
         | responseCode   | xHashHeader | typeName     | messageContent |
         | <ResponseCode> |             | registration |                |
      And the following invalid newport authentication error was published
         | expect | authenticationVetoPoint   | authenticationFailureType   | authenticationFailureReason   | body   |
         | <DLQ>  | <AuthenticationVetoPoint> | <AuthenticationFailureType> | <AuthenticationFailureReason> | <BODY> |
      And I manually verify that the message required <Message> to the server log
      Examples:
         | HASH     | Message                      | ResponseCode | DLQ | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                           | BODY                                                                                                                                                                                                                                                                                                                              |
         |          | X-Hash is missing in headers | 406          | yes | HEADER                  | MISSING_HEADER            | Required HTTP header X-Hash is missing                |                                                                                                                                                                                                                                                                                                                                   |
         | ABCD1234 | authentication FAILED        | 401          | yes | HASH                    | HASH_MISMATCH             | Calculated signature does not match request signature | { "FG": {"SerialNo": "20070811223", "Software": "FGABCDEFH", "MID": 36, "VID": 26, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "20102141732", "Software": "CAMABCDEFH", "PCBASerialNo":"1A345678", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |

  @newport.authentication.S7 @manual-verify
  @ECO-4832.1 @ECO-4832.2 @ECO-4832.4 @ECO-4832.5
  @ECO-5913.2
  @ECO-11891.b @ECO-11891.1d
   Scenario Outline: Device receives appropriate response with no message content when a POST request is sent without a valid  X-Hash header.
      Given the server has authentication flag true
      And these devices have the following therapy summaries
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
         | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryCPAP", "Date":"1 day ago",  "CollectTime":"today 010101", "Val.Mode":"CPAP", "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":7.3, "Val.Leak.Max":12.3, "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
      When I send the therapy summaries from 1 days ago with X-Hash header "<HASH>"
      Then I should receive the following authentication response
         | responseCode   | xHashHeader | typeName     | messageContent |
         | <ResponseCode> |             | registration |                |
      And I manually verify that the message required <Message> to the server log
      Examples:
         | HASH     | Message                      | ResponseCode | DLQ | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                           | BODY                                                                                                                                                                                                                                                                                                                              |
         |          | X-Hash is missing in headers | 406          | yes | HEADER                  | MISSING_HEADER            | Required HTTP header X-Hash is missing                |                                                                                                                                                                                                                                                                                                                                   |
         | ABCD1234 | authentication FAILED        | 401          | yes | HASH                    | HASH_MISMATCH             | Calculated signature does not match request signature | { "FG": {"SerialNo": "20070811223", "Software": "FGABCDEFH", "MID": 36, "VID": 26, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "20102141732", "Software": "CAMABCDEFH", "PCBASerialNo":"1A345678", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |

  @newport.authentication.S8
  @ECO-5913.1
  @ECO-11891.1 @ECO-11891.1d
   Scenario Outline: Device receives PRECONDITION_FAILED response when a GET request is sent with an unknown X-CamSerialNo header.
      Given the server has authentication flag true
      And the server has the following upgrades to be sent to devices
         | json                                                                                                                                                                                                           |
         | { "FG.SerialNo": "20070811223", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
      When I request the upgrade with identifier "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E" and following X-Hash and X-CamSerialNo headers
         | xHashHeader | xCamSerialNoHeader |
         | A3EC6801    | <CAMSERIALNO>      |
      Then I should receive the following authentication response
         | responseCode   | xHashHeader | typeName | messageContent |
         | <RESPONSECODE> |             | upgrade  |                |
      And the following invalid newport authentication error was published
         | expect | authenticationVetoPoint   | authenticationFailureType   | authenticationFailureReason   | body   |
         | <DLQ>  | <AuthenticationVetoPoint> | <AuthenticationFailureType> | <AuthenticationFailureReason> | <BODY> |
      Examples:
         | CAMSERIALNO   | RESPONSECODE | DLQ | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                               | BODY                                                  |
         | 1111111888888 | 200          | yes | HEADER                  | INVALID_X_CAM_SERIAL      | X-CamSerialNo did not match regular expresion ^[0-9]{11}$ |                                                       |
         | 20102141732   | 401          | yes | HASH                    | HASH_MISMATCH             | Calculated signature does not match request signature     | /api/v1/upgrades/B2AE8F06-1541-4616-AE6F-F9E4C079CC6E |
         | 11111118883   | 412          | yes | DEVICE                  | DEVICE_UNKNOWN            | Machine is not known                                      |                                                       |

  @newport.authentication.S9
  @ECO-5913.1
  @ECO-11891.1 @ECO-11891.1a
   Scenario: Device receives PRECONDITION_FAILED response when a request is sent with an unknown X-CamSerialNo header.
      Given the server has authentication flag true
      And the server has the following upgrades to be sent to devices
         | json                                                                                                                                                                                                           |
         | { "FG.SerialNo": "20070811223", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
      When I request the upgrade with identifier "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", a specific X-Hash header and missing X-CamSerialNo header
         | xHashHeader |
         | A3EC6801    |
      Then I should receive the following authentication response
         | responseCode | xHashHeader | typeName | messageContent |
         | 202          |             | upgrade  |                |
      And the following invalid newport authentication error was published
         | expect | authenticationVetoPoint | authenticationFailureType | authenticationFailureReason                   | body |
         | yes    | HEADER                  | MISSING_HEADER            | Required HTTP header X-CamSerialNo is missing |      |

  @newport.authentication.S10 @manual-verify
  @ECO-11891.1 @ECO-11891.1c
   Scenario Outline: Device receives appropriate response with no message content when a PUT request is sent.
      Given the server has authentication flag true
      When I send the following registration and X-Hash header
         | xHashHeader | json |
         | <HASH>      |      |
      Then I should receive the following authentication response
         | responseCode   | xHashHeader | typeName     | messageContent |
         | <ResponseCode> |             | registration |                |
      And the following invalid newport authentication error was published
         | expect | authenticationVetoPoint   | authenticationFailureType   | authenticationFailureReason   | body   |
         | <DLQ>  | <AuthenticationVetoPoint> | <AuthenticationFailureType> | <AuthenticationFailureReason> | <BODY> |
      And I manually verify that the message required <Message> to the server log
      Examples:
         | HASH     | Message                     | ResponseCode | DLQ | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason | BODY |
         | 246B3FDC | no message content received | 400          | yes | CONTENT                 | NO_CONTENT                | No message content received |      |

  @newport.authentication.S11 @manual-verify
  @ECO-11891.b @ECO-11891.1c
   Scenario Outline: Device receives Bad Request response with no message content when a POST request is sent.
      Given the server has authentication flag true
      And these devices have the following therapy summaries
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
         | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryCPAP", "Date":"1 day ago",  "CollectTime":"today 010101", "Val.Mode":"CPAP", "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":7.3, "Val.Leak.Max":12.3, "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
      When I send the therapy summaries from 0 days ago with X-Hash header "<HASH>"
      Then I should receive the following authentication response
         | responseCode   | xHashHeader | typeName     | messageContent |
         | <ResponseCode> |             | registration |                |
      And the following invalid newport authentication error was published
         | expect | authenticationVetoPoint   | authenticationFailureType   | authenticationFailureReason   | body   |
         | <DLQ>  | <AuthenticationVetoPoint> | <AuthenticationFailureType> | <AuthenticationFailureReason> | <BODY> |
      And I manually verify that the message required <Message> to the server log
      Examples:
         | ResponseCode | HASH     | Message                     | DLQ | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason | BODY |
         | 400          | 246B3FDC | no message content received | yes | CONTENT                 | NO_CONTENT                | No message content received |      |

  @manual
  @newport.authentication.S12 @manual-verify
  @ECO-11891.1
   Scenario Outline: Device receives 408 (timeout) response with no message content when a POST request is sent.
      Given the server has authentication flag true
      And these devices have the following therapy summaries
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
         | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryCPAP", "Date":"1 day ago",  "CollectTime":"today 010101", "Val.Mode":"CPAP", "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":7.3, "Val.Leak.Max":12.3, "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
      When I POST the following incomplete content to the server with X-Hash header "<HASH>"
         | extraContentLength | xCamSerialNo   | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
         | 5                  | <XCAMSERIALNO> | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryCPAP", "Date":"1 day ago",  "CollectTime":"today 010101", "Val.Mode":"CPAP", "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":7.3, "Val.Leak.Max":12.3, "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
      Then I manually verify that the message <Message> with <Status> and exception message <Exception> is written to the server log
      Examples:
         | HASH     | Message                              | Exception               | Status       | XCAMSERIALNO |
         | B4018D9C | 'unable to retrieve message content' | 'EofException: timeout' | 'status=408' | 20102141732  |

  @manual
  @newport.authentication.S13 @manual-verify
  @ECO-11891.1
   Scenario Outline: Device receives 408 (timeout) response with no message content when a PUT request is sent.
      When I PUT the following incomplete content to the server with X-Hash header "<HASH>"
         | extraContentLength | xCamSerialNo   | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
         | 5                  | <XCAMSERIALNO> | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryCPAP", "Date":"1 day ago",  "CollectTime":"today 010101", "Val.Mode":"CPAP", "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":7.3, "Val.Leak.Max":12.3, "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
      Then I manually verify that the message <Message> with <Status> and exception message <Exception> is written to the server log
      Examples:
         | HASH     | Message                              | Exception               | Status       | XCAMSERIALNO |
         | 246B3FDC | 'unable to retrieve message content' | 'EofException: timeout' | 'status=408' | 20102141732  |

  @newport.authentication.S14
  @ECO-4832.1 @ECO-4832.2 @ECO-4832.4
  @ECO-5913.2
  @ECO-5581.1
  @ECO-11891.1 @ECO-11891.1b @ECO-11891.1d
   Scenario Outline: Device receives appropriate response with no message content when a PUT request is sent without a valid X-Hash header, registration happens for valid XHash only
      # Deprecated
      Given the following subscriptions are loaded into NGCS
         | /data/subscription_SummaryCPAP.json |
      And devices with following properties have been manufactured
         | moduleSerial | authKey                          | flowGenSerial | deviceNumber | mid | vid | pcbaSerialNo | internalCommModule | productCode |
         | 20102141733  | 20109713438314580785238450128535 | 20070811224   | 124          | 36  | 26  | 1A345679     | true               | 9745        |
    And the server waits for the device manufactured queue to be empty
    And the server should not produce device manufactured error
    And the server has authentication flag true
      When I send the following registration and X-Hash header
         | xHashHeader | json                                                                                                                                                                                                                                                                                                                                         |
         | B00A21FA    | { "FG": {"SerialNo": "20070811223", "Software": "FGABCDEFH", "MID": 36, "VID": 26, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "20102141732", "Software": "CAMABCDEFH", "PCBASerialNo":"1A345678", "Subscriptions": ["SummaryCPAP"] }, "Hum": {"Software": "HUMABCDEFH"} } |
      Then I should receive a server ok response
      And these devices have the following therapy summaries
         | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
         | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryCPAP", "Date":"20130430",  "CollectTime":"20130430 140302", "Val.Mode":"CPAP", "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":7.3, "Val.Leak.Max":12.3, "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
      And I am a device with the FlowGen serial number "20070811224"
      And I send the following registration and X-Hash header
         | xHashHeader | json                                                                                                                                                                                                                                                                                                                              |
         | 4C6673C0    | { "FG": {"SerialNo": "20070811224", "Software": "FGABCDEFH", "MID": 36, "VID": 26, "PCBASerialNo":"1A345679", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "20102141733", "Software": "CAMABCDEFH", "PCBASerialNo":"1A345679", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
      Then I should receive a server ok response
      When I send the following therapy summaries and X-Hash header
         | xHashHeader | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
         |             | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryCPAP", "Date":"20130430",  "CollectTime":"20130430 140302", "Val.Mode":"CPAP", "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":7.3, "Val.Leak.Max":12.3, "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |
      Then I should receive the following authentication response
         | responseCode   | xHashHeader | typeName | messageContent |
         | <ResponseCode> |             |          |                |
      And the following invalid therapy summaries error was published
         | expect | ValidationVetoPoint   | ValidationFailureType   | ValidationFailureReason   | body   |
         | <DLQ>  | <ValidationVetoPoint> | <ValidationFailureType> | <ValidationFailureReason> | <BODY> |
      And the device <IS> registered
      Examples:
         | ResponseCode | IS | DLQ | ValidationVetoPoint      | ValidationFailureType        | ValidationFailureReason                                                        | BODY                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
         | 200          | is | yes | AUTHORIZATION_VALIDATION | FLOW_GENERATOR_SERIAL_NUMBER | Flow Generator serial number from data does not match the authorizing machine. | { "FG.SerialNo": "20070811223", "SubscriptionId":"SummaryCPAP", "Date":"20130430",  "CollectTime":"20130430 140302", "Val.Mode":"CPAP", "Val.Duration":600, "Val.MaskOn":[ 120, 340, 450 ], "Val.MaskOff":[ 300, 400, 1200 ], "Val.AHI":5.5, "Val.AI":5.5, "Val.HI":5.5, "Val.OAI":5.5, "Val.CAI":5.5, "Val.UAI":5.5, "Val.Leak.50":4.3, "Val.Leak.95":7.3, "Val.Leak.Max":12.3, "Val.CSR":990, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25 } |

   @newport.authentication.S15
   @ECO-14744.1 @ECO-14744.1a @ECO-14744.1b @ECO-14744.1c @ECO-14744.1d @ECO-14744.1e @ECO-14744.1f @ECO-14744.1g @ECO-14744.1h @ECO-14744.1i @ECO-14744.1j @ECO-14744.1k @ECO-14744.1l
   Scenario: For the given Cellular Module GUID the Machine Portal shall provide a Security Token
      When the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
         | d5682a7c-4ca8-4c60-85fc-2d7717667ff8 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      Then I should receive a server ok response

   @newport.authentication.S16
   @ECO-14744.1m @ECO-14744.1n
   Scenario: For the given non-existent Cellular Module GUID Machine Portal shall still provide a fake Security Token and log it
      When the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
         | 22161295306                          | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      Then Machine Portal will log a failed attempt to a JMS Queue with the following headers
         | GUID        |
         | 22161295306 |

   @newport.authentication.S17
   @ECO-14745.1
   @ECO-14745.2 @ECO-14745.2a @ECO-14745.2b @ECO-14745.2c
   @ECO-15303.1b
   Scenario: For the given Cellular Module, Machine Portal shall be able to validate incoming signature
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
      And the server has authentication flag true
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And I should receive a server ok response
      When I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
      Then I should receive a server ok response
      And the response is signed by Authorization header based on its content with the following details
         | cellularModuleGuid                   |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
      When the cellular module updates authentication context
      And I send newport version 3 registration data with paired cellular module type 2 insufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
      Then I should receive a server Unauthorized response
      And I should receive the following HTTP Headers
         | Key              | Value                |
         | WWW-Authenticate | Encryption,Signature |
      And the attempt is sent to the newport authentication failure log
         | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                         |
         | HEADER                  | MISSING_VALUE             | Required HTTP header value for signature is missing |

   @newport.authentication.S18
   @ECO-14745.3 @ECO-14745.3a @ECO-14745.3b @ECO-14745.3c
   Scenario: For the given Cellular Module, Machine Portal will reject incoming message due to signing key not found
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
      And the server has authentication flag true
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
         | eca847f8-3950-45c1-aac0-ab7b00b05599 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And I should receive a server ok response
      When I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | eca847f8-3950-45c1-aac0-ab7b00b05599 | /data/unit/newport/registration/flowgenerator/22161295306.json |
      Then I should receive a server Precondition Failed response
      And the attempt is sent to the newport authentication failure log
         | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason |
         | DEVICE                  | DEVICE_UNKNOWN            | Machine is not known        |
      When the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And I should receive a server ok response
      And I pause for 10 seconds
      And I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
      Then I should receive a server Unauthorized response
      And I should receive the following HTTP Headers
         | Key              | Value                |
         | WWW-Authenticate | Encryption,Signature |
      And the attempt is sent to the newport authentication failure log
         | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                                        |
         | SIGNATURE               | MISSING_SIGNING_KEY       | Signing key for 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 was not found |

   @newport.authentication.S19
   @ECO-14745.4 @ECO-14745.4a @ECO-14745.4b @ECO-14745.4c
   Scenario: For the given Cellular Module, Machine Portal will reject incoming message due to signature calculation missmatch
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
      And the server has authentication flag true
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And I should receive a server ok response
      When I send newport version 3 registration data with paired cellular module type 2 incorrect signature and sufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
      Then I should receive a server Unauthorized response
      And I should receive the following HTTP Headers
         | Key              | Value                |
         | WWW-Authenticate | Encryption,Signature |
      And the attempt is sent to the newport authentication failure log
         | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                           |
         | SIGNATURE               | SIGNATURE_MISMATCH        | Calculated signature does not match request signature |

   @newport.authentication.S20
   @ECO-14746.1
   @ECO-14746.2 @ECO-14746.2a @ECO-14746.2b @ECO-14746.2c @ECO-14746.2d
   @ECO-14747.1 @ECO-14747.1a @ECO-14747.1b @ECO-14747.1c
   Scenario: For the given Cellular Module, Machine Portal shall be able to validate incoming signature
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
      And the server has authentication flag true
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And I should receive a server ok response
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
      When the server has the following therapy settings to be sent to devices
         | json                                                                                                                                                                                                                                                                                                                        |
         | { "FG.SerialNo": "22161295306", "SettingsId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7", "Set.Mode": "CPAP", "CPAP.Set.Press": 14.0, "CPAP.Set.StartPress": 8.0, "CPAP.Set.EPR.EPREnable": "On", "CPAP.Set.EPR.EPRType": "FullTime", "CPAP.Set.EPR.Level": 2, "CPAP.Set.Ramp.RampEnable": "On", "CPAP.Set.Ramp.RampTime": 30 } |
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
      When the cellular module updates authentication context
      And I request version 2 broker requests for paired cellular module with insufficient type 2 authentication
         | cellularModuleGuid                   |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
      Then I should receive a server Unauthorized response
      And I should receive the following HTTP Headers
         | Key              | Value                |
         | WWW-Authenticate | Encryption,Signature |
      And the attempt is sent to the newport authentication failure log
         | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                         |
         | HEADER                  | MISSING_VALUE             | Required HTTP header value for signature is missing |

   @newport.authentication.S21
   @ECO-14746.3 @ECO-14746.3a @ECO-14746.3b @ECO-14746.3c @ECO-14746.3d
   Scenario: For the given Cellular Module, Machine Portal will reject incoming message due to signing key not found
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
      And the server has authentication flag true
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And I should receive a server ok response
      And I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
      Then I should receive a server ok response
      When the server has the following therapy settings to be sent to devices
         | json                                                                                                                                                                                                                                                                                                                        |
         | { "FG.SerialNo": "22161295306", "SettingsId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7", "Set.Mode": "CPAP", "CPAP.Set.Press": 14.0, "CPAP.Set.StartPress": 8.0, "CPAP.Set.EPR.EPREnable": "On", "CPAP.Set.EPR.EPRType": "FullTime", "CPAP.Set.EPR.Level": 2, "CPAP.Set.Ramp.RampEnable": "On", "CPAP.Set.Ramp.RampTime": 30 } |
      And I pause for 10 seconds
      And I request version 2 broker requests for paired cellular module with sufficient type 2 authentication
         | cellularModuleGuid                   |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
      Then I should receive a server Unauthorized response
      And I should receive the following HTTP Headers
         | Key              | Value                |
         | WWW-Authenticate | Encryption,Signature |
      And the attempt is sent to the newport authentication failure log
         | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                                        |
         | SIGNATURE               | MISSING_SIGNING_KEY       | Signing key for 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 was not found |

   @newport.authentication.S22
   @ECO-14746.4 @ECO-14746.4a @ECO-14746.4b @ECO-14746.4c @ECO-14746.4d
   Scenario: For the given Cellular Module, Machine Portal will reject incoming message due to signature calculation missmatch
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
      And the server has authentication flag true
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And I should receive a server ok response
      And I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
      Then I should receive a server ok response
      When the server has the following therapy settings to be sent to devices
         | json                                                                                                                                                                                                                                                                                                                        |
         | { "FG.SerialNo": "22161295306", "SettingsId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7", "Set.Mode": "CPAP", "CPAP.Set.Press": 14.0, "CPAP.Set.StartPress": 8.0, "CPAP.Set.EPR.EPREnable": "On", "CPAP.Set.EPR.EPRType": "FullTime", "CPAP.Set.EPR.Level": 2, "CPAP.Set.Ramp.RampEnable": "On", "CPAP.Set.Ramp.RampTime": 30 } |
      And the cellular module updates authentication context
      And I request version 2 broker requests for paired cellular module with incorrect type 2 authentication
         | cellularModuleGuid                   |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
      Then I should receive a server Unauthorized response
      And I should receive the following HTTP Headers
         | Key              | Value                |
         | WWW-Authenticate | Encryption,Signature |
      And the attempt is sent to the newport authentication failure log
         | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                           |
         | SIGNATURE               | SIGNATURE_MISMATCH        | Calculated signature does not match request signature |

   @newport.authentication.S23
   @ECO-14748.1
   @ECO-14747.1 @ECO-14747.1a @ECO-14747.1c
   Scenario: Any incoming message from a machine for which the encrypted content is decrypted is an authentication success and the client will get a 2xx series HTTP response code from the backing service.
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
      And the server has authentication flag true
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And I should receive a server ok response
      And I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
      Then I should receive a server ok response
      When the server is given the following climate settings to be sent to devices
         | json                                                                                                                                                                                                                                                                          |
         | { "FG.SerialNo": "22161295306",  "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
      Then I should receive a server ok response
      When the server is given the following upgrades to be sent to devices
         | json                                                                                                                                                                                                           |
         | { "FG.SerialNo": "22161295306", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
      Then I should receive a server ok response
      When the server has the following therapy settings to be sent to devices
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

   @newport.authentication.S24
   @ECO-14748.2 @ECO-14748.2a @ECO-14748.2b @ECO-14748.2c
   Scenario: Any incoming message from a machine with insufficient encryption details is an authentication failure.
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
      And the server has authentication flag true
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And I should receive a server ok response
      When I send newport version 3 registration data with paired cellular module type 2 sufficient signature and insufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
      Then I should receive a server Unauthorized response
      And I should receive the following HTTP Headers
         | Key              | Value                |
         | WWW-Authenticate | Encryption,Signature |
      And the attempt is sent to the newport authentication failure log
         | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                           |
         | SIGNATURE               | SIGNATURE_MISMATCH        | Calculated signature does not match request signature |

   @newport.authentication.S25
   @ECO-14748.2 @ECO-14748.2a @ECO-14748.2b @ECO-14748.2c
   Scenario: Any incoming message from a machine without encryption details is an authentication failure.
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
      And the server has authentication flag true
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And I should receive a server ok response
      When I send newport version 3 registration data with paired cellular module type 2 sufficient signature and no encryption
         | cellularModuleGuid                   | json                                                           |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
      Then I should receive a server Unauthorized response
      And I should receive the following HTTP Headers
         | Key              | Value                |
         | WWW-Authenticate | Encryption,Signature |
      And the attempt is sent to the newport authentication failure log
         | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                           |
         | SIGNATURE               | SIGNATURE_MISMATCH        | Calculated signature does not match request signature |

   @newport.authentication.S26
   @ECO-14748.2 @ECO-14748.2a @ECO-14748.2b @ECO-14748.2c
   Scenario: Any incoming message from a machine with invalid initialization vector is an authentication failure.
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
      And the server has authentication flag true
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      | initializationVector |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml | AAAAAAAAAOA==        |
      And I should receive a server ok response
      When I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
      Then I should receive a server Unauthorized response
      And I should receive the following HTTP Headers
         | Key              | Value                |
         | WWW-Authenticate | Encryption,Signature |
      And the attempt is sent to the newport authentication failure log
         | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                                              |
         | HEADER                  | INVALID_VALUE             | Decoded header value for initializationVector is not odd: bigInteger=224 |

   @newport.authentication.S27
   @ECO-14748.3 @ECO-14748.3a @ECO-14748.3b @ECO-14748.3c
   Scenario: Any incoming message from a machine for which the server side does not have the necessary cryptography detail for decryption is an authentication failure.
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
      And the server has authentication flag true
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And I should receive a server ok response
      And I pause for 7 seconds
      When I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
      Then I should receive a server Unauthorized response
      And I should receive the following HTTP Headers
         | Key              | Value                |
         | WWW-Authenticate | Encryption,Signature |
      And the attempt is sent to the newport authentication failure log
         | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                                                              |
         | ENCRYPTION              | MISSING_ENCRYPTION_KEY    | Encryption key for 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 has expired or was never issued. |

   @newport.authentication.S28
   @ECO-14748.4 @ECO-14748.4a @ECO-14748.4b @ECO-14748.4c
   Scenario: Any incoming message from a machine for which the encrypted content could not be correctly decrypted with all inputs is an authentication failure.
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
      And the server has authentication flag true
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And I should receive a server ok response
      And I send newport version 3 registration data with paired cellular module type 2 sufficient signature and incorrect encryption
         | cellularModuleGuid                   | json                                                           | signingInitializationVector |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json | MDAwMDAwMDAwMDAwNw==        |
      Then I should receive a server Unauthorized response
      And I should receive the following HTTP Headers
         | Key              | Value                |
         | WWW-Authenticate | Encryption,Signature |
      And the attempt is sent to the newport authentication failure log
         | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                                                                                                                                    |
         | HEADER                  | INVALID_VALUE             | Decoded header value for initializationVector is not correct length: base64EncodedInitializationVector=MDAwMDAwMDAwMDAwNw==, expectedLength=8, actualLength=13 |

   @newport.authentication.S29
   @ECO-14748.3 @ECO-14748.3a @ECO-14748.3b @ECO-14748.3c
   @ECO-17969.2
   Scenario: Attempt to re-use an initialization vector is an authentication failure.
      Given the server receives the following manufacturing unit detail
         | resource                                                                      |
         | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
      And the server should not produce device manufactured error
      And the server has authentication flag true
      And the cellular module requests security tokens and establishes authentication context
         | cellularModuleIdentifier             | manufacturingXmlFileName                                                      | initializationVector |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml | 9T8/lRyHvlE=         |
      And I should receive a server ok response
      And I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
         | cellularModuleGuid                   | json                                                           |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
      Then I should receive a server ok response
      When the server is given the following climate settings to be sent to devices
         | json                                                                                                                                                                                                                                                                          |
         | { "FG.SerialNo": "22161295306",  "SettingsId": "3588B987-3304-4D07-97A0-BEAC1A1D06D4", "Set.ClimateControl": "Auto", "Set.HumEnable": "Off", "Set.HumLevel": 6, "Set.TempEnable": "Off", "Set.Temp": 25, "Set.Tube": "19mm", "Set.Mask": "FullFace", "Set.SmartStart": "On" } |
      Then I should receive a server ok response
      When the server is given the following upgrades to be sent to devices
         | json                                                                                                                                                                                                           |
         | { "FG.SerialNo": "22161295306", "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E", "Type": "FG",  "Host": "127.0.0.1", "Port": "80", "FilePath": "/upgrade/fg-1203-2201.bin",  "Size": 9876, "CRC": "C7D2" } |
      Then I should receive a server ok response
      When the server has the following therapy settings to be sent to devices
         | json                                                                                                                                                                                                                                                                                                                        |
         | { "FG.SerialNo": "22161295306", "SettingsId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7", "Set.Mode": "CPAP", "CPAP.Set.Press": 14.0, "CPAP.Set.StartPress": 8.0, "CPAP.Set.EPR.EPREnable": "On", "CPAP.Set.EPR.EPRType": "FullTime", "CPAP.Set.EPR.Level": 2, "CPAP.Set.Ramp.RampEnable": "On", "CPAP.Set.Ramp.RampTime": 30 } |
      Then I should receive a server ok response
      When I request version 2 broker requests for paired cellular module with sufficient type 2 authentication
         | cellularModuleGuid                   |
         | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
      Then I should receive a server Unauthorized response
      And I should receive the following HTTP Headers
         | Key              | Value                        |
         | WWW-Authenticate | Encryption,Content,Signature |
      And the attempt is sent to the newport authentication failure log
         | AuthenticationVetoPoint | AuthenticationFailureType | AuthenticationFailureReason                                                                         |
         | HEADER                  | INVALID_VALUE             | Decoded header value for initializationVector is not expected value: bigInteger=-774830701223100847 |

  @newport.authentication.S30
  @ECO-17969.1
   Scenario: For the given Cellular Module, Machine Portal shall be able to validate incoming signature using 128 byte Security Data
    Given the server receives the following manufacturing unit detail
      | resource                                                                                |
      | /data/manufacturing/unit_detail_fg20000000005_cam20000000006_new_with_security_data.xml |
    Then the server should not produce device manufactured error
    And the server has authentication flag true
    And the cellular module requests security tokens and establishes authentication context
      | cellularModuleIdentifier             | manufacturingXmlFileName                                                                |
      | cf8a202b-5e79-11e6-8b77-86f30ca89555 | /data/manufacturing/unit_detail_fg20000000005_cam20000000006_new_with_security_data.xml |
    And I should receive a server ok response
    When I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
      | cellularModuleGuid                   | json                                                           |
      | cf8a202b-5e79-11e6-8b77-86f30ca89555 | /data/unit/newport/registration/flowgenerator/20000000006.json |
    Then I should receive a server ok response
    And the response is signed by Authorization header based on its content with the following details
      | cellularModuleGuid                   |
      | cf8a202b-5e79-11e6-8b77-86f30ca89555 |
    When the cellular module updates authentication context
    And I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
      | cellularModuleGuid                   | json                                                           |
      | cf8a202b-5e79-11e6-8b77-86f30ca89555 | /data/unit/newport/registration/flowgenerator/20000000006.json |
    Then I should receive a server ok response