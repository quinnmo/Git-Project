connection: "thelook"

# include all the views
include: "*.view"

# include all the dashboards
# include: "*.dashboard"

explore: events {

  join: user_data {
    # required_joins: [users]
    relationship: many_to_one
    sql_on: ${users.id} = ${user_data.id} ;;
  }
  join: users_nn {
    relationship: many_to_one
    # required_joins: [users]
    sql_on: ${users.id} = ${users_nn.id} ;;
  }
  join: users {
    required_joins: [user_data, users_nn]
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  fields: [ALL_FIELDS*, -products.category]
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}


# explore: order_items_3 {
#   # hidden: no
#   view_name: products
#   extends: [order_items, order_items_2]
# }
explore: order_items_2 {
  view_name: orders
  hidden: yes
}
explore: order_items {
  view_name: order_items
  hidden: yes
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

#   join: orders {
#     type: left_outer
#     sql_on: ${order_items.order_id} = ${orders.id} ;;
#     relationship: many_to_one
#   }
#
#   join: products {
#     type: left_outer
#     sql_on: ${inventory_items.product_id} = ${products.id} ;;
#     relationship: many_to_one
#   }
#
#   join: users {
#     type: left_outer
#     sql_on: ${orders.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
}

explore: orders {
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: products {}

explore: schema_migrations {}

explore: user_data {
  join: users {
    type: left_outer
    sql_on: ${user_data.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: users {}

explore: users_nn {}
