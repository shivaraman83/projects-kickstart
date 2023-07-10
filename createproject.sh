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

token=cmVmdGtuOjAxOjE3MjA1NDM3Njk6a0ZrRjFrYW5VbHQ1NXZjaDFpNmhzYWJQVE9Y
### Get Arguments
SOURCE_JPD_URL="${1:?please enter JPD URL. ex - https://proservices.jfrog.io}"
JPD_AUTH_TOKEN="${2:?please provide the identity token}"
PROJECT_ADMIN_UNAME="${3:?please provide the username for the project admin . ex - sivas-test-project-admin}"
## Delete this line later
curl -H"Authorization: Bearer $JPD_AUTH_TOKEN" -X DELETE -H "Content-Type: application/json" $SOURCE_JPD_URL/access/api/v1/projects/stp


#Create a new project
curl -H"Authorization: Bearer $JPD_AUTH_TOKEN" -X POST -H "Content-Type: application/json" $SOURCE_JPD_URL/access/api/v1/projects -T project-config.json >> project-created.json
project_key=($(jq -r '.project_key' project-created.json))
echo $project_key is created

#Assign an existing user as a project admin to the newly created project above
curl -H"Authorization: Bearer $JPD_AUTH_TOKEN" -X POST -H "Content-Type: application/json" $SOURCE_JPD_URL/access/api/v1/projects/$project_key/user/$PROJECT_ADMIN_UNAME/admin
echo $PROJECT_ADMIN_UNAME is assigned as the project admin for Project with projectKey $project_key

## sample usage - ./createproject.sh https://proservices.jfrog.io cmVmdGtuOjAxOjE3MjA1NDM3Njk6a0ZrRjFrYW5VbHQ1NXZjaDFpNmhzYWJQVE9Y sivas-test-project-admin


