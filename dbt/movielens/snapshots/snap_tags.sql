{% snapshot snap_tags %}

{{
    config(
        target_schema='snapshots',
        unique_key=['user_id','movie_id','tag'],
        strategy='timestamp',
        updated_at='tag_timestamp',
        invalidate_hard_deletes=True 
    )
}}

-- invalidate_hard_deletes=True --what this does is that if a row is deleted from the source table, it will be marked as deleted in the snapshot table. If this is set to false, then the row will be kept in the snapshot table even if it is deleted from the source table.

SELECT
{{ dbt_utils.generate_surrogate_key(['user_id','movie_id','tag']) }} AS row_key,
    user_id,
    movie_id,
    tag,
    CAST(tag_timestamp AS TIMESTAMP_NTZ) AS tag_timestamp -- necessary to cast to timestamp_ntz because snowflake stores timestamps as timestamp_ltz by default, which is not compatible with dbt snapshots
FROM {{ ref('src_tags') }}
LIMIT 100 

{% endsnapshot %}