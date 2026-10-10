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

**STEP 2: LOADING INTO SILVER**
- **PLEASE RUN THIS QUERY ON THE CORRECT DATABASE (DataWareHouseNovels)**
- **RUN THIS *ONCE* IN THE SQL SERVER**

```sql
-- This appends data into 'silver.novelupdates'
INSERT INTO silver.novelupdates (nu_name, nu_type, nu_ori_lang, nu_genres, nu_tags, nu_st_year,
                                nu_licen, nu_ori_pub, nu_en_pub, nu_com_ori, nu_chap_cur, nu_rel_freq,                                                                
                                nu_act_w_rank, nu_act_m_rank, nu_act_at_rank, nu_rat)
SELECT 
    novelupdates_name,
    novelupdates_novel_type,
    novelupdates_original_language,
    novelupdates_genres,
    novelupdates_tags,
    novelupdates_start_year,
    novelupdates_licensed,
    novelupdates_original_publisher,
    novelupdates_english_publisher,
    novelupdates_complete_original,
    novelupdates_chapters_original_current,
    novelupdates_release_freq,
    novelupdates_activity_week_rank,
    novelupdates_activity_month_rank,
    novelupdates_activity_all_time_rank,
    novelupdates_rating
FROM bronze.novelupdates

-- This appends data into 'silver.webnovel'
INSERT INTO silver.webnovel (wn_name, wn_type, wn_ori_lang, wn_genres, wn_tags, wn_st_year,
                                wn_licen, wn_ori_pub, wn_en_pub, wn_chap_cur, wn_rel_freq,                                                                
                                wn_act_w_rank, wn_act_m_rank, wn_act_at_rank, wn_rat)

SELECT 
    webnovel_title,
    Webnovel_showtype,
    webnovel_language,
    webnovel_genres,
    webnovel_tags,
    webnovel_year,
    webnovel_licensed,
    webnovel_publishers,
    webnovel_en_pubs,
    webnovel_status_coo,
    webnovel_release_frequency,
    webnovel_weekly_rank,
    webnovel_monthly_rank,
    webnovel_all_time_rank,
    webnovel_rating
FROM bronze.webnovel
```

