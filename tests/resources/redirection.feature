@newport
@newport.redirection
@ECO-16337

Feature:

  (ECO-16337) As a fleet manager
  I want automated redirection of machines so that machines are re-organized as necessary

  (ECO-15339) As a fleet manager
  I want automated redirection of machines so that machines are re-organized as necessary.


# ACCEPTANCE CRITERIA: (ECO-16337)
# Note 1: Cellular module redirect specification can be found at https://confluence.ec2.local/display/NGCS/15+00+Redirect
# Note 2: Cellular module redirect activity specification can be found at https://confluence.ec2.local/display/NGCS/15+03+Redirect
# Note 3: Cellular module redirect descriptor management is implemented by ECO-16218
#
# 1. When an authenticated Registration, Request Broker, or Machine Data post is received, Machine Portal shall redirect the cellular module if a cellular module redirect descriptor is found
# 1a. The client shall receive a 308 Permanent Redirect HTTP response code
# 1b. The client shall receive a Location HTTP response header with the new URI
# 1c. The client shall receive a JSON representation of the new location i.e. the URL and APN.

#  ACCEPTANCE CRITERIA: (ECO-15339)
#  Note 1: Cellular module redirect specification can be found at https://confluence.ec2.local/display/NGCS/15+00+Redirect
#  Note 2: Cellular module redirect activity specification can be found at https://confluence.ec2.local/display/NGCS/15+03+Redirect
#  Note 3: Cellular module redirect descriptor management is implemented by -ECO-16218-
#  Note 4: Redirection of a cellular module is implemented by ECO-16337
#  1. When a cellular module is redirected the first time, Machine Portal shall record the redirect details for the cellular module
#  1a. The server shall store a redirect count of '1'
#  1b. The server shall store the current date/time as the first redirect
#  1c. The server shall store the current date/time as the last redirect
#  2. When a cellular module is redirected subsequent times and the maximum number of redirect attempts has not been exceeded reached, Machine Portal shall record the redirect details for the cellular module
#  2a. The server shall increment and store the redirect count
#  2b. The server shall store the current date/time as the last redirect
#  3. When an authenticated Registration, Request Broker, or Machine Data post is received for a cellular module that has a redirect descriptor, Machine Portal shall not redirect if the cellular module has met the maximum number of redirect attempts
#  Note 5: The maximum number of cellular module redirect attempts will be configurable, defaulted to 3
#  3a. On the redirect attempt that meets the maximum, the server shall store the current date/time as the stop redirect
#  3b. The server shall accept the request

   @newport.redirection.S1
   @ECO-16337.1 @ECO-16337.1a @ECO-16337.1b @ECO-16337.1c
   Scenario: Redirect from a Registration v3 for an unpaired external CAM and Redirect from a machine data post
     Given the server receives the following manufacturing unit detail
       | resource                                                                               |
       | /data/manufacture/unit/detail/build_new/geneva/cellularmodule/external/20170315895.xml |
     And the server does not produce device manufactured error
     When Fleet manager sends the following redirect descriptors to be persisted
       | cellularModuleGuid                   | jsonFile                                                                   | responseCode |
       | 131fac75-6bc8-3685-a140-a0491059d99c | /data/management/redirect/cellularmodule/redirect_descriptor_create_2.json | 201          |
     And the following units are cached for local use
       | communicationModuleSerialNumber |
       | 20170315895                     |
     And the unit is composed of cellular module "20170315895"
     And the cellular module requests security tokens and establishes authentication context
       | cellularModuleIdentifier             | manufacturingXmlFileName                                                               |
       | 131fac75-6bc8-3685-a140-a0491059d99c | /data/manufacture/unit/detail/build_new/geneva/cellularmodule/external/20170315895.xml |
     And I send newport version 3 registration data with none paired cellular module type 2 sufficient signature and sufficient encryption
       | cellularModuleGuid                   | json                                                           |
       | 131fac75-6bc8-3685-a140-a0491059d99c | /data/unit/geneva/registration/cellularmodule/20170315895.json |
     Then I should receive a server Permanent Redirect response
     And the response is signed by Authorization header based on its content with the following details
       | cellularModuleGuid                   |
       | 131fac75-6bc8-3685-a140-a0491059d99c |
     And I should receive the following message in the response body
       | jsonFile                                                          |
       | /data/management/redirect/cellularmodule/redirect_response_2.json |
     And I should receive the following HTTP Headers
       | Key              | Value                                                                                                                       |
       | Content-Type     | application/json;charset=UTF-8                                                                                              |
       | Location         | http://newport-amr.resmed.com/api/v3/registrations/flowgenerators/none/cellularmodules/131fac75-6bc8-3685-a140-a0491059d99c |
     When the cellular module updates authentication context
     And the machine sends the following therapy details with type 2 authentication
       | json                                                                                                                                                                                                                                                                                                                                                                           |
       | { "FG.SerialNo": "20170315895", "SubscriptionId": "018A5655-81C6-4888-A2AD-6480087BE3B7", "Date": "3 days ago", "CollectTime": "2 days ago 090100", "Val.Leak.1m": [ { "StartTime": 540, "Values": [ -5, -4, -3 ] } ], "Val.TgtIPAP.1m": [ { "StartTime": 540, "Values": [ 9, 8, 7 ] } ], "Val.RespiratoryEvent": [ [ 33573, 12, "Apnea" ], [ 38007, 22, "Central apnea" ] ] } |
     Then I should receive a server Permanent Redirect response

  @newport.redirection.S2
  @ECO-16337.1 @ECO-16337.1a @ECO-16337.1b @ECO-16337.1c
  Scenario: Redirect from a Registration v3 for an internal CAM and Redirect from a machine data post
    Given the server receives the following manufacturing unit detail
      | resource                                                                      |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
    And the server does not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 22161295306               | 22161295306                     |
    And I am a device with the FlowGen serial number "22161295306"
    When Fleet manager sends the following redirect descriptors to be persisted
      | cellularModuleGuid                   | jsonFile                                                                   | responseCode |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/management/redirect/cellularmodule/redirect_descriptor_create_3.json | 201          |
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 22161295306               | 22161295306                     |
    And the unit is composed of flow generator "22161295306"
    And the cellular module requests security tokens and establishes authentication context
      | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
    And I do receive a server ok response
    And I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
      | cellularModuleGuid                   | json                                                           |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
    Then I should receive a server Permanent Redirect response
    And the response is signed by Authorization header based on its content with the following details
      | cellularModuleGuid                   |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    And I should receive the following message in the response body
      | jsonFile                                                          |
      | /data/management/redirect/cellularmodule/redirect_response_3.json |
    And I should receive the following HTTP Headers
      | Key              | Value                                                                                                                         |
      | Content-Type     | application/json;charset=UTF-8                                                                                                |
      | Location         | http://newport-amr.resmed.com/api/v3/registrations/flowgenerators/paired/cellularmodules/4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    When the cellular module updates authentication context
    And the machine sends the following device erasures with type 2 authentication
      | json                                                                                                                                                                              |
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "51960EDB-EA97-4A50-A32C-EACF6239EBE3", "Date": "1 day ago", "CollectTime": "today 120000", "Val.LastEraseDate": "2 days ago" } |
    Then I should receive a server Permanent Redirect response
    And I should receive the following message in the response body
      | jsonFile                                                          |
      | /data/management/redirect/cellularmodule/redirect_response_3.json |
    And I should receive the following HTTP Headers
      | Key              | Value                                         |
      | Content-Type     | application/json;charset=UTF-8                |
      | Location         | http://newport-amr.resmed.com/api/v1/erasures |
    When the cellular module updates authentication context
    And the machine sends the following system event with type 2 authentication
      | json                                                                                                                                                                                                                                                      |
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "11111111-7234-47D1-9860-6BEB866AD8C2","Date": "2 days ago","CollectTime": "2 days ago 010203","Val.UtcOffset": -120,"Val.SystemEvent": [{"EndDateTime": "2015-11-28T12:43:09","SystemCode": "E-001"}]} |
    Then I should receive a server Permanent Redirect response
    And I should receive the following message in the response body
      | jsonFile                                                          |
      | /data/management/redirect/cellularmodule/redirect_response_3.json |
    And I should receive the following HTTP Headers
      | Key              | Value                                                          |
      | Content-Type     | application/json;charset=UTF-8                                 |
      | Location         | http://newport-amr.resmed.com/api/v1/events/streams/activities |

  @newport.redirection.S3
  @ECO-16337.1 @ECO-16337.1a @ECO-16337.1b @ECO-16337.1c
  Scenario: Redirect from a Request Broker GET for an internal CAM and Redirect from a machine data post
    Given the server receives the following manufacturing unit detail
      | resource                                                                      |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
    And the server does not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 22161295306               | 22161295306                     |
    And I am a device with the FlowGen serial number "22161295306"
    And the cellular module requests security tokens and establishes authentication context
      | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
    And I do receive a server ok response
    When I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
      | cellularModuleGuid                   | json                                                           |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
    And I do receive a server ok response
    And the server is given the following therapy settings to be sent to devices
      | json                                                                                                                                                                                                                                                                                                                        |
      | { "FG.SerialNo": "22161295306", "SettingsId": "DCB1CC12-F9A0-4DF1-88D6-3FFAF1FA20D7", "Set.Mode": "CPAP", "CPAP.Set.Press": 14.0, "CPAP.Set.StartPress": 8.0, "CPAP.Set.EPR.EPREnable": "On", "CPAP.Set.EPR.EPRType": "FullTime", "CPAP.Set.EPR.Level": 2, "CPAP.Set.Ramp.RampEnable": "On", "CPAP.Set.Ramp.RampTime": 30 } |
    And I do receive a server ok response
    And Fleet manager sends the following redirect descriptors to be persisted
      | cellularModuleGuid                   | jsonFile                                                                   | responseCode |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/management/redirect/cellularmodule/redirect_descriptor_create_3.json | 201          |
    And the cellular module updates authentication context
    And I request version 2 broker requests for paired cellular module with sufficient type 2 authentication
      | cellularModuleGuid                   |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    Then I should receive a server Permanent Redirect response
    And the response is signed by Authorization header based on its content with the following details
      | cellularModuleGuid                   |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    And I should receive the following message in the response body
      | jsonFile                                                          |
      | /data/management/redirect/cellularmodule/redirect_response_3.json |
    And I should receive the following HTTP Headers
      | Key              | Value                                                                                                                    |
      | Content-Type     | application/json;charset=UTF-8                                                                                           |
      | Location         | http://newport-amr.resmed.com/api/v2/requests/flowgenerators/paired/cellularmodules/4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    When the cellular module updates authentication context
    And the machine sends the following alarm settings with type 2 authentication
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "FDC84510-D85D-4E18-9994-DFCB78D5D794", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "Low" } |
    Then I should receive a server Permanent Redirect response
    And the response is signed by Authorization header based on its content with the following details
      | cellularModuleGuid                   |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    And I should receive the following message in the response body
      | jsonFile                                                          |
      | /data/management/redirect/cellularmodule/redirect_response_3.json |
    And I should receive the following HTTP Headers
      | Key              | Value                                                 |
      | Content-Type     | application/json;charset=UTF-8                        |
      | Location         | http://newport-amr.resmed.com/api/v1/alarm/settings   |
    When the cellular module updates authentication context
    And the machine sends the following device alarms with type 2 authentication
      | json                                                                                                                                                                                                                                                                                                                                                                         |
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "FDC84510-D85D-4E18-9995-FDBC78D5D796", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.AlarmEvent": [ { "EndDateTime": "3 days agoT22:31:34", "Action": "Activate", "AlarmType": "ApneaAlarm", "AlarmCode": "30", "AlarmPriority": "Medium", "Threshold": { "ThresholdType": "ApneaAlarmThreshold" } } ] } |
    Then I should receive a server Permanent Redirect response
    And the response is signed by Authorization header based on its content with the following details
      | cellularModuleGuid                   |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    And I should receive the following message in the response body
      | jsonFile                                                          |
      | /data/management/redirect/cellularmodule/redirect_response_3.json |
    And I should receive the following HTTP Headers
      | Key              | Value                                       |
      | Content-Type     | application/json;charset=UTF-8              |
      | Location         | http://newport-amr.resmed.com/api/v1/alarms |


  @newport.redirection.S4
  @ECO-16337.1 @ECO-16337.1a @ECO-16337.1b @ECO-16337.1c
  Scenario: Redirect from a machine data post
    Given the server receives the following manufacturing unit detail
      | resource                                                                      |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
    And the server does not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 22161295306               | 22161295306                     |
    And I am a device with the FlowGen serial number "22161295306"
    And the cellular module requests security tokens and establishes authentication context
      | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
    And I do receive a server ok response
    When I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
      | cellularModuleGuid                   | json                                                           |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
    And I do receive a server ok response
    And Fleet manager sends the following redirect descriptors to be persisted
      | cellularModuleGuid                   | jsonFile                                                                   | responseCode |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/management/redirect/cellularmodule/redirect_descriptor_create_3.json | 201          |
    And the cellular module updates authentication context
    And the machine sends the following settings event with type 2 authentication
      | json                                                                                                                                                                                                                                                                                                                 |
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "88888888-7234-47D1-9860-6BEB866AD8C2","CollectTime": "today 010101","Date": "1  day ago","Val.UtcOffset": -120,"Val.SettingChange": [{"EndDateTime":"2015-07-10T12:02:03","SettingType": "Val.ResRate","Change": {"Value": 99,"Previous": 40,"Units": "1/Min"}}]} |
    Then I should receive a server Permanent Redirect response
    And the response is signed by Authorization header based on its content with the following details
      | cellularModuleGuid                   |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    And I should receive the following message in the response body
      | jsonFile                                                          |
      | /data/management/redirect/cellularmodule/redirect_response_3.json |
    And I should receive the following HTTP Headers
      | Key              | Value                                                          |
      | Content-Type     | application/json;charset=UTF-8                                 |
      | Location         | http://newport-amr.resmed.com/api/v1/events/streams/settings   |
    When the cellular module updates authentication context
    And the machine sends the following device faults with type 2 authentication
      | json                                                                                                                                                                                                                          |
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "40326F7E-FE53-4D4B-8D7A-51DCC68F1177", "Date": "1 day ago", "CollectTime": "today 140302", "Fault.Device": [ ], "Fault.Humidifier": [ 3, 4 ], "Fault.HeatedTube": [ 10 ] } |
    Then I should receive a server Permanent Redirect response
    And the response is signed by Authorization header based on its content with the following details
      | cellularModuleGuid                   |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    And I should receive the following message in the response body
      | jsonFile                                                          |
      | /data/management/redirect/cellularmodule/redirect_response_3.json |
    And I should receive the following HTTP Headers
      | Key              | Value                                       |
      | Content-Type     | application/json;charset=UTF-8              |
      | Location         | http://newport-amr.resmed.com/api/v1/faults |
    When the cellular module updates authentication context
    And the machine sends the following device logs with type 2 authentication
      | json                                                                                                                                                                  |
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "341D4CDF-3A1B-4369-93C0-BF07573A6F5E", "Date": "1 day ago", "CollectTime": "today 140302", "Log.Type": "Log.CAM" } |
    Then I should receive a server Permanent Redirect response
    And the response is signed by Authorization header based on its content with the following details
      | cellularModuleGuid                   |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    And I should receive the following message in the response body
      | jsonFile                                                          |
      | /data/management/redirect/cellularmodule/redirect_response_3.json |
    And I should receive the following HTTP Headers
      | Key              | Value                                     |
      | Content-Type     | application/json;charset=UTF-8            |
      | Location         | http://newport-amr.resmed.com/api/v1/logs |

  @newport.redirection.S5
  @ECO-15339.1a @ECO-15339.2a @ECO-15339.3
  Scenario: Redirection counter and timestamps track
    Given the server receives the following manufacturing unit detail
      | resource                                                                      |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
    And the server does not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 22161295306               | 22161295306                     |
    And I am a device with the FlowGen serial number "22161295306"
    And the cellular module requests security tokens and establishes authentication context
      | cellularModuleIdentifier             | manufacturingXmlFileName                                                      |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/manufacture/unit/detail/build_new/newport/flowgenerator/22161295306.xml |
    And I do receive a server ok response
    When I send newport version 3 registration data with paired cellular module type 2 sufficient signature and sufficient encryption
      | cellularModuleGuid                   | json                                                           |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/unit/newport/registration/flowgenerator/22161295306.json |
    And I do receive a server ok response
    And Fleet manager sends the following redirect descriptors to be persisted
      | cellularModuleGuid                   | jsonFile                                                                   | responseCode |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 | /data/management/redirect/cellularmodule/redirect_descriptor_create_3.json | 201          |
    And the cellular module updates authentication context
    And the machine sends the following therapy settings with type 2 authentication
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "21C219CD-EB66-43E7-B677-50E858BB851B", "Date": "1  day ago", "CollectTime": "today 010101", "Val.Mode": "AutoSet", "AutoSet.Val.MinPress": 8.2, "AutoSet.Val.MaxPress": 14.2, "AutoSet.Val.StartPress": 10.2, "AutoSet.Val.EPR.EPREnable": "On", "AutoSet.Val.EPR.EPRType": "Ramp",  "AutoSet.Val.EPR.Level": 2, "AutoSet.Val.Ramp.RampEnable": "Auto", "AutoSet.Val.Ramp.RampTime":30, "AutoSet.Val.Comfort":"Off" } |
    Then I should receive a server Permanent Redirect response
    And the response is signed by Authorization header based on its content with the following details
      | cellularModuleGuid                   |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    And the server should see the following redirect attributes for a Cellular Module identifier "4b9c0f45-11e9-3e0b-9fa1-c943b4d53398"
      | redirectCount | firstTimeRedirectDateTime | lastTimeRedirectDateTime | stopTimeRedirectDateTime |
      | 1             | <INITIALIZED>             | <INITIALIZED>            |                          |
    # Wait a little to make sure when lastTimeRedirectDateTime is <UPDATED>. It is later than firstTimeRedirectDateTime
    And I pause for 1 seconds
    When the cellular module updates authentication context
    And the machine sends the following therapy summaries with type 2 authentication
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "BD85B5B8-DF04-4A67-B85B-AD1CD772082E", "Date": "1 days ago", "CollectTime": "1 days ago 140302", "Val.Mode": "CPAP", "Val.Duration": 600, "Val.MaskOn": [ 120, 340, 450 ], "Val.MaskOff": [ 300, 400, 1200 ], "Val.AHI": 5.5, "Val.AI": 5.5, "Val.HI": 5.5, "Val.OAI": 5.5, "Val.CAI": 5.5, "Val.UAI": 5.5, "Val.Leak.50": 4.3, "Val.Leak.70" : 0.1, "Val.Leak.95": 0.3, "Val.Leak.Max": 0.123, "Val.CSR": 990, "Val.RIN": 5.5, "Val.Humidifier": "Internal", "Val.HeatedTube": "None", "Val.AmbHumidity": 25, "Val.HTubePow.50" : 5, "Val.HumPow.50" : 19 } |
    Then I should receive a server Permanent Redirect response
    And the response is signed by Authorization header based on its content with the following details
      | cellularModuleGuid                   |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    And the server should see the following redirect attributes for a Cellular Module identifier "4b9c0f45-11e9-3e0b-9fa1-c943b4d53398"
      | redirectCount | firstTimeRedirectDateTime | lastTimeRedirectDateTime | stopTimeRedirectDateTime |
      | 2             |                           | <UPDATED>                |                          |
    And I pause for 1 seconds
    When the cellular module updates authentication context
    And the machine sends the following climate settings with type 2 authentication
      | json                                                                                                                                                                                                                                                                                                                                  |
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "301E6C6C-A3C3-44B9-99D4-171A99FE6BD5", "Date": "1 day ago",  "CollectTime": "today 094703", "Val.ClimateControl": "Auto", "Val.HumEnable": "Off", "Val.HumLevel": 6, "Val.TempEnable": "Off", "Val.Temp": 25, "Val.Tube": "19mm", "Val.Mask": "FullFace", "Val.SmartStart": "On" } |
    Then I should receive a server Permanent Redirect response
    And the response is signed by Authorization header based on its content with the following details
      | cellularModuleGuid                   |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    And the server should see the following redirect attributes for a Cellular Module identifier "4b9c0f45-11e9-3e0b-9fa1-c943b4d53398"
      | redirectCount | firstTimeRedirectDateTime | lastTimeRedirectDateTime | stopTimeRedirectDateTime |
      | 3             |                           |  <UPDATED>               | <INITIALIZED>            |
    # Wait a little to make sure when lastTimeRedirectDateTime is <UPDATED>. It is later than firstTimeRedirectDateTime
    And I pause for 1 seconds
    When the cellular module updates authentication context
    And the machine sends the following alarm settings with type 2 authentication
      | json                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | { "FG.SerialNo": "22161295306", "SubscriptionId": "FDC84510-D85D-4E18-9994-DFCB78D5D794", "Date": "3 days ago", "CollectTime": "2 days ago 140302", "Val.LowMinuteVentAlarmEnable": "On", "Val.LowMinuteVentAlarmThreshold": 150.0, "Val.ApneaAlarmEnable": "On", "Val.ApneaAlarmThreshold": 3, "Val.SpO2AlarmEnable": "On", "Val.SpO2Threshold": 85, "Val.NonVentedMaskAlarmEnable": "On", "Val.HighLeakAlarmEnable": "On", "Val.AlarmVolume": "Low" } |
    Then I should receive a server ok response
    And the response is signed by Authorization header based on its content with the following details
      | cellularModuleGuid                   |
      | 4b9c0f45-11e9-3e0b-9fa1-c943b4d53398 |
    And the server should see the following redirect attributes for a Cellular Module identifier "4b9c0f45-11e9-3e0b-9fa1-c943b4d53398"
      | redirectCount | firstTimeRedirectDateTime | lastTimeRedirectDateTime | stopTimeRedirectDateTime |
      | 3             |                           |                          |                          |
