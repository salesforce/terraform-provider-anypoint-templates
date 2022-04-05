locals {
  csv_folder = "${path.module}/csv"
  bg_csv_data = file("${local.csv_folder}/bgs.csv")
  env_csv_data = file("${local.csv_folder}/envs.csv")
  users_csv_data = file("${local.csv_folder}/users.csv")

  teams_lvl1_csv_data = file("${local.csv_folder}/teams_lvl1.csv")
  teams_lvl1_roles_csv_data = file("${local.csv_folder}/teams_lvl1_roles.csv")
  teams_lvl1_members_csv_data = file("${local.csv_folder}/teams_lvl1_members.csv")

  teams_lvl2_csv_data = file("${local.csv_folder}/teams_lvl2.csv")
  teams_lvl2_roles_csv_data = file("${local.csv_folder}/teams_lvl2_roles.csv")
  teams_lvl2_members_csv_data = file("${local.csv_folder}/teams_lvl2_members.csv")

  teams_lvl3_csv_data = file("${local.csv_folder}/teams_lvl3.csv")
  teams_lvl3_roles_csv_data = file("${local.csv_folder}/teams_lvl3_roles.csv")
  teams_lvl3_members_csv_data = file("${local.csv_folder}/teams_lvl3_members.csv")

  bgs_list = csvdecode(local.bg_csv_data)
  envs_list = csvdecode(local.env_csv_data)
  users_list = csvdecode(local.users_csv_data)
  
  teams_lvl1_list = csvdecode(local.teams_lvl1_csv_data)
  teams_lvl1_roles_list = csvdecode(local.teams_lvl1_roles_csv_data)
  teams_lvl1_members_list = csvdecode(local.teams_lvl1_members_csv_data)
  
  teams_lvl2_list = csvdecode(local.teams_lvl2_csv_data)
  teams_lvl2_roles_list = csvdecode(local.teams_lvl2_roles_csv_data)
  teams_lvl2_members_list = csvdecode(local.teams_lvl2_members_csv_data)

  teams_lvl3_list = csvdecode(local.teams_lvl3_csv_data)
  teams_lvl3_roles_list = csvdecode(local.teams_lvl3_roles_csv_data)
  teams_lvl3_members_list = csvdecode(local.teams_lvl3_members_csv_data)

  role_names_list = distinct( concat([ for role in local.teams_lvl1_roles_list : role.name ], [ for role in local.teams_lvl2_roles_list : role.name ], [ for role in local.teams_lvl3_roles_list : role.name ]) )

  # Flattened result from roles data source
  data_roles_list = flatten([for iter in data.anypoint_roles.roles : iter.roles])

  # List of all BGs after BG creation
  all_bgs_list = concat([data.anypoint_bg.bg], anypoint_bg.bgs, data.anypoint_bg.existing_bgs)

  # Map of all business groups
  data_bg_map = {
    for b in local.all_bgs_list : b.name => b
  }

  # List of all created environments cross bgs
  data_envs_map = {
    for e in flatten([
      for b in data.anypoint_bg.all_bgs : [
        for env in b.environments : merge(
          {
            key = "${b.name}:${env.name}"
            bg_name = b.name
          }, env)
      ]
    ]) : e.key => e...
  }

  data_users_map = {
    for usr in data.anypoint_users.users_list.users : usr.username => usr
  }

  data_teams_lvl1_map = {
    for team in anypoint_team.lvl1_teams: team.team_name => team
  }

  data_teams_lvl2_map = {
    for team in anypoint_team.lvl2_teams: team.team_name => team
  }

  data_teams_lvl3_map = {
    for team in anypoint_team.lvl3_teams: team.team_name => team
  }
}

data "anypoint_roles" "roles" {
  count = length(local.role_names_list)
  params {
    search = element(local.role_names_list, count.index)
  }
}

# Root BG
data "anypoint_bg" "bg" {
  id = var.root_org
  depends_on = [
    anypoint_bg.bgs
  ]
}

# Existing child BGs
data "anypoint_bg" "existing_bgs" {
  count = length(var.sub_org_ids)
  id = element(var.sub_org_ids, count.index)
}

# Created BGs
data "anypoint_bg" "all_bgs" {
  count = length(local.all_bgs_list)
  id = element(local.all_bgs_list, count.index).id
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

# data "anypoint_teams" "teams_list" {
#   org_id = var.root_org
#   depends_on = [
#     anypoint_team.teams
#   ]
# }