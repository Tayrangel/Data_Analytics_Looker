### Basic ecomm model file ###
connection: "sample_bigquery_connection"
label: "Basic LookML"
include: "/1_basic_lookml/*.view.lkml"

explore: basic_order_items {
  label: "1) Basic Ecommerce"
  join: basic_users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${basic_users.id} = ${basic_order_items.user_id} ;;
  }
}
