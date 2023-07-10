# projects-kickstart

I reviewed https://jfrog-int.atlassian.net/wiki/spaces/PS/pages/207847558/API .
Need a  script to  showcase auto provision of  :
a) project creation ( with project admin group / user assigned with the "Manage Resources" , "Manage Members", "Index Resources" )
b) Create 1   project level environment
c)Create 1 local , remote  repo within the project ( so it confirms to a naming convention)
Then the Project Admin or the Platform admin can run also run a script to :
d) create a DEV ( with read , write actions) and READ ( with read action) project level Role mapped to the project level environment in stepb
e) Map a Group ( AD or Internal doe not matter)  to this Role
​
>> Here are some scripts  from YannC in https://git.jfrog.info/projects/PROFS/repos/labs/browse/On-Demand-Env/gcp/use_cases/provisioning/rt :
1. [project_init.sh](https://git.jfrog.info/projects/PROFS/repos/labs/browse/On-Demand-Env/gcp/use_cases/provisioning/rt/project_init.sh) :
   Shows how to assign existing repos to a project.
   ​
   ​
---
​
https://jfrog.slack.com/archives/CQC6UQ95Z/p1687915700492659
Project level environment has to be created manually or via the new Access API and cannot be created via terrafrom yet  ( see PTRENG-5287 ) as those Access APIs are not even documented yet but exist in the product ( see https://jfrog.slack.com/archives/C0247QQ4S1Z/p1687822232778969 ) .
Here is the use-case:
The platform admin will create the project.
I was planning to create the empty project and the map the "sv-project-admin-group" to be the Project admin.
The [projects/projects_sample_for_platform_admin.tf](projects/projects_sample_for_platform_admin.tf) terraform script works and creates the project  but with no  
Project admin.
How can this be fixed ?
---
https://jfrog.slack.com/archives/CQC6UQ95Z/p1687917797509569
After  Platform admin does  a) project creation ( with project admin group / user assigned with the "Manage Resources" , "Manage Members", "Index Resources" )  which I need help in previous slack post  , Medtronic is OK to manually do:
b)Create 1   project level environment using the new https://YOUR_ARTIFACTORY/access/api/v1/projects/YOUR_PROJECT_KEY/environments API with payload
{
"name": "YOURPROJECTKEY-STG-1"
}
Then the Project Admin  will take over and  create :
c) Create 1 local , remote  repo mapped to the project level environment in stepb , within the project .
d create a DEV project level Role ( with read , write actions) and READ project level Role( with read action)  mapped to the project level environment in stepb
e) Map a Group ( AD or Internal does not matter)  to this Role
Is c,d,e, possible today or we need new RFEs for these ? Please advise.
​
---
https://jfrog.slack.com/archives/C0247QQ4S1Z/p1688687219995479
​
As follow up to the discussion from https://jfrog.slack.com/archives/C0247QQ4S1Z/p1687822232778969
I opened the swagger in Postman .
1)Platform admin creates a Project using "POST Add a new project" i.e  /access/api/v1/projects
​
2)Platform admin sets the project admin - either
2a) a user using "POST Set user as project admin" using  /access/api/v1/projects/:project_key/user/:username/admin
or
2b) "POST Set group as project admin" using /access/api/v1/projects/:project_key/group/:groupname/admin
Need clarification on this as in the UI it appears that the project admin can be added while creating the Project
itself. But actually behind the scene it may be doing 1. and 2 . above.
>>> Yes , UI flow is different you can add users/group and assign repo as well wile creating project.In your case for
creating project and assigning users/groups will be 2 step process.
​
3.Then the Project admin will :
3a) create the Project level environments ( using /access/api/v1/projects/:project_key/environments) and custom roles mapped to those environments ( using /access/api/v1/projects/:project_key/roles) .
3b) Now who will create repositories in the project  and map  to project environment ?  The "Create Repository" and "Update Repository Configuration " Artifactory REST APIS says  "Security: Requires an admin user."  So can the project admin not do this ?
or
3c)the Platform admin has to  create and assign repos to the project  and map  to project environment .
​
What is the API to map existing repos ( not already mapped to environment ) to an existing
Environment   ?
>> Do not use
/access/api/v1/projects/_/attach/repositories/:repo_name/:target_project_key?force=<boolean>
The project admin "is" allowed to create repos in their  projects using
https://jfrog.com/help/r/jfrog-rest-apis/create-repository API.
The repos should have the "" prefix . The  "projectKey" and a environment can be  passed as parameter to create or  
update repo , using the artifactory api https://jfrog.com/help/r/jfrog-rest-apis/create-repository .
​
Note: The Platform admin can also assign preexisting repos to a project ( the project admin cannot do this).
```
curl -H "Authorization: Bearer $MY_ADMIN_AT"  \
-XPUT \
${MY_JPD_URL}/access/api/v1/projects/_/attach/repositories/${repo}/${repoKey}
``` 
​
​
​
​
4.Customer Medtronic Platform admin thought his work was over by just creating a Project and assigning a Project admin.
Now he has to create the repositories also for this project ?
>> Ask the JFrog Product team.
​
5. The Project admin can create new Project level roles using "POST {{baseUrl}}/v1/projects/:project_key/roles"
   or edit an existing project level role using "PUT {{baseUrl}}/v1/roles/:role"
   See List of pre-defined actions in  https://registry.terraform.io/providers/jfrog/project/latest/docs/resources/project
   6.The Project admin can map the roles to existing  groups ( as he/she can see all the groups imported from say SCIM ).
   Is this done via
   5a)"PUT Update group in project via /access/api/v1/projects/:project_key/groups/:group
   or
   5b) "PATCH Updates an Access group i.e /access/api/v1/groups/:name )
>> Do this via the api in "5a)"
​
This way the users in those groups can do the actions mapped to the role on those repos.
I need to write some scripts for these as part of Professional Services Engagement as the Terraform Projects provider does not have these features yet.
Please provide the necessary guidance.
​