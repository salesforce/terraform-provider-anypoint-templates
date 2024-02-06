# MVP

## Introduction
This templates creates the following resources dynamically by filling the csv files contained in the csv folder:
- Business Groups
- Environments
- Users
- Teams
- Team Roles
- Team Members

## Teams
Teams are created following this structure:

![alt text](resources/teams_struct.png "Teams structure")


## How to use the template ? 
Before you begin, make sure you install [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).

Copy the template folder to your workspace and perform the following action: 

1. Fill the csv files with your own parameters for each resource type. You can find more information about the parameters for each resource in the `csv file parameters` section.
2. Copy the `template.params.tfvars.json` file content into another json file (we will use `params.tfvars.json` to refer to this copy).
3. Fill the `params.tfvars.json` file with your own parameters. You will find more information about each parameter in the `Terraform parameters file` section
4. To execute the script in order to create parameters, please use the following commands on your terminal:
    * If it's the first time use execute this specific instance of the template, use the following command to initialize terraform providers: 
      ```shell
      $ terraform init  
      ```
    * To apply changes, and create the resources in the platform use the following commands: 
      ```shell
      $ terraform apply -var-file="params.tfvars.json"
      ```
      Terraform will show you all the actions that it is going to perform and will ask for you validation. 
    * To destroy the resources you've previously created, use the following:
      ```shell
      $ terraform destroy -var-file="params.tfvars.json"
      ```

## Resource creation and recycling
When the terraform script is executed, terraform compiles your parameters to know exactly what it is going to create and in which order. Following is a schema that shows the resource that are created. Arrows show dependency relationship. Terraform will start by creating the roots and make its way down through dependencies. 

![alt text](resources/terraform_plan.png "Terraform plan")

When Terraform applies changes, the `tfstate` file is updated to save the latest resources state.

When Terraform is executed for update, it will compare against its latest state to refresh and recycle all resources. 

> **N.B:** If the resource have been changed outside terraform (using anypoint UI for example) terraform will not include those changes, and they will be lost.

## Terraform parameters file
The parameters file is used to contextualize terraform's execution. Following is the list of parameters
```json
{
  "username": "xxxxxxxx",                               // anypoint username 
  "password": "xxxxxxxx",                               // anypoint password
  "client_id": "xxxxxxxxx-xxxx-xxxx-xxx-xxxxxxxxxx",    // anypoint connected app client id
  "client_secret": "xxxxxxxxx-xxxx-xxxx-xxx-xxxxxxxxxx", // anypoint connected app client secret
  "access_token": "xxxxxxxxx-xxxx-xxxx-xxx-xxxxxxxxxx", // anypoint connected app access token
  "root_org": "xxxxxxxxx-xxxx-xxxx-xxx-xxxxxxxxxx",     // root business group id
  "root_team": "xxxxxxxxx-xxxx-xxxx-xxx-xxxxxxxxxx",    // root team id
  "cplane": "us | eu | gov"                             // anypoint control plane
}
```

The anypoint user should have admin privileges.  

## CSV file parameters
This section describes the CSV columns for each resource

#### Environments (ENV)
Following is the description of the columns in the `csv/envs.csv` file:

| Column name   | Description | Example|
| -----------   | ----------- | ------ |
| name          | the name of the environment | DEV |
| type          | the type of the environment | sandbox | 

All these environments are created under the root org (provided in the parameters).

#### Users
Following is the description of the columns in the `csv/users.csv` file:

| Column name   | Description | Example|
| -----------   | ----------- | ------ |
| username      | the username of the user, it must be unique and shouldn't be used twice (even if the user has been deleted) | userxx1 |
| firstname     | the user's firstname | john |
| lastname      | the user's lastname  | doe  |
| email         | the usere's email address | my@email.com |
| phone         | the user's phone number   | 0121231232   |
| pwd           | the user's initial password | mysupersecurepwd |


#### Teams
Following is the description of the columns in the `csv/teams_lvl1.csv` file:

| Column name   | Description | Example|
| -----------   | ----------- | ------ |
| name          | the team's name | BG1 team |
| type          | the type of the team, can only have the value internal as of now | internal |

These teams are created under the root team.

#### Team Roles
Following is the description of the columns in the `csv/teams_roles.csv` file:

| Column name   | Description | Example|
| -----------   | ----------- | ------ |
| team_name    | the team's name to which the role will be attached | Org Admin |
| name          | the role's name | API Group Administrator |
| context_env_index | if the role spans environments, then provide the environment's name to which the role will be applied against | INT |

Roles will be bind by default to the root org (provided in parameters)

#### Team Members
Following is the description of the columns in the `csv/teams_members.csv` file:


| Column name   | Description | Example|
| -----------   | ----------- | ------ |
| team_name     | the team's name to which the user will be added to | Developers |
| user_name     | the user's username | userxxx2 |


## Template Limits

* When a team is added to `csv/teams.csv`, at least one role should be attached to it in the corresponding roles file.


