select
    id                                      as store_id,
    name                                    as store_name,
    city,
    state_code,
    country,
    opened_at,
    'pos'                                   as _source,
    current_timestamp()                     as _ingested_at,
    _metadata.file_path                     as _metadata_file_path,
    _metadata.file_modification_time        as _metadata_file_modified_at
from {{ source('pos_raw', 'stores') }}
