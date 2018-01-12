@newport
@ECO-5360
@ECO-5359
@ECO-10207

Feature:

  (ECO-5360) As a user 
  I want an SMS sent to S10 devices on the Vodafone network when a request is queued for the device at the request broker
  So the device receives the SMS

  (ECO-5359) As a user 
  I want an SMS sent to S10 devices on the Aeris network when a request is queued for the device at the request broker 
  so the device receives the SMS.

  (ECO-10207) As an Applications Support user
  I want to be able to upgrade a list of external CAMs
  so that upgrades can be made in the field if necessary


# ACCEPTANCE CRITERIA: (ECO-5360)
# 1. When a request is queued for an S10 device and the device is on the Vodafone network then an SMS should be sent using the Vodafone API. This is necessary since it is a private network.
# Note 1: This story extends ECO-4776 AC#4 by specifying the SMS interface for Vodafone.
# Note 2: Further data populated from manufacturing interface may be necessary in order to send an SMS such as the IMSI number. This data is identified in D379-513.
# Note 3: See attached for Vodafone API specifications 

# ACCEPTANCE CRITERIA: (ECO-5359)
# Note 1: This story extends ECO-4776 AC#4 by specifying the SMS interface for Aeris.
# 1. When a request is queued for an S10 device and the device is on the Aeris network then an SMS shall be sent using the Aeris API. This is necessary since it is a private network.
# Note 2: Further data populated from manufacturing interface may be necessary in order to send an SMS such as the MIN. This data is identified in D379-513.
# Note 3: Should work whether or not the device is CDMA or GSM.
# Note 4: Information on the Aeris API may be found here http://confluence.corp.resmed.org/x/ywK_/

# DECRIPTION: (ECO-5837)
# 1. If the S10 device being added has not registered within n days, a new SMS shall be sent.
# 1a. On the Vodafone network, the number of days n shall be 7 days. Note 2: the new SMS should be a replacement to the previously sent SMS, rather than a new one.
# 1b. On the Aeris network, the number of days n shall be 3 days.

# ACCEPTANCE CRITERIA: (ECO-10207)
#  Note 1: This card will open up a test case for ECO-9855, where was not able to seed a brokered message, specific for CAM, following a production work flow.
#
#  1. An Applications Support user shall be able to specify a list of external CAMs to upgrade.
#  2. The list of devices to upgrade shall be able to be specified using a csv file. *Note:* It is acceptable for the csv file to be consumed by the same end point as created for ECO-4964, and NGCS can differentiate by the information provided. Ie - if device type is an external CAM or bridge, then expect to receive External CAM serial number. Otherwise, then flowGenSerialNo is required.
#  3. For each device to be upgraded the following shall be specifiable:
#  3a. External CAM serial number;
#  3b. Whether to upgrade the CAM or the Bridge;
#  3c. The file to be used to upgrade the device including the host, port and file path; and
#  3d. The size and CRC of the upgrade file.
#  4. It shall be possible to specify more than one upgrade of the same external CAM in the list.  Note 1: For example this could be updating the CAM and the bridge, or it could be two successive upgrades of the CAM.
#  5. For each external CAM upgrade in the upgrade list ECO shall create a broker request to go on the external CAM request queue (see ECO-9855) for the upgrade as per http://confluence.corp.resmed.org/display/CA/Requests
#  6. ECO shall notify the external CAM of a pending upgrade request by sending an SMS to the external CAM.
#  7. In cases where there is more than one upgrade of the same external CAM in the list then the order of the broker requests shall correspond to the order of application of the upgrades.
#  8. SMS retry mechanism shall operate as per ECO-5571 for requests that have been added for the external CAM.
#
#  Note 2: This page covers OTA upgrades for Newports https://confluence.ec2.local/display/ECO/Newport+OTA+upgrades and should be appended to cover the above.
#  Note 3: It is perfectly acceptable for the upgrade facilities to be provided using back-end services such as using sql interfaces or via a command line.
#  Note 4: As per ECO-5078, details of the upgrade including software versions of all upgraded device types should be available on request.

  Background:
    Given the device is on the <Telco> network 

  @manual
  @vodafone @aeris
  @telco.provider.S1
  @ECO-5360.1 @ECO-5359.1
  Scenario Outline: Send SMS using the Vodafone or Aeris API
    When a <Request_Type> request is queued for an S10 device 
    Then an SMS should be sent using the <Telco> API
  Examples: Types of requests
    | Request_Type          | Telco     |
    | Settings Change       | Aeris     |
    | Settings Change       | Vodaphone |

  @manual
  @vodafone @aeris
  @telco.provider.S2
  @ECO-5837.1 @ECO-5837.1a @ECO-5837.1b
  Scenario Outline: Send SMS using the Vodafone or Aeris API 
    When a WakeUp request is queued for an S10 device
    And the S10 device is not registered within <n> days
    Then a new SMS should be sent using the <Telco> API
    And the new WakeUp replaces previously sent WakeUp
  Examples: Types of requests
    | Telco        | n |
    | Vodaphone    | 7 |
    | Aeris        | 3 |


  @manual
  @vodafone @aeris
  @telco.provider.S3
  @ECO-10207.6
  Scenario Outline: Send SMS using the Vodafone or Aeris API
    When a <Request_Type> request is queued for a CAMBridge device
    Then an SMS should be sent using the <Telco> API
    Examples: Types of requests
      | Request_Type          | Telco     |
      | Upgrade               | Aeris     |
      | Upgrade               | Vodaphone |
