=============================================================

**FOLLOW THESE STEPS CAREFULLY AND READ EVERY COMMENT!**

**YOU DO NOT NEED TO RUN THE COMMENTS IN YOUR SCRIPTS**

=============================================================

**STEP 1: CREATING THE BRONZE LAYER**

**NOTE:**
- **PLEASE RUN THIS QUERY ON THE CORRECT DATABASE (DataWareHouseNovels)**
- **RUN THIS *ONCE* IN THE SQL SERVER**

```sql
/* Bronze layer: every column is text (NVARCHAR(MAX)) so loads never fail on
   length or type. */

-- WARNING: This will drop 'bronze.novelupdates' if it already exists
IF OBJECT_ID('bronze.novelupdates', 'U') IS NOT NULL
    DROP TABLE bronze.novelupdates;

-- This creates a new 'bronze.novelupdates' 
CREATE TABLE bronze.novelupdates (
    novelupdates_id                          NVARCHAR(MAX),
    novelupdates_name                        NVARCHAR(MAX),
    novelupdates_novel_type                  NVARCHAR(MAX),
    novelupdates_cover_url                   NVARCHAR(MAX),
    novelupdates_assoc_names                 NVARCHAR(MAX),
    novelupdates_original_language           NVARCHAR(MAX),
    novelupdates_authors                     NVARCHAR(MAX),
    novelupdates_genres                      NVARCHAR(MAX),
    novelupdates_tags                        NVARCHAR(MAX),
    novelupdates_start_year                  NVARCHAR(MAX),
    novelupdates_licensed                    NVARCHAR(MAX),
    novelupdates_original_publisher          NVARCHAR(MAX),
    novelupdates_english_publisher           NVARCHAR(MAX),
    novelupdates_complete_original           NVARCHAR(MAX),
    novelupdates_chapters_original_current   NVARCHAR(MAX),
    novelupdates_complete_translated         NVARCHAR(MAX),
    novelupdates_release_freq                NVARCHAR(MAX),
    novelupdates_activity_week_rank          NVARCHAR(MAX),
    novelupdates_activity_month_rank         NVARCHAR(MAX),
    novelupdates_activity_all_time_rank      NVARCHAR(MAX),
    novelupdates_on_reading_lists            NVARCHAR(MAX),
    novelupdates_reading_list_month_rank     NVARCHAR(MAX),
    novelupdates_reading_list_all_time_rank  NVARCHAR(MAX),
    novelupdates_rating                      NVARCHAR(MAX),
    novelupdates_rating_votes                NVARCHAR(MAX),
    novelupdates_related_series_ids          NVARCHAR(MAX),
    novelupdates_recommended_series_ids      NVARCHAR(MAX),
    novelupdates_recommendation_list_ids     NVARCHAR(MAX),
    novelupdates_chapter_latest_translated   NVARCHAR(MAX)
);
GO

-- WARNING: This will drop 'bronze.webnovel' if it already exists
IF OBJECT_ID('bronze.webnovel', 'U') IS NOT NULL
    DROP TABLE bronze.webnovel;

-- This creates a new 'bronze.webnovel' 
CREATE TABLE bronze.webnovel (
    webnovel_novel_id                        NVARCHAR(MAX),
    webnovel_url                             NVARCHAR(MAX),
    webnovel_title                           NVARCHAR(MAX),
    webnovel_associated_names                NVARCHAR(MAX),
    webnovel_img_url                         NVARCHAR(MAX),
    webnovel_showtype                        NVARCHAR(MAX),
    webnovel_genres                          NVARCHAR(MAX),
    webnovel_tags                            NVARCHAR(MAX),
    webnovel_description                     NVARCHAR(MAX),
    webnovel_related_series                  NVARCHAR(MAX),
    webnovel_recommendations                 NVARCHAR(MAX),
    webnovel_recommendation_lists            NVARCHAR(MAX),
    webnovel_rating                          NVARCHAR(MAX),
    webnovel_language                        NVARCHAR(MAX),
    webnovel_authors                         NVARCHAR(MAX),
    webnovel_artists                         NVARCHAR(MAX),
    webnovel_year                            NVARCHAR(MAX),
    webnovel_status_coo                      NVARCHAR(MAX),
    webnovel_licensed                        NVARCHAR(MAX),
    webnovel_translated                      NVARCHAR(MAX),
    webnovel_publishers                      NVARCHAR(MAX),
    webnovel_en_pubs                         NVARCHAR(MAX),
    webnovel_release_frequency               NVARCHAR(MAX),
    webnovel_weekly_rank                     NVARCHAR(MAX),
    webnovel_monthly_rank                    NVARCHAR(MAX),
    webnovel_all_time_rank                   NVARCHAR(MAX),
    webnovel_monthly_rank_reading_list       NVARCHAR(MAX),
    webnovel_all_time_rank_reading_list      NVARCHAR(MAX),
    webnovel_total_reading_list_rank         NVARCHAR(MAX),
    webnovel_chapters                        NVARCHAR(MAX)
);
GO
```

**STEP 2: PREPARING THE ".csv" FILES INDIVIDUALLY**

**NOTE:**
- **DO THIS STEP IN THE TERMINAL/BASH FOR BOTH ".csv" FILES**
- **YOU WILL HAVE TO FIND AND REPLACE `"FILEPATH"` WITH WHERE YOU STORED YOUR `".csv"` FILE**
- **YOU WILL HAVE TO REPLACE `NEWNAME.csv` AND `COL_COUNT` WITH:**
  - `novelupdates_clean.csv 29` (for NovelUpdates)
  - `webnovel_clean.csv 30` (for Webnovel)

