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

**STEP 3: HELPERS**
```
/*
===============================================================================
Functions: Silver Layer Helpers
===============================================================================
Script Purpose:
    silver.fn_fix_mojibake - repairs garbled characters (e.g. "ΓÇÖ" -> "’")
    silver.fn_join_key     - lowercase, letters and digits only; used for joining
===============================================================================
*/

CREATE OR ALTER FUNCTION silver.fn_fix_mojibake (@t NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        @t COLLATE Latin1_General_100_BIN2,
        N'ΓÇÖ', N'’'),   -- right single quote / apostrophe
        N'ΓÇÿ', N'‘'),   -- left single quote
        N'ΓÇô', N'–'),   -- en dash
        N'ΓÇö', N'—'),   -- em dash
        N'ΓÇ£', N'“'),   -- left double quote
        N'ΓÇ¥', N'”'),   -- right double quote
        N'ΓÇª', N'…'),   -- ellipsis
        N'┬Ñ',  N'¥'),   -- yen
        N'├⌐',  N'é'),
        N'├¿',  N'è'),
        N'├í',  N'á'),
        N'├▒',  N'ñ'),
        N'├╢',  N'ö'),
        N'├╝',  N'ü'),
        N'├ù',  N'×');
END;
GO

CREATE OR ALTER FUNCTION silver.fn_join_key (@t NVARCHAR(MAX))
RETURNS NVARCHAR(500)
AS
BEGIN
    DECLARE @r NVARCHAR(MAX) = LOWER(@t);
    DECLARE @pos INT = PATINDEX(N'%[^a-z0-9]%' COLLATE Latin1_General_100_BIN2, @r);

    WHILE @pos > 0
    BEGIN
        SET @r = STUFF(@r, @pos, 1, N'');
        SET @pos = PATINDEX(N'%[^a-z0-9]%' COLLATE Latin1_General_100_BIN2, @r);
    END;

    RETURN NULLIF(LEFT(@r, 500), N'');
END;
GO
```

**STEP 4: TRANSFORMING TO SILVER**
sql
```
/*
===============================================================================
Stored Procedure: Transform Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure transforms data from the 'bronze' schema into the
    'silver' schema. It performs the following actions:
    - Truncates the silver tables before loading data.
    - Repairs garbled characters in text columns (silver.fn_fix_mojibake).
    - Builds the join key columns nu_key / wn_key (silver.fn_join_key).

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Prerequisite:
    - bronze layer loaded (EXEC bronze.load_bronze;)
    - silver tables created
    - silver.fn_fix_mojibake and silver.fn_join_key created

Usage Example:
    EXEC silver.transform_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.transform_silver AS
BEGIN
    DECLARE @start_time       DATETIME,
            @end_time         DATETIME,
            @batch_start_time DATETIME = GETDATE(),
            @batch_end_time   DATETIME = GETDATE();

    BEGIN TRY
        PRINT '=========================================================';
        PRINT 'Transforming silver layer';
        PRINT '=========================================================';

        ---------------------------------------------------------------
        -- this transforms novelupdates
        ---------------------------------------------------------------
        PRINT '---------------------------------------------------------';
        PRINT 'Transforming novelupdates table';
        PRINT '---------------------------------------------------------';

        SET @start_time = GETDATE();

        PRINT ' >> Truncating Table: silver.novelupdates';
        TRUNCATE TABLE silver.novelupdates;

        PRINT ' >> Inserting Data Into: silver.novelupdates';
        INSERT INTO silver.novelupdates (
            nu_name, nu_type, nu_ori_lang, nu_genres, nu_tags, nu_st_year, nu_licen,
            nu_ori_pub, nu_en_pub, nu_com_ori, nu_chap_cur, nu_rel_freq,
            nu_act_w_rank, nu_act_m_rank, nu_act_at_rank, nu_rat)
        SELECT
            silver.fn_fix_mojibake(b.novelupdates_name),
            silver.fn_fix_mojibake(b.novelupdates_novel_type),
            silver.fn_fix_mojibake(b.novelupdates_original_language),
            silver.fn_fix_mojibake(b.novelupdates_genres),
            silver.fn_fix_mojibake(b.novelupdates_tags),
            b.novelupdates_start_year,
            b.novelupdates_licensed,
            silver.fn_fix_mojibake(b.novelupdates_original_publisher),
            silver.fn_fix_mojibake(b.novelupdates_english_publisher),
            b.novelupdates_complete_original,
            b.novelupdates_chapters_original_current,
            b.novelupdates_release_freq,
            b.novelupdates_activity_week_rank,
            b.novelupdates_activity_month_rank,
            b.novelupdates_activity_all_time_rank,
            b.novelupdates_rating
        FROM bronze.novelupdates AS b;

        PRINT ' >> Building Join Key: silver.novelupdates';
        UPDATE silver.novelupdates SET nu_key = silver.fn_join_key(nu_name);

        SET @end_time = GETDATE();
        PRINT ' >> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';

        ---------------------------------------------------------------
        -- this transforms webnovel
        ---------------------------------------------------------------
        PRINT '---------------------------------------------------------';
        PRINT 'Transforming webnovel table';
        PRINT '---------------------------------------------------------';

        SET @start_time = GETDATE();

        PRINT ' >> Truncating Table: silver.webnovel';
        TRUNCATE TABLE silver.webnovel;

        PRINT ' >> Inserting Data Into: silver.webnovel';
        INSERT INTO silver.webnovel (
            wn_name, wn_type, wn_ori_lang, wn_genres, wn_tags, wn_st_year, wn_licen,
            wn_ori_pub, wn_en_pub, wn_com_ori, wn_chap_cur, wn_rel_freq,
            wn_act_w_rank, wn_act_m_rank, wn_act_at_rank, wn_rat)
        SELECT
            silver.fn_fix_mojibake(b.webnovel_title),
            silver.fn_fix_mojibake(b.webnovel_showtype),
            silver.fn_fix_mojibake(b.webnovel_language),
            silver.fn_fix_mojibake(b.webnovel_genres),
            silver.fn_fix_mojibake(b.webnovel_tags),
            b.webnovel_year,
            b.webnovel_licensed,
            silver.fn_fix_mojibake(b.webnovel_publishers),
            silver.fn_fix_mojibake(b.webnovel_en_pubs),
            b.webnovel_status_coo,
            b.webnovel_chapters,
            b.webnovel_release_frequency,
            b.webnovel_weekly_rank,
            b.webnovel_monthly_rank,
            b.webnovel_all_time_rank,
            b.webnovel_rating
        FROM bronze.webnovel AS b;

        PRINT ' >> Building Join Key: silver.webnovel';
        UPDATE silver.webnovel SET wn_key = silver.fn_join_key(wn_name);

        SET @end_time = GETDATE();
        PRINT ' >> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';

        ---------------------------------------------------------------
        SET @batch_end_time = GETDATE();
        PRINT '=========================================================';
        PRINT 'Silver layer transform completed';
        PRINT ' >> Total Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds.';
        PRINT '=========================================================';
    END TRY

    BEGIN CATCH
        PRINT '=========================================================';
        PRINT 'Error occurred during transforming silver layer';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number:  ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State:   ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=========================================================';
        THROW;  -- re-raise so callers/schedulers see the failure
    END CATCH
END
GO

EXEC silver.transform_silver;
GO
```
