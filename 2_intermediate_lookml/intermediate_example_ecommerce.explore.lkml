include: "/2_intermediate_lookml/*.view.lkml"

explore: intermediate_example_ecommerce {
  from: intermediate_order_items
  view_name: order_items
  label: "2) Intermediate Ecommerce"
  join: users {
    from: intermediate_users
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }

  join: inventory_items {
    from: intermediate_inventory_items
    fields: [inventory_items.product_id, inventory_items.cost,inventory_items.total_cost,inventory_items.average_cost]
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
