@newport
@newport.scrap
@ECO-7300
@ECO-7299

Feature:

  (ECO-7300) As ECO
  I want to inform Vodafone about a scrapped device
  so that I do not get a bill.

  (ECO-7299) As ECO
  I want to inform Aeris about a scrapped device
  so that I do not get a bill.

  # ACCEPTANCE CRITERIA: (ECO-7300)
  # Note 1: This story extends ECO-6090 and ECO-6637
  # 1. When a 3G CAM is scrapped in ECO (either through the Manufacturing Interface per ECO-6090 AC4b or during a field service per ECO-6637 AC2), the device shall be scrapped with Vodafone. Note: The intent is to ensure that no further telecommunications bills can occur.

  # ACCEPTANCE CRITERIA: (ECO-7299)
  # Note 1: This story extends ECO-6090 and ECO-6637
  # 1. When a CDMA CAM is scrapped in ECO (either through the Manufacturing Interface per ECO-6090 AC4b or during a field service per ECO-6637 AC2), the CAM shall be scrapped with Aeris. Note: The intent is to ensure that no further telecommunications bills can occur.

  Background:
    Given the server receives the following manufacturing unit detail
      | resource                                                             |
      | /data/manufacture/unit/detail/build_new/newport/flowgenerator/unit_detail_fg11111114444_cam11111114444_new.xml |
    And the server should not produce device manufactured error
    And the following units are cached for local use
      | flowGeneratorSerialNumber | communicationModuleSerialNumber |
      | 11111114444               | 11111114444                     |
    And I am a device with the FlowGen serial number "11111114444"

  @manual
  @newport.scrap.S1
  @ECO-7300.1
  Scenario: Scrap a vodafone device from Manufacturing Interface
    Given the Vodafone Telco feature has been started by running "features:install ngcs-telco-voadfone" in the Karaf console
    When NGCS is required to scrap the CAM through the telco vodafone
      | curl -v http://us1-ecocam-d51.ec2.local:8198/v1/telco/management/scrap/module/<cam_serial_no> |
    Then the device should be active.suspend in Vodafone
      | https://m2mprdgui.vodafone.com/GDSPGui/ |

  @manual
  @newport.scrap.S2
  @ECO-7299.1
  Scenario: Scrap a aeris device from Manufacturing Interface
    Given the Aeris Telco feature has been started by running "features:install ngcs-telco-aeris" in the Karaf console
    When NGCS is required to scrap the CAM through the telco aeris
      | curl -v http://us1-ecocam-d51.ec2.local:8198/v1/telco/management/scrap/module/<cam_serial_no> |
    Then the device should be canceled in Aeris
      | https://aerport.aeris.net/web/guest/home |

  @newport.scrap.S3
  @ECO-7299.1 @ECO-7300.1
  Scenario: Scrap a mock device from Manufacturing Interface
    Given the server bulk load the following devices and modules
      | /data/manufacturing/batch_new_fg6000_cam6000.xml |
    Then manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    When the server bulk load the following devices and modules
      | /data/manufacturing/batch_scrap_fg6000_cam6000.xml |
    Then manufacture verify the status of the job
      | status           |
      | COMPLETE-SUCCESS |
    And the telco administrator should have processed following comm modules to be scrapped
      | commModuleSerialNo |
      | 60000000001        |


