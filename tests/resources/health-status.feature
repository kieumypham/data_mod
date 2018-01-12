@health.status
@ECO-4283
@ECO-6053
@ECO-6895
@ECO-19135
@ECO-19284

Feature:
  (ECO-4283) As a ResMed Customer Support User,
  I want continuous checks performed on the system health
  so that users are informed if the system is offline

  (ECO-6053) As an external monitoring system,
    I want to check the health status of NGCS Newport,
    so that I may know the current condition of the server.

  (ECO-6985) Update NGCS S10 health check

  (ECO-19135) As an external monitoring system,
    I want to check the health status of NGCS Casablanca,
    so that I may know the current condition of the server.

  (ECO-19284) As an external monitoring system,
    I want to check the health status of NGCS Pacific,
    in order that I may know the current condition of the server.

# ACCEPTANCE CRITERIA: (ECO-4283)
# 1.	When a health check is requested, the NGCS server shall confirm whether the NGCS is operational.

# ACCEPTANCE CRITERIA: (ECO-6053)
# As an external monitoring system, I want to check the health status of NGCS Newport, in order that I may know the current condition of the server.
# Expose endpoint that responds OK if:
# 1. Database can be accessed (read only).
# 2. The message server can be accessed.

# ACCEPTANCE CRITERIA: (ECO-6895)
# Note 1: This task is to update the NGCS S10 health check functionality to support the new maintenance mode for ECO deployment.
# 1. Update NGCS S10 health check to respond on port 31622 Note: This is the same port as the CAM cam server.
# 2. Update NGCS S10 health check to respond on port 8198 Note: This is the same port as the NGCS Management API.
# 3. Update NGCS S10 to have ability to toggle on/off health check

# ACCEPTANCE CRITERIA: (ECO-19135)
# Note 1: Casablanca machine services will run on port 31624
# 1. The server shall provide a simple health status when maintenance mode is off
# 1a. When the server is healthy, the status shall be the value "true"
# 1b. When the server is unhealthy, the status shall be the value "false"
# 2. The server shall provide health details when maintenance mode is on

# ACCEPTANCE CRITERIA: (ECO-19284)
# Note 1: Pacific machine services will run on port 31625
# 1. The server shall provide a simple health status when maintenance mode is off
# 1a. When the server is healthy, the status shall be the value "true"
# 1b. When the server is unhealthy, the status shall be the value "false"
# 2. The server shall provide health details when maintenance mode is on


Background:

@health.status.S1
@ECO-4283.1
@ECO-6053.1 @ECO-6053.2
@ECO-6895.1 @ECO-6895.2
@ECO-19135.1a
@ECO-19284.1a
Scenario: Health status check responds with a positive status when healthy
  When I request the casablanca server health
  Then I should receive a server ok response
  And the health status response body should be
    | body |
    | true |
  When I request the management server health
  Then I should receive a server ok response
  And the health status response body should be
    | body |
    | true |
  When I request the monaco server health
  Then I should receive a server ok response
  And the health status response body should be
    | body |
    | true |
  When I request the newport server health
  Then I should receive a server ok response
  And the health status response body should be
    | body |
    | true |
  When I request the pacific server health
  Then I should receive a server ok response
  And the health status response body should be
    | body |
    | true |


@health.status.S2
@ECO-4283.1
@ECO-6053.1 @ECO-6053.2
@ECO-6895.1 @ECO-6895.2
@ECO-19135.1b
@ECO-19284.1b
Scenario: Health status check responds with a negative status when cannot connect to data source
  Given the following commands are run on the karaf console
    | commands                                    |
    | stop resmed.hi.ngcs.data-source.mssql.cloud |
    | stop resmed.hi.ngcs.data-source.mssql.ngcs  |
  When I request the casablanca server health
  Then I should receive a server ok response
  And the health status response body should be
    | body  |
    | false |
  When I request the management server health
  Then I should receive a server ok response
  And the health status response body should be
    | body  |
    | false |
  When I request the monaco server health
  Then I should receive a server ok response
  And the health status response body should be
    | body  |
    | false |
  When I request the newport server health
  Then I should receive a server ok response
  And the health status response body should be
    | body  |
    | false |
  When I request the pacific server health
  Then I should receive a server ok response
  And the health status response body should be
    | body  |
    | false |
  Given the following commands are run on the karaf console
    | commands                                     |
    | start resmed.hi.ngcs.data-source.mssql.cloud |
    | start resmed.hi.ngcs.data-source.mssql.ngcs  |

@health.status.S3
@ECO-4283.1
@ECO-6053.1 @ECO-6053.2
@ECO-6895.1 @ECO-6895.2
@ECO-19135.1b
@ECO-19284.1b
Scenario: Health status check responds with a negative status when cannot connect to message source
  Given the following commands are run on the karaf console
    | commands                                 |
    | stop resmed.hi.ngcs.message.tibco-client |
  When I request the casablanca server health
  Then I should receive a server ok response
  And the health status response body should be
    | body  |
    | false |
  When I request the management server health
  Then I should receive a server ok response
  And the health status response body should be
    | body  |
    | false |
  When I request the monaco server health
  Then I should receive a server ok response
  And the health status response body should be
    | body  |
    | false |
  When I request the newport server health
  Then I should receive a server ok response
  And the health status response body should be
    | body  |
    | false |
  When I request the pacific server health
  Then I should receive a server ok response
  And the health status response body should be
    | body  |
    | false |
  Given the following commands are run on the karaf console
    | commands                                  |
    | start resmed.hi.ngcs.message.tibco-client |

