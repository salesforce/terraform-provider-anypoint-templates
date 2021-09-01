resource "anypoint_env" "envs" {
  count = length(local.envs_list)

  org_id = var.root_org
  name = element(local.envs_list, count.index).name
  type = element(local.envs_list, count.index).type
}


resource "anypoint_user" "users" {
  count = length(local.users_list)

  org_id = var.root_org
  username = element(local.users_list, count.index).username
  first_name = element(local.users_list, count.index).firstname
  last_name = element(local.users_list, count.index).lastname
  email = element(local.users_list, count.index).email
  phone_number = element(local.users_list, count.index).phone
  password = element(local.users_list, count.index).pwd
}


# resource "anypoint_team" "teams" {
#   count = length(local.teams_list)

#   org_id = var.root_org
#   parent_team_id = var.root_team
#   team_name = element(local.teams_list, count.index).name
#   team_type = element(local.teams_list, count.index).type
# }

# resource "anypoint_team_roles" "teams_roles" {
#   count = length(local.teams_list)

#   org_id = var.root_org
#   team_id = anypoint_team.teams[count.index].id
  
#   dynamic "roles" {
#     for_each = [
#       for role in local.teams_roles_list : role
#       if tonumber(role.team_index) == count.index
#     ]
#     content {
#       role_id = element([
#         for iter in local.data_roles_list : iter.role_id
#         if iter.name == roles.value.name
#       ], 0)
#       context_params = {
#         org = var.root_org
#         envId = length(roles.value["context_env_index"]) > 0 ? anypoint_env.envs[tonumber(roles.value["context_env_index"])].id : null
#       }
#     }
#   }
# }


# resource "anypoint_team_member" "teams_members" {
#   count = length(local.teams_members_list)

#   org_id = var.root_org
#   team_id = anypoint_team.teams[tonumber(element(local.teams_members_list, count.index).team_index)].id
#   user_id = anypoint_user.users[tonumber(element(local.teams_members_list, count.index).user_index)].id
# }
