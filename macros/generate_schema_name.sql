{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- elif default_schema.startswith('dbt_') -%}
        {# Developer schema (e.g. dbt_tgebicke) — prefix to avoid conflicts between devs #}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    {%- else -%}
        {# Environment schema (prod, stg) — use clean layer names: bronze, silver, gold #}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
