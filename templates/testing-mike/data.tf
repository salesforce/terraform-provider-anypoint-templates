locals {
    csv_path = "${path.module}/csv"
    bgs_csv = file("${local.csv_path}/bgs.csv")
    envs_csv = file("${local.csv_path}/envs.csv")
    users_csv = file("${local.csv_path}/users.csv")
    teams_csv = file("${local.csv_path}/teams.csv")

    bgs = csvdecode(local.bgs_csv)
    envs = csvdecode(local.envs_csv)
    users = csvdecode(local.users_csv)
    teams = csvdecode(local.teams_csv)

    # # list of all bgs after bg creation
    all_bgs_list = concat([data.anypoint_bg.bg], anypoint_bg.bgs)

    # #map of all business groups
    data_bgs_map = {
        for b in local.all_bgs_list : b.name => b
    }
    
    data_users_map = {
        for usr in data.anypoint_users.users_list.users : usr.username => usr
    }

  #   data_teams_map = {
  #     for team in data.anypoint_team.all_teams : team.team_name => team
  # }

}

data "anypoint_users" "users_list" {
  org_id = var.parent_org
  depends_on = [
    anypoint_user.users
  ]
}

data "anypoint_bg" "bg" {
  id = var.parent_org
  depends_on = [
    anypoint_bg.bgs
  ]
}

data "anypoint_bg" "all_bgs" {
  count = length(local.all_bgs_list)
  id = element(local.all_bgs_list, count.index).id
  depends_on = [
    anypoint_env.envs
  ]
}

# data "anypoint_team" "all_teams" {
#   org_id = var.parent_org
#   depends_on = [
#     anypoint_team.teams
#   ]
# }