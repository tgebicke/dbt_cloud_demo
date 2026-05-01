{% macro set_column_tags() %}
  {% if execute %}
    {% set pii_columns = model.config.get('meta', {}).get('pii_columns', []) %}
    {% for col_name in pii_columns %}
      {% do run_query(
        "ALTER TABLE " ~ this ~ " ALTER COLUMN `" ~ col_name ~ "` SET TAGS ('pii' = 'true')"
      ) %}
    {% endfor %}
  {% endif %}
  select 'column tags applied' as post_hook_status
{% endmacro %}
