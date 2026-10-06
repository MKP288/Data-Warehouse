=============================================================

**FOLLOW THESE STEPS CAREFULLY AND READ EVERY COMMENT!**

=============================================================

**STEP 1: RUN THE SCRIPT "create_bronze_layer.sql" TO CREATE THE BRONZE LAYER THE SQL SERVER**
```sql
/* Bronze layer: every column is text (NVARCHAR(MAX)) so loads never fail on
   length or type. */
/* WARNING: PLEASE RUN THIS QUERY ON THE CORRECT DATABASE (DataWareHouseNovels) */

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