@health.status.S4
@ECO-6895.3
@ECO-19135.2
@ECO-19284.2
Scenario: Health status response according to maintenance mode toggle and all healthy
  When I set the casablanca server maintenance mode to true
  And I request the casablanca server health
  Then I should receive a server ok response
  And the health status response body should be
    | body                                                                            |
    | {"maintenanceMode":"yes","databaseHealthy":"yes","messageServiceHealthy":"yes"} |
  When I set the casablanca server maintenance mode to false
  And I request the casablanca server health
  Then I should receive a server ok response
  And the health status response body should be
    | body |
    | true |
  When I set the management server maintenance mode to true
  And I request the management server health
  Then I should receive a server ok response
  And the health status response body should be
    | body                                                                            |
    | {"maintenanceMode":"yes","databaseHealthy":"yes","messageServiceHealthy":"yes"} |
  When I set the management server maintenance mode to false
  And I request the management server health
  Then I should receive a server ok response
  And the health status response body should be
    | body |
    | true |
  When I set the monaco server maintenance mode to true
  And I request the monaco server health
  Then I should receive a server ok response
  And the health status response body should be
    | body                                                                            |
    | {"maintenanceMode":"yes","databaseHealthy":"yes","messageServiceHealthy":"yes"} |
  When I set the monaco server maintenance mode to false
  And I request the monaco server health
  Then I should receive a server ok response
  And the health status response body should be
    | body |
    | true |
  When I set the newport server maintenance mode to true
  And I request the newport server health
  Then I should receive a server ok response
  And the health status response body should be
    | body                                                                            |
    | {"maintenanceMode":"yes","databaseHealthy":"yes","messageServiceHealthy":"yes"} |
  When I set the newport server maintenance mode to false
  And I request the newport server health
  Then I should receive a server ok response
  And the health status response body should be
    | body |
    | true |
  When I set the pacific server maintenance mode to true
  And I request the pacific server health
  Then I should receive a server ok response
  And the health status response body should be
    | body                                                                            |
    | {"maintenanceMode":"yes","databaseHealthy":"yes","messageServiceHealthy":"yes"} |
  When I set the pacific server maintenance mode to false
  And I request the pacific server health
  Then I should receive a server ok response
  And the health status response body should be
    | body |
    | true |

@health.status.S5
@ECO-6895.3
@ECO-19135.2
@ECO-19284.2
Scenario: Health status response according to maintenance mode toggle and cannot connect to data source
  Given the following commands are run on the karaf console
    | commands                                    |
    | stop resmed.hi.ngcs.data-source.mssql.cloud |
    | stop resmed.hi.ngcs.data-source.mssql.ngcs  |
  When I set the casablanca server maintenance mode to true
  And I request the casablanca server health
  Then I should receive a server ok response
  And the health status response body should be
    | body                                                                           |
    | {"maintenanceMode":"yes","databaseHealthy":"no","messageServiceHealthy":"yes"} |
  When I set the casablanca server maintenance mode to false
  And I request the casablanca server health
  Then I should receive a server ok response
  And the health status response body should be
    | body  |
    | false |
  When I set the management server maintenance mode to true
  And I request the management server health
  Then I should receive a server ok response
  And the health status response body should be
    | body                                                                           |
    | {"maintenanceMode":"yes","databaseHealthy":"no","messageServiceHealthy":"yes"} |
  When I set the management server maintenance mode to false
  And I pause for 2 seconds
  And I request the management server health
  Then I should receive a server ok response
  And the health status response body should be
    | body  |
    | false |
  When I set the monaco server maintenance mode to true
  And I request the monaco server health
  Then I should receive a server ok response
  And the health status response body should be
    | body                                                                           |
    | {"maintenanceMode":"yes","databaseHealthy":"no","messageServiceHealthy":"yes"} |
  When I set the monaco server maintenance mode to false
  And I request the monaco server health
  Then I should receive a server ok response
  And the health status response body should be
    | body  |
    | false |
  When I set the newport server maintenance mode to true
  And I request the newport server health
  Then I should receive a server ok response
  And the health status response body should be
    | body                                                                           |
    | {"maintenanceMode":"yes","databaseHealthy":"no","messageServiceHealthy":"yes"} |
  When I set the newport server maintenance mode to false
  And I request the newport server health
  Then I should receive a server ok response
  And the health status response body should be
    | body  |
    | false |
  When I set the pacific server maintenance mode to true
  And I request the pacific server health
  Then I should receive a server ok response
  And the health status response body should be
    | body                                                                           |
    | {"maintenanceMode":"yes","databaseHealthy":"no","messageServiceHealthy":"yes"} |
  When I set the pacific server maintenance mode to false
  And I request the pacific server health
  Then I should receive a server ok response
  And the health status response body should be
    | body  |
    | false |
  Given the following commands are run on the karaf console
    | commands                                     |
    | start resmed.hi.ngcs.data-source.mssql.cloud |
    | start resmed.hi.ngcs.data-source.mssql.ngcs  |
