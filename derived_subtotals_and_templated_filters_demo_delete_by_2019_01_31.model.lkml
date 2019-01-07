label: "derived subtotals and templated filters demo"
connection: "events_ecommerce"

include: "*.view"

explore: order_items {
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

#######
  join: brand_summary_dt {
    view_label: "Products"
    type: left_outer
    sql_on: ${products.brand} = ${brand_summary_dt.brand} ;;
    relationship: many_to_one

  }


}
#
