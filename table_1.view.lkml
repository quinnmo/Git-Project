explore: table_1 {
  join: table_3 {
    sql_on: ${table_1.status} = ${table_3.status} ;;
    relationship: one_to_one
  }
}
view: table_1 {
  derived_table: {
    sql:
    select * from orders where {% parameter status_filter %} = status ;;
  }

  parameter: status_filter {}
  dimension: status {}
}

view: table_2 {
  derived_table: {
    sql:
      select * from ${table_1.SQL_TABLE_NAME} ;;
  }
  dimension: status {}
}

view: table_3 {
  derived_table: {
    sql: select * from ${table_2.SQL_TABLE_NAME} ;;
  }
  dimension: status {}
}
