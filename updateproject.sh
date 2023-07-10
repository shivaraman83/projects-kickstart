#! /bin/bash

# JFrog hereby grants you a non-exclusive, non-transferable, non-distributable right
# to use this  code   solely in connection with your use of a JFrog product or service.
# This  code is provided 'as-is' and without any warranties or conditions, either
# express or implied including, without limitation, any warranties or conditions of
# title, non-infringement, merchantability or fitness for a particular cause.
# Nothing herein shall convey to you any right or title in the code, other than
# for the limited use right set forth herein. For the purposes hereof "you" shall
# mean you as an individual as well as the organization on behalf of which you
# are using the software and the JFrog product or service.

### Exit the script on any failures
## define variable

token=cmVmdGtuOjAxOjE3MjA1NDczMjc6T2EwYnJIdjhhNVFMNTFvdEJlaHBpUWJxQkdp

### Get Arguments
SOURCE_JPD_URL="${1:?please enter JPD URL. ex - https://proservices.jfrog.io}"
JPD_AUTH_TOKEN="${2:?please provide the identity token}"
PROJECT_KEY="${3:?please provide the project key. ex - stp}"
## Delete the below  line later
curl -H"Authorization: Bearer $JPD_AUTH_TOKEN" -X DELETE -H "Content-Type: application/json" $SOURCE_JPD_URL/artifactory/api/repositories/stp-sivas-nuget-local-apac
##curl -H"Authorization: Bearer $JPD_AUTH_TOKEN" -X DELETE -H "Content-Type: application/json" $SOURCE_JPD_URL/access/api/v1/projects/$PROJECT_KEY/environments/stp-UAT



##create a new environment with name as $project-key-UAT
curl -H"Authorization: Bearer $JPD_AUTH_TOKEN" -X POST -H "Content-Type: application/json" $SOURCE_JPD_URL/access/api/v1/projects/$PROJECT_KEY/environments -d '{ "name": "'$PROJECT_KEY'-UAT"}'

##Create a new repo leveraging the new project key and environment
curl -H"Authorization: Bearer $JPD_AUTH_TOKEN" -X PUT  -H "Content-Type: application/json" $SOURCE_JPD_URL/artifactory/api/repositories/stp-sivas-nuget-local-apac -T repo-config.json


##Create a new project level role
curl -H"Authorization: Bearer $JPD_AUTH_TOKEN" -X POST  -H "Content-Type: application/json" $SOURCE_JPD_URL/access/api/v1/projects/stp/roles -T project-role-config.json

## sample usage - ./createproject.sh https://proservices.jfrog.io cmVmdGtuOjAxOjE3MjA1NDM3Njk6a0ZrRjFrYW5VbHQ1NXZjaDFpNmhzYWJQVE9Y sivas-test-project-admin


