{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- elif target.name in ('prod', 'stg') -%}
        {# In prod and stg, use clean schema names without any prefix #}
        {{ custom_schema_name | trim }}
    {%- else -%}
        {# In dev, prefix with the developer's personal schema to avoid conflicts #}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
