{% macro generate_database_name(custom_database_name=none, node=none) -%}
    {%- if target.name == 'prod' -%}
        cat_demo_prod
    {%- elif target.name == 'stg' -%}
        cat_demo_stg
    {%- else -%}
        cat_demo_dev
    {%- endif -%}
{%- endmacro %}
