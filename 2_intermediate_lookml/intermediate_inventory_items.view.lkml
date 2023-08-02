include: "/2_intermediate_lookml/custom_named_value_formats.lkml"

view: intermediate_inventory_items {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.inventory_items`;;

  dimension: id {
    view_label: "System Keys"
    label: "Inventory Item ID"
    primary_key: yes
    type: number
  }

  dimension: cost {
    type: number
    value_format_name: short_dollars
  }

  dimension_group: created {
    label: "Created"
    type: time
    timeframes: [time
                , date
                , week
                , month
                , raw
                ]
    sql: CAST(${TABLE}.created_at AS TIMESTAMP) ;;
  }

  dimension: product_id {
    view_label: "System Keys"
    label: "Product ID (On Inventory Item)"
    type: number
  }

  dimension_group: sold {
    label: "Sold"
    type: time
    timeframes: [time
                , date
                , week
                , month
                , raw
                ]
    sql: ${TABLE}.sold_at ;;
  }

  dimension: is_sold {
    label: "Is Sold"
    type: yesno
    sql: ${sold_raw} is not null ;;
  }

  dimension: days_in_inventory {
    label: "Days in Inventory"
    description: "days between created and sold date"
    type: number
    sql: TIMESTAMP_DIFF(coalesce(${sold_raw}, CURRENT_TIMESTAMP()), ${created_raw}, DAY) ;;
  }

  dimension: product_distribution_center_id {
    hidden: yes
  }

  ## MEASURES ##
  measure: count {
    label: "Inventory Item Count"
    type: count
  }

  measure: total_cost {
    label: "Total Cost"
    type: sum
    value_format_name: short_dollars
    sql: ${cost} ;;
  }

  measure: average_cost {
    label: "Average Cost"
    type: average
    value_format_name: short_dollars
    sql: ${cost} ;;
  }
}
