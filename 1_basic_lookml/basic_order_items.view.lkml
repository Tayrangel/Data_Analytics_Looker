view: basic_order_items {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.order_items` ;;

  ### Dimensions ###
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: inventory_item_id {
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: is_returned_or_cancelled {
    type: string
    sql: CASE
              WHEN ${status} IN ('Returned', 'Cancelled') THEN 'Returned or Cancelled'
              ELSE 'In progress or Completed'
         END;; # using some custom SQL in our dimensions SQL definition, remember you can write any SQL your database supports here
  }

  ### Dimension Group ###
  dimension_group: created_at {
    type: time
    timeframes: [raw,
                time
                ,date
                ,week
                ,month
                ,quarter
                ,year
                ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: shipped_at {
    type: time
    timeframes: [raw,
                time
                ,date
                ,week
                ,month
                ,quarter
                ,year
                ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension_group: delivered_at {
    type: time
    timeframes: [raw,
                time
                ,date
                ,week
                ,month
                ,quarter
                ,year
                ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension_group: returned_at {
    type: time
    timeframes: [raw,
                time
                ,date
                ,week
                ,month
                ,quarter
                ,year
                ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  #### Measures ####

  measure: count {
    label: "# of Order Items"
    type: count
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }
}
