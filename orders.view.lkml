include: "git_project.model.lkml"
view: orders {
  sql_table_name: demo_db.orders ;;

  filter: date_filter {
    type: date
  }

  filter: dis_a_test{}

  parameter: period {
    type: number
  }

  dimension: period_logic {
    type: yesno
    sql:
    {% if date_granularity._parameter_value == "'Day'" %}
          ${created_date} > date_sub(current_date(), INTERVAL {% parameter period %} DAY)
       {% elsif date_granularity._parameter_value == "'Month'" %}
            ${created_date} > date_sub(current_date(), INTERVAL {% parameter period %} MONTH)
        {% elsif date_granularity._parameter_value == "'Year'" %}
           ${created_date} > date_sub(current_date(), INTERVAL {% parameter period %} YEAR)
         {% else %}
           NULL
          {% endif %} ;;

  }

  parameter: date_granularity {
    type: string
    allowed_value: { value: "Day" }
    allowed_value: { value: "Month" }
    allowed_value: { value: "Quarter" }
    allowed_value: { value: "Year" }
  }

  dimension: date {
    label_from_parameter: date_granularity
    sql:
       CASE
         WHEN {% parameter date_granularity %} = 'Day' THEN
          ${created_date}
         WHEN {% parameter date_granularity %} = 'Month' THEN
           ${created_month}
         WHEN {% parameter date_granularity %} = 'Year' THEN
          ${created_year}
         ELSE
           NULL
       END ;;
  }

  dimension: month {
    type: date_month
    sql: extract(month from ${TABLE}.created_at) ;;
  }
  dimension: test {}

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
    html:<a href="/dashboards/4?Month={{created_month._value }}">{{ value }} ;;

  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    link: {
      label: "test"
      url: "/dashboards/2?Date={{_filters['orders.date_filter'] | url_encode }}"
    }
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
    value_format: "0.00\%"
    html:
    {% if value > 80 %}
    <span style="color: darkred">{{ rendered_value }}</span>
    {% elsif value > 60 %}
    <span style="color: darkorange">{{ rendered_value }}</span>
    {% else %}
    {{ rendered_value }}
    {% endif %}
    ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.last_name, users.first_name, users.id, order_items.count]
  }

  measure: count_distinct {
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [status]
  }

  measure: average {
    type: average
    sql: ${user_id} ;;
  }
}
