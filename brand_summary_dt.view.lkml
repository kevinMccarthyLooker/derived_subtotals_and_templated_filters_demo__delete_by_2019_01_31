view: brand_summary_dt {
  derived_table: {
    sql:
/* You can quickly gather the totals you want and the possible fields that might be filtered that need to be */
/* considered in the summary... Use the main explore by adding all filters and setting to is not null */
/* then come here and paste the sql.  Adjust as necessary to get one row per object at the summary level you need*/
/* then substitute the {  % condition dimension_name %} database_field {   % endcondition %} for each filterable field*/
/* for example */
SELECT
  brand,
  COALESCE(SUM(order_items.sale_price ), 0) AS brand_total_sales
FROM public.order_items  AS order_items
LEFT JOIN public.users  AS users ON order_items.user_id = users.id
LEFT JOIN public.inventory_items  AS inventory_items ON order_items.inventory_item_id = inventory_items.id
LEFT JOIN public.products  AS products ON inventory_items.product_id = products.id

WHERE
/* paramterized filters go here */
--  (NOT (order_items.id  IS NULL)) AND
  {% condition order_items.id %}order_items.id{% endcondition %} AND
--  (order_items.created_at  IS NOT NULL) AND
  {% condition order_items.created_date %}order_items.created_at{% endcondition %} AND
--  (order_items.delivered_at  IS NOT NULL) AND
  {% condition order_items.delivered_date %}order_items.delivered_at{% endcondition %} AND
--  (NOT (users.age  IS NULL))
  {% condition users.age %}users.age{% endcondition %}

GROUP BY 1
    ;;
  }

  dimension: brand {
    primary_key: yes
    hidden: yes
  }
  dimension: brand_total_sales {
    description: "derived total for brand"
    type: number
  }
  measure: total_sales2 {
    label: "Total Sales (Per Brand)"
    description: "calculated from brand_totals"
    type: sum
    sql: ${brand_total_sales} ;;
  }

  measure: row_total_ratio_to_brand_summary_total {
    type: number
    sql: ${order_items.total_sales}*1.0/nullif(${total_sales2},0) ;;
    value_format_name: decimal_3
  }


  dimension: brand_type {
    type: string
    case: {
      when: {sql:${brand}='180s' or ${brand}='7 For All Mankind';; label: "preferred"}
      else: "non-preferred"
    }
  }

}