```bash
# This cleans and prepares the ".csv" file
# Replace "FILEPATH", NEWNAME.csv, and COL_COUNT below:
python3 - "FILEPATH" /tmp/NEWNAME.csv COL_COUNT <<'EOF'
import csv, io, sys
csv.field_size_limit(sys.maxsize)
src, dst, ncols = sys.argv[1], sys.argv[2], int(sys.argv[3])
raw = open(src, 'rb').read().replace(b'\x00', b'')
text = raw.decode('utf-8-sig', errors='replace')
skipped = 0
with open(dst, 'w', newline='', encoding='utf-8') as out:
    w = csv.writer(out, quoting=csv.QUOTE_ALL, lineterminator='\n')
    for i, row in enumerate(csv.reader(io.StringIO(text, newline='')), start=1):
        if i > 1 and len(row) != ncols:
            skipped += 1
            print("skipping record", i, "with", len(row), "fields")
            continue
        w.writerow(row)
print("skipped:", skipped)
EOF

```

**STEP 3: COPY FILES INTO DOCKER CONTAINER AND SET PERMISSIONS**

**NOTE:**
- **DO THIS STEP IN THE TERMINAL/BASH FOR BOTH ".csv" FILES**
- **YOU WILL HAVE TO FIND AND REPLACE `NEWNAME.csv` WITH EITHER `novelupdates_clean.csv` OR `webnovel_clean.csv`**
- THIS WILL NOT WORK IF YOU DO NOT HAVE *sql-express* installed.

```bash
# Copy cleaned file into the container's /tmp directory
docker cp /tmp/NEWNAME.csv sql-express:/tmp/NEWNAME.csv

# Copy cleaned file into the container's /tmp directory
docker exec -u 0 sql-express chmod 644 /tmp/NEWNAME.csv
```

**STEP 4: BULK INSERT DATA INTO THE BRONZE LAYER**

**NOTE: EXECUTE THIS SCRIPT DIRECTLY INSIDE YOUR SQL EDITOR CONNECTED TO SQL SERVER**

```sql
/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

/* Loads the bronze layer from the cleaned CSVs already copied into the container.
   Prerequisite: scripts/stage_csv.sh has been run for each source file.
   Usage:  EXEC bronze.load_bronze;  */

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time       DATETIME,
            @end_time         DATETIME,
            @batch_start_time DATETIME = GETDATE(),
            @batch_end_time   DATETIME = GETDATE(),
            @ts               VARCHAR(20) = FORMAT(GETDATE(), 'yyyyMMdd_HHmmss'),
            @sql              NVARCHAR(MAX);

    BEGIN TRY
        PRINT '=========================================================';
        PRINT 'Loading bronze layer';
        PRINT '=========================================================';

        ---------------------------------------------------------------
        -- this loads novelupdates
        ---------------------------------------------------------------
        PRINT '---------------------------------------------------------';
        PRINT 'Loading novelupdates table';
        PRINT '---------------------------------------------------------';

        SET @start_time = GETDATE();

        PRINT ' >> Truncating Table: bronze.novelupdates';
        TRUNCATE TABLE bronze.novelupdates;

        PRINT ' >> Inserting Data Into: bronze.novelupdates';
        SET @sql = 'BULK INSERT bronze.novelupdates
            FROM ''/tmp/novelupdates_clean.csv''
            WITH (
                FORMAT = ''CSV'',
                FIRSTROW = 2,
                FIELDQUOTE = ''"'',
                ERRORFILE = ''/tmp/novelupdates_err_' + @ts + '.log'',
                TABLOCK
            );';
        EXEC (@sql);

        SET @end_time = GETDATE();
        PRINT ' >> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';

        ---------------------------------------------------------------
        -- this loads webnovel
        ---------------------------------------------------------------
        PRINT '---------------------------------------------------------';
        PRINT 'Loading webnovel table';
        PRINT '---------------------------------------------------------';

        SET @start_time = GETDATE();

        PRINT ' >> Truncating Table: bronze.webnovel';
        TRUNCATE TABLE bronze.webnovel;

        PRINT ' >> Inserting Data Into: bronze.webnovel';
        SET @sql = 'BULK INSERT bronze.webnovel
            FROM ''/tmp/webnovel_clean.csv''
            WITH (
                FORMAT = ''CSV'',
                FIRSTROW = 2,
                FIELDQUOTE = ''"'',
                ERRORFILE = ''/tmp/webnovel_err_' + @ts + '.log'',
                TABLOCK
            );';
        EXEC (@sql);

        SET @end_time = GETDATE();
        PRINT ' >> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';

        ---------------------------------------------------------------
        SET @batch_end_time = GETDATE();
        PRINT '=========================================================';
        PRINT 'Bronze layer load completed';
        PRINT ' >> Total Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds.';
        PRINT '=========================================================';
    END TRY

    BEGIN CATCH
        PRINT '=========================================================';
        PRINT 'Error occurred during loading bronze layer';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number:  ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State:   ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=========================================================';
        THROW;  -- re-raise so callers/schedulers see the failure
    END CATCH
END
GO

EXEC bronze.load_bronze;
GO
```

**STEP 5: VERIFICATION**

**NOTE:**
- **EXECUTE THIS SCRIPT DIRECTLY INSIDE YOUR SQL EDITOR CONNECTED TO SQL SERVER**
- **FIND AND REPLACE `TABLE` WITH EITHER `bronze.novelupdates` OR `bronze.webnovel`**
- **THIS STEP WILL ALLOW YOU TO VIEW THE DATASET INSIDE YOUR SQL SERVER**

```sql
SELECT *
FROM TABLE
```


