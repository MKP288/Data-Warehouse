=============================================================

**FOLLOW THESE STEPS CAREFULLY AND READ EVERY COMMENT!**

**YOU DO NOT NEED TO RUN THE COMMENTS IN YOUR SCRIPTS**

=============================================================

**STEP 1: CREATING THE SILVER LAYER**

**NOTE:**
- **PLEASE RUN THIS QUERY ON THE CORRECT DATABASE (DataWareHouseNovels)**
- **RUN THIS *ONCE* IN THE SQL SERVER**
- THIS RENAMES AND REORGANIZES THE HEADERS 
- CREATED A NEW HEADER IN 'silver.webnovel' called 'wn_com_ori'

```sql
/* Silver layer: every column is text (NVARCHAR(MAX)) so loads never fail on
   length or type. */

-- WARNING: This will drop 'silver.novelupdates' if it already exists
IF OBJECT_ID('silver.novelupdates', 'U') IS NOT NULL
    DROP TABLE silver.novelupdates;

-- This creates a new 'silver.novelupdates' 
CREATE TABLE silver.novelupdates (
    nu_name                                  NVARCHAR(MAX),
    nu_type                                  NVARCHAR(MAX),
    nu_ori_lang                              NVARCHAR(MAX),
    nu_genres                                NVARCHAR(MAX),
    nu_tags                                  NVARCHAR(MAX),
    nu_st_year                               NVARCHAR(MAX),
    nu_licen                                 NVARCHAR(MAX),
    nu_ori_pub                               NVARCHAR(MAX),
    nu_en_pub                                NVARCHAR(MAX),
    nu_com_ori                               NVARCHAR(MAX),
    nu_chap_cur                              NVARCHAR(MAX),
    nu_rel_freq                              NVARCHAR(MAX),
    nu_act_w_rank                            NVARCHAR(MAX),
    nu_act_m_rank                            NVARCHAR(MAX),
    nu_act_at_rank                           NVARCHAR(MAX),
    nu_rat                                   NVARCHAR(MAX),
);
GO

-- WARNING: This will drop 'silver.webnovel' if it already exists
IF OBJECT_ID('silver.webnovel', 'U') IS NOT NULL
    DROP TABLE silver.webnovel;

-- This creates a new 'silver.webnovel' 
CREATE TABLE silver.webnovel (
    wn_name                                  NVARCHAR(MAX),
    wn_type                                  NVARCHAR(MAX),
    wn_ori_lang                              NVARCHAR(MAX),
    wn_genres                                NVARCHAR(MAX),
    wn_tags                                  NVARCHAR(MAX),
    wn_st_year                               NVARCHAR(MAX),
    wn_licen                                 NVARCHAR(MAX),
    wn_ori_pub                               NVARCHAR(MAX),
    wn_en_pub                                NVARCHAR(MAX),
    wn_com_ori                               NVARCHAR(MAX),
    wn_chap_cur                              NVARCHAR(MAX),
    wn_rel_freq                              NVARCHAR(MAX),
    wn_act_w_rank                            NVARCHAR(MAX),
    wn_act_m_rank                            NVARCHAR(MAX),
    wn_act_at_rank                           NVARCHAR(MAX),
    wn_rat                                   NVARCHAR(MAX),
);
GO
```
