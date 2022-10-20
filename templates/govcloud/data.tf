locals {
  csv_folder                         = "${path.module}/csv"
  bg_csv_data                        = file("${local.csv_folder}/bgs.csv")
  env_csv_data                       = file("${local.csv_folder}/envs.csv")
  users_csv_data                     = file("${local.csv_folder}/users.csv")
  teams_lvl1_csv_data                = file("${local.csv_folder}/teams_lvl1.csv")
  teams_lvl1_roles_csv_data          = file("${local.csv_folder}/teams_lvl1_roles.csv")
  teams_lvl1_members_csv_data        = file("${local.csv_folder}/teams_lvl1_members.csv")
  teams_lvl2_csv_data                = file("${local.csv_folder}/teams_lvl2.csv")
  teams_lvl2_roles_csv_data          = file("${local.csv_folder}/teams_lvl2_roles.csv")
  teams_lvl2_members_csv_data        = file("${local.csv_folder}/teams_lvl2_members.csv")
  vpcs_csv_data                      = file("${local.csv_folder}/vpcs.csv")
  dlbs_csv_data                      = file("${local.csv_folder}/dlbs.csv")
  teams_lvl1_group_mappings_csv_data = file("${local.csv_folder}/teams_lvl1_group_mappings.csv")
  teams_lvl2_group_mappings_csv_data = file("${local.csv_folder}/teams_lvl2_group_mappings.csv")
  idp_oidc_csv_data                  = file("${local.csv_folder}/idp_oidc.csv")

  bgs_list      = csvdecode(local.bg_csv_data)
  envs_list     = csvdecode(local.env_csv_data)
  users_list    = csvdecode(local.users_csv_data)
  vpcs_list     = csvdecode(local.vpcs_csv_data)
  dlbs_list     = csvdecode(local.dlbs_csv_data)
  idp_oidc_list = csvdecode(local.idp_oidc_csv_data)

  teams_lvl1_list         = csvdecode(local.teams_lvl1_csv_data)
  teams_lvl1_roles_list   = csvdecode(local.teams_lvl1_roles_csv_data)
  teams_lvl1_members_list = csvdecode(local.teams_lvl1_members_csv_data)

  teams_lvl2_list         = csvdecode(local.teams_lvl2_csv_data)
  teams_lvl2_roles_list   = csvdecode(local.teams_lvl2_roles_csv_data)
  teams_lvl2_members_list = csvdecode(local.teams_lvl2_members_csv_data)

  teams_lvl1_group_mappings_list = csvdecode(local.teams_lvl1_group_mappings_csv_data)
  teams_lvl2_group_mappings_list = csvdecode(local.teams_lvl2_group_mappings_csv_data)

  role_names_list = distinct(concat([for role in local.teams_lvl1_roles_list : role.name], [for role in local.teams_lvl2_roles_list : role.name]))

  #flattened result from roles data source
  data_roles_list = flatten([for iter in data.anypoint_roles.roles : iter.roles])

  # list of all bgs after bg creation
  all_bgs_list = concat([data.anypoint_bg.bg], anypoint_bg.bgs)

  # list of all vpcs after vpc creation
  all_vpcs_list = anypoint_vpc.vpcs

  #map of all vpcs
  data_vpc_map = {
    for b in local.all_vpcs_list : b.name => b
  }

  #map of all business groups
  data_bg_map = {
    for b in local.all_bgs_list : b.name => b
  }

  #list of all created environments cross bgs
  data_envs_map = {
    for e in flatten([
      for b in data.anypoint_bg.all_bgs : [
        for env in b.environments : merge(
          {
            key     = "${b.name}:${env.name}"
            bg_name = b.name
        }, env)
      ]
    ]) : e.key => e...
  }

  data_users_map = {
    for usr in data.anypoint_users.users_list.users: usr.username => usr
  }

/* Use this block if org has over 500 users
  data_users_map = merge([for l in data.anypoint_users.users_list : {
    for usr in l.users : usr.username => usr
    //filter duplicated users
    //if usr.<attribute_name> == "<attribute_value>"
  }]...) # please do NOT remove the dots                       
*/

  data_teams_lvl1_map = {
    for team in anypoint_team.lvl1_teams : team.team_name => team
  }

  data_teams_lvl2_map = {
    for team in anypoint_team.lvl2_teams : team.team_name => team
  }
}

data "anypoint_roles" "roles" {
  count = length(local.role_names_list)
  params {
    search = element(local.role_names_list, count.index)
  }
}

data "anypoint_bg" "bg" {
  id = var.root_org
  depends_on = [
    anypoint_bg.bgs
  ]
}

data "anypoint_bg" "all_bgs" {
  count = length(local.all_bgs_list)
  id    = element(local.all_bgs_list, count.index).id
  depends_on = [
    anypoint_env.envs
  ]
}

data "anypoint_users" "users_list" {
  org_id = var.root_org
  depends_on = [
    anypoint_user.users
  ]
}

/* Use this block if org has over 500 users
  data "anypoint_users" "users_list" {
  count  = 10
  org_id = var.root_org
  params {
    offset = 0 + (count.index * 500) # page number
    limit  = 500                     # number of users per page
    type   = "all"                   # users type
  }
  depends_on = [
    anypoint_user.users
  ]
} */

# data "anypoint_teams" "teams_list" {
#   org_id = var.root_org
#   depends_on = [
#     anypoint_team.teams
#   ]
# }