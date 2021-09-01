locals {
  csv_folder = "${path.module}/csv"
  env_csv_data = file("${local.csv_folder}/envs.csv")
  users_csv_data = file("${local.csv_folder}/users.csv")
  teams_csv_data = file("${local.csv_folder}/teams.csv")
  teams_roles_csv_data = file("${local.csv_folder}/teams_roles.csv")
  teams_members_csv_data = file("${local.csv_folder}/teams_members.csv")


  envs_list = csvdecode(local.env_csv_data)
  users_list = csvdecode(local.users_csv_data)
  
  teams_list = csvdecode(local.teams_csv_data)
  teams_roles_list = csvdecode(local.teams_roles_csv_data)
  teams_members_list = csvdecode(local.teams_members_csv_data)

  role_names_list = distinct( [ for role in local.teams_roles_list : role.name ] )

  #flattened result from roles data source
  data_roles_list = flatten([for iter in data.anypoint_roles.roles : iter.roles])

  data_envs_map = {
    for e in data.anypoint_bg.bg.environments : e.name => e
  }

  data_users_map = {
    for usr in data.anypoint_users.users_list.users : usr.username => usr
  }

  data_teams_map = {
    for team in data.anypoint_teams.teams_list.teams: team.team_name => team
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
    anypoint_env.envs
  ]
}

data "anypoint_users" "users_list" {
  org_id = var.root_org
  depends_on = [
    anypoint_user.users
  ]
}

data "anypoint_teams" "teams_list" {
  org_id = var.root_org
  depends_on = [
    anypoint_team.teams
  ]
}