@newport
@newport.management_api
@ECO-5169

Feature:

  (ECO-5169) Fix resmed.hi.ngcs.newport.management.api.RegistrarManager to return an object serializable to JSON instead of a string that is the uuid.

  # ACCEPTANCE CRITERIA: (ECO-5169)
  # 1. Climate Setting registration returns JSON
  # 2. Subscription registration returns JSON
  # 3. Therapy Setting registration returns JSON
  # 4. Upgrade registration returns JSON

   Background:

   @manual
   @ECO-5169.1
   @newport.management_api.S1
   Scenario: Climate Setting return json objects instead of UID strings
      Given the following devices exist
         | moduleSerial   | authKey      | flowGenSerial | deviceNumber | mid | vid | internalCommModule |
         | 20102141732    | 201913483157 | 20070811223   | 123          | 36  | 26  | true               |
      When the server receives the following management API request
        """
          {
            "FG.SerialNo": "20070811223",
            "SubscriptionId": "23232-32323-23232-32323-23232",
            "ServicePoint":"/api/v1/climate/settings",
            "Date": "20130429",
            "CollectTime": "20130430 140302",
            "Set.ClimateControl": "Auto",
            "Set.HumEnable": "On",
            "Set.HumLevel": 5,
            "Set.TempEnable": "Off",
            "Set.Temp": 28,
            "Set.Tube": "15mm",
            "Set.Mask": "Pillows",
            "Set.SmartStart": "Off"
          }
        """
      Then the server returns the following api response
        """
          {
            "FG.SerialNo":"20070811223",
            "SubscriptionId":"23232-32323-23232-32323-23232"
          }
        """

   @manual
   @ECO-5169.2
   @newport.management_api.S2
   Scenario: Subscription return json objects instead of UID strings
      Given the following devices exist
         | moduleSerial   | authKey      | flowGenSerial | deviceNumber | mid | vid | internalCommModule |
         | 20102141732    | 201913483157 | 20070811223   | 123          | 36  | 26  | true               |
      When the server receives the following management API request
        """
          {
             "FG.SerialNo": "20070811223",
             "SubscriptionId": "23232-32323-23232-32323-23232",
             "ServicePoint":"/api/v1/climate/settings",
             "Trigger":{ "Collect":[ "HALO",
             "Now" ],
             "OnlyOnChange":true },
             "Data":[ "Val.ClimateControl",
             "Val.HumEnable",
             "Val.HumLevel",
             "Val.TempEnable",
             "Val.Temp",
             "Val.Tube",
             "Val.Mask",
             "Val.SmartStart" ]
           }
        """
      Then the server returns the following api response
        """
          {
            "FG.SerialNo":"20070811223",
            "SubscriptionId":"23232-32323-23232-32323-23232"
          }
        """

   @manual
   @ECO-5169.3
   @newport.management_api.S3
   Scenario: Therapy Setting return json objects instead of UID strings
      Given the following devices exist
         | moduleSerial   | authKey      | flowGenSerial | deviceNumber | mid | vid | internalCommModule |
         | 20102141732    | 201913483157 | 20070811223   | 123          | 36  | 26  | true               |
      When the server receives the following management API request
        """
          {
            "FG.SerialNo":"20070811223",
            "SettingsId":"23232-32323-23232-32323-23232",
            "Set.Mode":"CPAP",
            "CPAP.Set.Press":14.0,
            "CPAP.Set.StartPress":8.0,
            "CPAP.Set.EPR.EPREnable":"On",
            "CPAP.Set.EPR.EPRType":"FullTime",
            "CPAP.Set.EPR.Level":2,
            "CPAP.Set.Ramp.RampEnable":"On",
            "CPAP.Set.Ramp.RampTime":30
          }
        """
      Then the server returns the following api response
        """
          {
            "FG.SerialNo":"20070811223",
            "SubscriptionId":"23232-32323-23232-32323-23232"
          }
        """

   @manual
   @ECO-5169.4
   @newport.management_api.S4
   Scenario: Upgrade return json objects instead of UID strings
      Given the following devices exist
         | moduleSerial   | authKey      | flowGenSerial | deviceNumber | mid | vid | internalCommModule |
         | 20102141732    | 201913483157 | 20070811223   | 123          | 36  | 26  | true               |
      When the server receives the following management API request
        """
          {  "FG.SerialNo": "20102141732",
            "UpgradeId": "B2AE8F06-1541-4616-AE6F-F9E4C079CC6E",
            "Type": "FG",
            "Host": "127.0.0.1",
            "Port": "80",
            "FilePath": "/upgrade/fg-1203-2201.bin",
            "Size": 9876,
            "CRC": "C7D2"
          }
        """
      Then the server returns the following api response
        """
          {
            "FG.SerialNo":"20070811223",
            "SubscriptionId":"B2AE8F06-1541-4616-AE6F-F9E4C079CC6E"
            }
        """
