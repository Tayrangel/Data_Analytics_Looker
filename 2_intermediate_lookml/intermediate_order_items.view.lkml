include: "/2_intermediate_lookml/custom_named_value_formats.lkml"

view: intermediate_order_items {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.order_items` ;;

  label: "Order Items"

  dimension: id {
    label: "Order Item ID"
    view_label: "System Keys"
    primary_key: yes
    type: number
    value_format_name: id
  }

  dimension: order_id {
    label: "Order ID (On Order Item)"
    view_label: "System Keys"
    type: number
    value_format_name: id
  }

  dimension: user_id {
    label: "User ID (On Order Item)"
    view_label: "System Keys"
    type: number
    value_format_name: id
  }

  dimension: product_id {
    label: "Product ID (On Order Item)"
    view_label: "System Keys"
    type: number
    value_format_name: id
  }

  dimension: inventory_item_id {
    label: "Inventory Item ID (On Order Item)"
    view_label: "System Keys"
    type: number
    value_format_name: id
  }

  dimension: status {
    group_label: "Status Fields"
  }

  dimension_group: created_at {
    type: time
    timeframes: [raw
                ,time
                ,date
                ,week
                ,month
                ,quarter
                ,year
                ]
  }

  dimension_group: shipped_at {
    group_label: "Other Dates"
    type: time
    timeframes: [raw
                ,time
                ,date
                ,week
                ,month
                ,quarter
                ,year
                ]
  }

  dimension_group: delivered_at {
    group_label: "Other Dates"
    type: time
    timeframes: [raw
                ,time
                ,date
                ,week
                ,month
                ,quarter
                ,year
                ]
  }

  dimension_group: returned_at {
    group_label: "Other Dates"
    type: time
    timeframes: [raw
                ,time
                ,date
                ,week
                ,month
                ,quarter
                ,year
                ]
  }

  dimension: sale_price {
    type: number
    value_format_name: short_dollars
  }


### CUSTOM STATUS GROUPINGS ###
  dimension: cancellation_type {
    group_label: "Status Fields"
    drill_fields: [status]
    case: {
      when: {sql:${status} in ('Cancelled');; label:"Cancelled"}
      when: {sql:${status} in ('Returned');; label:"Returned"}
      when: {sql:${status} in ('Shipped','Complete','Processing');; label:"Not Cancelled"}
      else: "Unknown"
    }
  }

  dimension: validation_status {
    group_label: "Status Fields"
    drill_fields: [status]
    case: {
      when: {sql:${status} in ('Cancelled','Returned');; label:"Invalid"}
      when: {sql:${status} in ('Shipped','Complete','Processing');; label:"Valid"}
      else: "Unknown"
      }
  }

  dimension: status_in_order {
    case: {
      when: {sql:${status} in ('Processing');; label:"1 - Processing"}
      when: {sql:${status} in ('Cancelled');; label:"1x - Cancelled"}
      when: {sql:${status} in ('Shipped');; label:"2 - Shipped"}
      when: {sql:${status} in ('Complete');; label:"3 - Complete"}
      when: {sql:${status} in ('Returned');; label:"3x - Returned"}
      else: "Unknown"
    }
  }

  dimension: is_valid {
    group_label: "Status Fields"
    drill_fields: [status]
    type: yesno
    sql:${status} in ('Shipped','Complete','Processing');;
  }


### OTHER NOTABLE FIELD TYPES
  dimension: shipped_to_delivered_days {
    group_label: "Other Dates"
    type: duration_day
    sql_start: ${shipped_at_raw} ;;
    sql_end: ${delivered_at_raw} ;;
  }

  dimension: sale_price_tier {
    type: bin
    bins: [10,20,50,100]
    style: relational
    sql: ${sale_price} ;;
  }

  measure: count {
    label: "# of Order Items"
    type: count
    drill_fields: [standard_order_items_measure_drill_fields*]
  }

  measure: total_sale_price {
    label: "Sales"
    type: sum
    sql: ${sale_price} ;;
    drill_fields: [standard_order_items_measure_drill_fields*]
    value_format_name: short_dollars
  }

  measure: average_sale_price {
    label: "Average Price"
    type: average
    sql: ${sale_price} ;;
    drill_fields: [standard_order_items_measure_drill_fields*]
    value_format_name: short_dollars
  }

### Filtered Measures
  measure: total_sales_price_validated {
    label: "Sales (Validated)"
    type: sum
    sql: ${sale_price} ;;
    filters: [is_valid: "Yes"]
    value_format_name: short_dollars
  }

  measure: first_order_date {
    type: date
    sql: min(${created_at_raw}) ;;
  }

  set: innapropriate_fields_for_valid_only_explores {fields:[cancellation_type,total_sales_price_validated]}
  set: standard_order_items_measure_drill_fields {fields:[id,user_id,product_id,created_at_date,shipped_at_date, delivered_at_date, returned_at_date,status,sale_price]}
}
