Feature: Scrum Master
  As a scrum master
  I want to manage sprints and their stories
  So that they get done according the product owner's requirements

  Background:
    Given the ecookbook project has the backlogs plugin enabled
      And I am a scrum master of the project
      And I have deleted all existing issues
      And the project has the following sprints:
        | name       | sprint_start_date | effective_date  |
        | Sprint 001 | 2010-01-01        | 2010-01-31      |
        | Sprint 002 | 2010-02-01        | 2010-02-28      |
        | Sprint 003 | 2010-03-01        | 2010-03-31      |
        | Sprint 004 | 2.weeks.ago       | 1.week.from_now |
      And the project has the following stories in the product backlog:
        | position | subject |
        | 1        | Story 1 |
        | 2        | Story 2 |
        | 3        | Story 3 |
        | 4        | Story 4 |
      And the project has the following stories in the following sprints:
        | position | subject | sprint     |
        | 5        | Story A | Sprint 001 |
        | 6        | Story B | Sprint 001 |
      And the project has the following impediments:
        | subject      | sprint     | blocks  |
        | Impediment 1 | Sprint 001 | Story A | 

  Scenario: Create an impediment
    Given I am viewing the taskboard for Sprint 001
      And I want to create an impediment for Sprint 001
      And I want to set the subject of the impediment to Bad Impediment
      And I want to indicate that the impediment blocks Story B
     When I create the impediment
     Then the request should complete successfully
      And the sprint named Sprint 001 should have 2 impediments named Bad Impediment and Impediment 1

  Scenario: Update an impediment
    Given I am viewing the taskboard for Sprint 001
      And I want to edit the impediment named Impediment 1
      And I want to set the subject of the impediment to Good Impediment
      And I want to indicate that the impediment blocks Story B
     When I update the impediment
     Then the request should complete successfully
      And the sprint named Sprint 001 should have 1 impediment named Good Impediment

  Scenario: View impediments
    Given I am viewing the issues sidebar for Sprint 001
     Then the request should complete successfully
     When I follow "Impediments"
     Then the request should complete successfully
      And I should see "Impediment 1"

  Scenario: Create a new sprint
    Given I am viewing the master backlog
      And I want to create a sprint
      And I want to set the name of the sprint to sprint 005
      And I want to set the sprint_start_date of the sprint to 2010-03-01
      And I want to set the effective_date of the sprint to 2010-03-20
     When I create the sprint
     Then the request should complete successfully
      And I should see "sprint 005"

  Scenario: Update sprint details
    Given I am viewing the master backlog
      And I want to edit the sprint named Sprint 001
      And I want to set the name of the sprint to sprint xxx
      And I want to set the sprint_start_date of the sprint to 2010-03-01
      And I want to set the effective_date of the sprint to 2010-03-20
     When I update the sprint
     Then the request should complete successfully
      And the sprint should be updated accordingly

  Scenario: Update sprint with no name
    Given I am viewing the master backlog
      And I want to edit the sprint named Sprint 001
      And I want to set the name of the sprint to an empty string
     When I update the sprint
     Then the server should return an update error

  Scenario: Move a story from product backlog to sprint backlog
    Given I am viewing the master backlog
     When I move the story named Story 1 up to the 1st position of the sprint named Sprint 001
     Then the request should complete successfully
     When I move the story named Story 4 up to the 2nd position of the sprint named Sprint 001
      And I move the story named Story 2 up to the 1st position of the sprint named Sprint 002
      And I move the story named Story 4 up to the 1st position of the sprint named Sprint 001
     Then Story 4 should be in the 1st position of the sprint named Sprint 001
      And Story 1 should be in the 2nd position of the sprint named Sprint 001
      And Story 2 should be in the 1st position of the sprint named Sprint 002
  
  Scenario: Move a story down in a sprint
    Given I am viewing the master backlog
     When I move the story named Story A below Story B
     Then the request should complete successfully
      And Story A should be in the 2nd position of the sprint named Sprint 001
      And Story B should be the higher item of Story A
     
  Scenario: Request the project calendar feed
    Given I have set my API access key
      And I move the story named Story 4 down to the 1st position of the sprint named Sprint 004
      And I am logged out
     When I try to download the calendar feed, it should succeed
      And the request should complete successfully
    Given I have guessed an API access key
     When I try to download the calendar feed, it should fail
      And the request should complete successfully
     
  Scenario: Download printable cards for the product backlog
    Given I have selected card label stock Avery 7169
      And I am viewing the issues sidebar
     When I follow "Product backlog cards"
     Then the request should complete successfully

  Scenario: Download printable cards for the task board
    Given I have selected card label stock Avery 7169
      And I move the story named Story 4 up to the 1st position of the sprint named Sprint 001
      And I am viewing the issues sidebar for Sprint 001
     When I follow "Sprint cards"
     Then the request should complete successfully

  Scenario: view the sprint notes
    Given I have set the content for wiki page Sprint Template to Sprint Template
      And I have made Sprint Template the template page for sprint notes
      And I am viewing the taskboard for Sprint 001
     When I view the sprint notes
     Then the request should complete successfully
    Then the wiki page Sprint 001 should contain Sprint Template

  Scenario: edit the sprint notes
    Given I have set the content for wiki page Sprint Template to Sprint Template
      And I have made Sprint Template the template page for sprint notes
      And I am viewing the taskboard for Sprint 001
     When I edit the sprint notes
     Then the request should complete successfully
     Then the wiki page Sprint 001 should contain Sprint Template

