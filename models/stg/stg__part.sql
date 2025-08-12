
--Stage Part SQL code

{{
    config(
        materialized='table',
        tags='critical',
        cluster_by=['part_id']
    )
}}

with part as (
    select * from {{ ref('snap__part')}} --snapshots/snap__part.sql
),

renamed as (

    select 
        p_partkey as part_id,
        INITCAP(p_name) as name, --Changes to Pascal Case
        p_mfgr as manufacturer_id,
        p_brand as brand,
        p_type as type,
        p_size as size,
        p_container as container,
        p_retailprice as retailprice,
        TRIM(p_comment) as comment --Trims whitespace around comments

    from
        part
    where 
        dbt_valid_to is null
)

select * from renamed