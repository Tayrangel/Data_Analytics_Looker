include: "/2_intermediate_lookml/*.view.lkml"

explore: intermediate_example_ecommerce_validated_orders {
  sql_always_where: ${order_items.validation_status} = "Valid" ;;
  always_filter: {filters:[order_items.validation_status: ""]}
  fields: [ALL_FIELDS*,-order_items.innapropriate_fields_for_valid_only_explores*]
  from: intermediate_order_items
  view_name: order_items
  label: "3) Intermediate Ecommerce (Valid Orders only)"

  join: users {
    from: intermediate_users
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }

  join: inventory_items {
    from: intermediate_inventory_items
    fields: [inventory_items.product_id, inventory_items.cost,inventory_items.total_cost,inventory_items.average_cost] # We determined most intermediate_inventory_items fields aren't relevant to our users, so we used the `fields` parameter to show in this Explore only the fields from this join that are necessary and helpful.
    type: left_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }

  join: products {
    from: intermediate_products
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }
}
