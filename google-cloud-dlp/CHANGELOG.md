# Release History

### 0.10.0 / 2019-06-11

* Add StoredInfoTypeVersion#stats (StoredInfoTypeStats)
* Document start_time and end_time in filters
* Add VERSION constant

### 0.9.1 / 2019-04-29

* Add AUTHENTICATION.md guide.
* Update documentation for common types.

### 0.9.0 / 2019-04-09

* Update V2::DlpServiceClient:
  * Add Add filter optional argument to list_job_triggers
    * Add ListJobTriggersRequest#filter
  * Add activate_job_trigger
    * Add ActivateJobTriggerRequest
* Update V2 classes:
  * Add InfoTypeDescription#description
  * Add Action#job_notification_emails
    * Add Action::JobNotificationEmails class
  * Add CustomInfoType::Regex#group_indexes
  * Add RecordKey#id_values
  * Add FileType::IMAGE enumerated value
* Add CryptoDeterministicConfig
* Add PrimitiveTransformation#crypto_deterministic_config
* Update documented regex to allow underscores in values for template_id, job_id, trigger_id, and stored_info_type_id
* Extract gRPC header values from request
* Update documentation

### 0.8.0 / 2018-11-15

* Add StoredInfoType CRUD+List access methods:
  * DlpServiceClient#create_stored_info_type
  * DlpServiceClient#get_stored_info_type
  * DlpServiceClient#update_stored_info_type
  * DlpServiceClient#delete_stored_info_type
  * DlpServiceClient#list_stored_info_types
* Add BigQueryOptions#excluded_fields value.
* Add order_by argument to DlpServiceClient#list_dlp_jobs
* Add ListDlpJobsRequest#order_by
* Add CloudStorageOptions::FileSet#regex_file_set
  * Returns newly added CloudStorageRegexFileSet object
* Update documentation.

### 0.7.0 / 2018-10-03

* Add order_by argument to the following methods and resources:
  * DlpServiceClient#list_inspect_templates
  * DlpServiceClient#list_deidentify_templates
  * ListInspectTemplatesRequest#order_by
  * ListDeidentifyTemplatesRequest#order_by
  * ListStoredInfoTypesRequest#order_by
* Add InspectConfig#rule_set
  * Add InspectionRuleSet, InspectionRule, ExclusionRule,
    ExcludeInfoTypes, and MatchingType resources.
* Add CustomInfoType#exclusion_type
  * Add ExclusionType resource.
* Update documentation.
* Add new GAPIC config, which is not yet used.

### 0.6.2 / 2018-09-20

* Update documentation.
  * Change documentation URL to googleapis GitHub org.

### 0.6.1 / 2018-09-10

* Update documentation.

### 0.6.0 / 2018-08-21

* Update V2 API.
* Update documentation.

### 0.5.0 / 2018-07-10

* Documentation updates
* Credentials env_vars change

### 0.4.0 / 2018-4-26

* Documentation updates
* row_limit, cscc action
* Dictionaries via GCS
* Entity id in risk stats

### 0.3.0 / 2018-4-11

* Documentation updates
* New IMAGE type

### 0.2.0 / 2018-3-16

* Refreshed alpha release for V2 API compatibility

### 0.1.0 / 2017-12-26

* Initial release
