explore: table_1 {
  join: table_3 {
    sql_on: ${table_1.status} = ${table_3.status} ;;
    relationship: one_to_one
  }
  join: table_2 {
    relationship: one_to_one
    sql_on: ${table_2.status} = ${table_3.status} ;;
  }
}
view: table_1 {
  derived_table: {
    sql:
    select * from orders where {% parameter status_filter %} = status ;;
    sql_trigger_value: select * from orders ;;
    indexes: ["status"]
  }

  parameter: status_filter {}
  dimension: status {}
}

view: table_2 {
  derived_table: {
    sql:
      select * from ${table_1.SQL_TABLE_NAME} ;;
      sql_trigger_value: select * from orders ;;
    indexes: ["status"]
  }
  dimension: status {}
}

view: table_3 {
  derived_table: {
    sql: select * from ${table_2.SQL_TABLE_NAME} ;;
    sql_trigger_value: select * from orders ;;
    indexes: ["status"]
  }
  dimension: status {}
}
