explore: sql_runner_query {}
view: sql_runner_query {
  derived_table: {
    sql: select row_number(), avg(id) from orders
    group by 1
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: avgid {
    type: number
    sql: ${TABLE}.`avg(id)` ;;
  }

  set: detail {
    fields: [id, avgid]
  }

  measure: avg {
    type: average
    sql: ${avgid} ;;
  }
}
