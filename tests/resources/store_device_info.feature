@newport
@newport.registration
@ECO-4959
@ECO-5581

Feature:
  (ECO-4959) As an application support user
   I want to have information on each device in the system
   so that I can determine the appropriate devices to upgrade

  (ECO-5581) As ECO
  I want to be able to receive CAM subscriptions on registration
  so that registration operations do not fail

  # ACCEPTANCE CRITERIA: (ECO-4959)
  # 1. ECO shall maintain the following data for each device:
  # 1a. Device serial number,
  # 1b. Device application software version,
  # 1c. Device MID,
  # 1d. Device VID,
  # 1e. Device PCB serial number,
  # 1f. Device Product Code,
  # 1g. Device Configuration software version,
  # 1h. CAM serial number,
  # 1i. CAM application software version
  # 1j. CAM PCB serial number,
  # 1k. Humidifier application software version
  # 2. ECO shall update the data in AC#1 based upon the device registration process (http://confluence.corp.resmed.org/display/CA/Registration)
  # Note 1: The device will initially be populated via the manufacturing interface but this is not part of this story.

  # ACCEPTANCE CRITERIA: (ECO-5581)
  # 1. CAM subscription information during Registration should be able to be received as per http://confluence.corp.resmed.org/x/YwGz
  #
  # Note 1: It is not necessary at this stage to do anything with the CAM subscription information. The important thing is to prevent all registrations failing.

   Background:
      Given devices with following properties have been manufactured
         | moduleSerial   | authKey      | flowGenSerial | deviceNumber | mid | vid | productCode | pcbaSerialNo | internalCommModule  |
         | 20102141732    | 201913483157 | 20070811223   | 123          | 36  | 26  | 9745        | 1A345678     | true                |
      And the server waits for the device manufactured queue to be empty
      And the server should not produce device manufactured error
      And I am a device with the FlowGen serial number "20070811223"

   @store.device.info.S1
   @ECO-4959.1 @ECO-4959.1a @ECO-4959.1b @ECO-4959.1c @ECO-4959.1d @ECO-4959.1e @ECO-4959.1f @ECO-4959.1g @ECO-4959.1h @ECO-4959.1i @ECO-4959.1j @ECO-4959.1k
   @ECO-5581.1
   Scenario: Store Newport device data
      When I send the following registration
         | json                                                                                                                                                                                                                                                                                                                              |
         | { "FG": {"SerialNo": "20070811223", "Software": "FGABCDEFH", "MID": 36, "VID": 26, "PCBASerialNo":"1A345678", "ProductCode":"9745", "Configuration": "CX-ABC-123-DEF-456" }, "CAM": {"SerialNo": "20102141732", "Software": "CAMABCDEFH", "PCBASerialNo":"1A345678", "Subscriptions": [  ] }, "Hum": {"Software": "HUMABCDEFH"} } |
      Then NGCS stores the following registration information
         | flowGenSerial | appVersion | mid | vid | fgpcb    | prodCode | confVersion        | moduleSerial | camVersion | campcb   | humVersion |
         | 20070811223   | FGABCDEFH  | 36  | 26  | 1A345678 | 9745     | CX-ABC-123-DEF-456 | 20102141732  | CAMABCDEFH | 1A345678 | HUMABCDEFH |
