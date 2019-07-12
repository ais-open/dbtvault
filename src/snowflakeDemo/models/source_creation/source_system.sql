{{config(enabled=true, materialized='incremental')}}

select
  a.L_ORDERKEY as ORDERKEY,
	a.L_PARTKEY as PARTKEY ,
	a.L_SUPPKEY as SUPPLIERKEY,
	a.L_LINENUMBER as LINENUMBER,
	a.L_QUANTITY as QUANTITY,
	a.L_EXTENDEDPRICE as EXTENDEDPRICE,
	a.L_DISCOUNT as DISCOUNT,
	a.L_TAX as TAX,
	a.L_RETURNFLAG as RETURNFLAG,
	a.L_LINESTATUS as LINESTATUS,
	case when a.L_SHIPDATE > {{var("date")}} then null else a.L_SHIPDATE end as SHIPDATE,
	case when a.L_COMMITDATE > {{var("date")}}  then null else a.L_COMMITDATE end as COMMITDATE,
	case when a.L_RECEIPTDATE > {{var("date")}}  then null else a.L_RECEIPTDATE end as RECEIPTDATE,
	a.L_SHIPINSTRUCT as SHIPINSTRUCT,
	a.L_SHIPMODE as SHIPMODE,
	a.L_COMMENT as LINE_COMMENT,
	b.O_CUSTKEY as CUSTOMERKEY,
	b.O_ORDERSTATUS as ORDERSTATUS,
	b.O_TOTALPRICE as TOTALPRICE,
	b.O_ORDERDATE as ORDERDATE,
	b.O_ORDERPRIORITY as ORDERPRIORITY,
	b.O_CLERK as CLERK,
	b.O_SHIPPRIORITY as SHIPPRIORITY,
	b.O_COMMENT as ORDER_COMMENT,
	c.C_NAME as CUSTOMER_NAME,
	c.C_ADDRESS as CUSTOMER_ADDRESS,
	c.C_NATIONKEY as CUSTOMER_NATIONKEY,
	c.C_PHONE as CUSTOMER_PHONE,
	c.C_ACCTBAL as CUSTOMER_ACCBAL,
	c.C_MKTSEGMENT as CUSTOMER_MKTSEGMENT,
	c.C_COMMENT as CUSTOMER_COMMENT,
	d.N_NAME as CUSTOMER_NATION,
	d.N_REGIONKEY as CUSTOMER_REGIONKEY,
	d.N_COMMENT as CUSTOMER_NATION_COMMENT,
	e.R_NAME as CUSTOMER_REGION_NAME,
	e.R_COMMENT as CUSTOMER_REGION_COMMENT,
	f.PS_AVAILQTY as AVAILQTY,
	f.PS_SUPPLYCOST as SUPPLYCOST,
	f.PS_COMMENT as PARTSUPPLY_COMMENT,
	g.P_NAME as PART_NAME,
	g.P_MFGR as MFGR,
	g.P_BRAND as PART_BRAND,
	g.P_TYPE as PART_TYPE,
	g.P_SIZE as PART_SIZE,
	g.P_CONTAINER as PART_CONTAINER,
	g.P_RETAILPRICE as PART_RETAILPRICE,
	g.P_COMMENT as PART_COMMENT,
	h.S_NAME as SUPPLIER_NAME,
	h.S_ADDRESS as SUPPLIER_ADDRESS,
  h.S_NATIONKEY as SUPPLIER_NATIONKEY,
	h.S_PHONE as SUPPLIER_PHONE,
	h.S_ACCTBAL as SUPPLIER_ACCTBAL,
	h.S_COMMENT as SUPPLIER_COMMENT,
	j.N_NAME as SUPPLIER_NATION_NAME,
	j.N_COMMENT as SUPPLIER_NATION_COMMENT,
	j.N_REGIONKEY as SUPPLIER_REGIONKEY,
	k.R_NAME as SUPPLIER_REGION_NAME,
	k.R_COMMENT as SUPPLIER_REGION_COMMENT
from SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.ORDERS as b
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.LINEITEM as a on a.L_ORDERKEY=b.O_ORDERKEY
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.CUSTOMER as c on b.O_CUSTKEY = c.C_CUSTKEY
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.NATION as d on c.C_NATIONKEY = d.N_NATIONKEY
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.REGION as e on d.N_REGIONKEY = e.R_REGIONKEY
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.PARTSUPP as f on a.L_PARTKEY = f.PS_PARTKEY
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.PART as g on a.L_PARTKEY = g.P_PARTKEY
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.SUPPLIER as h on a.L_SUPPKEY = h.S_SUPPKEY
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.NATION as j on h.S_NATIONKEY = j.N_NATIONKEY
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.REGION as k on j.N_REGIONKEY = k.R_REGIONKEY

{% if is_incremental() %}

where b.O_ORDERDATE between {{var("history_date")}}  and {{var("date")}}

{% else %}

where b.O_ORDERDATE <= {{var("date")}}

{% endif %}

order by b.O_ORDERKEY
limit 20