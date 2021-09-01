# output "csv" {
#   value = local.envs_list
# }

# output "roles" {
#   value = local.data_roles_list
# } 

output "envs" {
  value = local.data_envs_map
}

output "users" {
  value = local.data_users_map
}
