resource "anypoint_bg" "bgs" {
  count = length(local.bgs)

  name = element(local.bgs, count.index).name
  parentorganizationid = var.parent_org

  ownerid = lookup(local.data_users_map, element(local.bgs, count.index).owner_username).id
  entitlements_createsuborgs = element(local.bgs, count.index).create_suborgs
  entitlements_createenvironments = element(local.bgs, count.index).create_env
  entitlements_globaldeployment = element(local.bgs, count.index).global_deployment
  entitlements_vcoresproduction_assigned = element(local.bgs, count.index).vcores_prod
  entitlements_vcoressandbox_assigned = element(local.bgs, count.index).vcores_sandbox
  entitlements_vcoresdesign_assigned = element(local.bgs, count.index).vcores_design
  entitlements_staticips_assigned = element(local.bgs, count.index).static_ips
  entitlements_vpcs_assigned = element(local.bgs, count.index).vpcs
  entitlements_loadbalancer_assigned = element(local.bgs, count.index).lbs
  entitlements_vpns_assigned = element(local.bgs, count.index).vpns
}

resource "anypoint_env" "envs" {
  count = length(local.envs)

  org_id = lookup(local.data_bgs_map, element(local.envs, count.index).bg_name).id
  name = element(local.envs, count.index).env_name
  type = element(local.envs, count.index).env_type
  
}

resource "anypoint_user" "users" {
  count = length(local.users)

  org_id = var.parent_org
  username = element(local.users, count.index).username
  first_name = element(local.users, count.index).firstname
  last_name = element(local.users, count.index).lastname
  email = element(local.users, count.index).email
  phone_number = element(local.users, count.index).phone
  password = element(local.users, count.index).pwd
}

# resource "anypoint_team" "teams" {
#   count = length(local.teams)

#   org_id = var.parent_org
#   parent_team_id = lookup(local.data_teams_map, element(local.teams, count.index).parent_team_name, {id: ""}).id
#   team_name = element(local.teams, count.index).name
#   team_type = element(local.teams, count.index).type
# }