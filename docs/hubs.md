Hubs are one of the core building blocks of a Data Vault. 

In general, they consist of 4 columns: 

1. A primary key (or surrogate key) which is usually a hashed representation of the natural key (also known as the business key).

2. The natural key itself. This is usually a formal identification for the record such as a customer ID or order number.

3. The load date or load date timestamp. This identifies when the record was first loaded into the vault.

4. The source for the record. (i.e. ```STG_CUSTOMER``` from the [previous section](staging.md#adding-the-footer))

### Creating model header

Create a new dbt model as before. We'll call this one 'hub_customer'. 

The following header will be appropriate, but feel free to customise it to your needs:

```hub_customer.sql```
```sql
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='hub') -}}

```

An incremental materialisation will optimize our load in cases where the target table (in this case, ```hub_customer```)
already exists and already contains data. This is very important for tables containing a lot of data, where every ounce 
of optimisation counts. 

[Read more about incremental models](https://docs.getdbt.com/docs/configuring-incremental-models)

!!! note "Dont worry!" 
    The [hub_template](macros.md#hub_template) will deal with the filtering of records and ensuring all of the Data Vault
    2.0 standards are upheld when loading into the hub from the source. We won't need to worry about unwanted duplicates.
    
### Adding the metadata

Let's look at the metadata we need to provide to the [hub_template](macros.md#hub_template) macro.

#### Source columns

Using our knowledge of what columns we need in our  ```hub_customer``` table, we can identify which columns in our
staging layer we will need:

1. We need a primary key, which is a hashed natural key. The ```CUSTOMER_PK``` we created is a perfect fit.
2. We also need the natural key itself, ```CUSTOMER_ID``` which we added using the [add_columns](macros.md#add_columns) macro.
3. A load date timestamp is needed, which we also added to the staging layer as ```LOADDATE``` 
4. We also added a ```SOURCE``` column.

We can now add this metadata to the model:

```hub_customer.sql```
```sql
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='hub') -}}

{%- set src_pk = 'CUSTOMER_PK'                                                      -%}
{%- set src_nk = 'CUSTOMER_ID'                                                      -%}
{%- set src_ldts = 'LOADDATE'                                                       -%}
{%- set src_source = 'SOURCE'                                                       -%}

```

#### Target columns

Now we can define the target column mapping. The [hub_template](macros.md#hub_template) does a lot of work for us if we
provide the metadata it requires. We can define which source columns map to the required target columns and also 
define a column type at the same time:

```hub_customer.sql```
```sql 
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='hub') -}}

{%- set src_pk = 'CUSTOMER_PK'                                                      -%}
{%- set src_nk = 'CUSTOMER_ID'                                                      -%}
{%- set src_ldts = 'LOADDATE'                                                       -%}
{%- set src_source = 'SOURCE'                                                       -%}

{%- set tgt_cols = [src_pk, src_nk, src_ldts, src_source]                           -%}

{%- set tgt_pk = [src_pk, 'BINARY(16)', src_pk]                                     -%}
{%- set tgt_nk = [src_nk, 'VARCHAR(38)', src_nk]                                    -%}
{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                                     -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                        -%}

```

With these 5 additional lines, we have now informed the macro how to transform our source data:

- On line 8, we have written the 4 columns we worked out earlier to define exactly what source columns
we are using and what order we want them in. We have used the variable references to avoid writing the columns again.
- On the remaining lines we have provided our mapping from source to target. We don't want to change the names of the
columns, so we have used the source column reference on both sides.
- We have provided a type in the mapping so that the type is explicitly defined. 

!!! info
    There is nothing to stop you entering incorrect type mappings in this step, so please ensure they are correct.
    You will soon find out, however, as dbt will issue a warning to you. No harm done, but save time by providing 
    accurate metadata!
    

!!! question "Why is ```tgt_cols``` needed?"
    In future releases, we hope to eliminate the need to duplicate the source columns as shown on line 8. 
    
    For now, this is a necessary evil. 

#### Source table

The last piece of metadata we need is the source table. This step is easy, as in this example we created the 
new staging layer ourselves. All we need to do is provide a reference to the model we created, and dbt will do the rest for us.
dbt ensures dependencies are honoured when defining the source using a reference in this way.

[Read more about the ref function](https://docs.getdbt.com/docs/ref)

```hub_customer.sql```

```sql 
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='hub') -}}
                                                                                    
{%- set src_pk = 'CUSTOMER_PK'                                                      -%}
{%- set src_nk = 'CUSTOMER_ID'                                                      -%}
{%- set src_ldts = 'LOADDATE'                                                       -%}
{%- set src_source = 'SOURCE'                                                       -%}
                                                                                    
{%- set tgt_cols = [src_pk, src_nk, src_ldts, src_source]                           -%}
                                                                                    
{%- set tgt_pk = [src_pk, 'BINARY(16)', src_pk]                                     -%}
{%- set tgt_nk = [src_nk, 'VARCHAR(38)', src_nk]                                    -%}
{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                                     -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                        -%}
                                                                                    
{%- set source = [ref('stg_customer_hashed')]                                       -%}
```

### Invoking the template 

Now we bring it all together and call the [hub_template](macros.md#hub_template) macro:

```hub_customer.sql```                                                                 
                                                                                       
```sql                                                                                 
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='hub') -}}
                                                                                       
{%- set src_pk = 'CUSTOMER_PK'                                                      -%}
{%- set src_nk = 'CUSTOMER_ID'                                                      -%}
{%- set src_ldts = 'LOADDATE'                                                       -%}
{%- set src_source = 'SOURCE'                                                       -%}
                                                                                       
{%- set tgt_cols = [src_pk, src_nk, src_ldts, src_source]                           -%}
                                                                                       
{%- set tgt_pk = [src_pk, 'BINARY(16)', src_pk]                                     -%}
{%- set tgt_nk = [src_nk, 'VARCHAR(38)', src_nk]                                    -%}
{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                                     -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                        -%}
                                                                                       
{%- set source = [ref('stg_customer_hashed')]                                       -%}
                                                                                       
{{ dbtvault.hub_template(src_pk, src_nk, src_ldts, src_source,                         
                         tgt_cols, tgt_pk, tgt_nk, tgt_ldts, tgt_source,               
                         source)                                                     }}
```                                                                                    

### Running dbt

With our model complete, we can run dbt to create our ```hub_customer``` hub.

```dbt run --models +hub_customer```

!!! tip
    The '+' in the command above will cause dbt to also compile and run all parent dependencies for the model we are 
    running, in this case, it will re-create the staging layer from the ```stg_customer_hashed``` model if needed.

And our table will look like this:

| CUSTOMER_PK                      | CUSTOMER_ID  | LOADDATE   | SOURCE       |
| -------------------------------- | ------------ | ---------- | ------------ |
| B8C37E33DEFDE51CF91E1E03E51657DA | 1001         | 1993-01-01 | STG_CUSTOMER |
|               .                  | .            | .          | .            |
|               .                  | .            | .          | .            |
| FED33392D3A48AA149A87A38B875BA4A | 1004         | 1993-01-01 | STG_CUSTOMER |


### Next steps

We have now created a staging layer and a hub. Next we will look at Links, which are created in a similar way.

Click next below!