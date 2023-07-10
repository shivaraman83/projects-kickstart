## Pre-requisites
1. Create an user(non admin) named - e.g sivas-test-project-admin on your JPD. This user will later be converted to a project admin
2. Create another user named uat-user. This is the normal uat-tester of the project which will download the artifacts
3. Create an uat-group. This group will contain the uat-tester user from step2

## CreateProject.sh - To be run by Platform Admin. Please create an admin token
1. CreateProject.sh should be run by the platform admin.
2.  This script creates a project and assigns sivas-test-project-admin user as the project admin for the project

## updateProjects.sh - To be run by Project admin. Please create an ID token as project admin
1. updateProjects.sh should be run by the project admin
2. It Creates a new environment on the project created by the previous step
3. Creates a new repository leveraging the environment created in step2
4. Creates a project level role which can be assigned to that project team members
5. Finally it assigns the role created to the group/user which belong to the project team