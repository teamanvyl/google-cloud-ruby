# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


module Google
  module Privacy
    module Dlp
      module V2
        # Type of information detected by the API.
        # @!attribute [rw] name
        #   @return [String]
        #     Name of the information type. Either a name of your choosing when
        #     creating a CustomInfoType, or one of the names listed
        #     at https://cloud.google.com/dlp/docs/infotypes-reference when specifying
        #     a built-in type. InfoType names should conform to the pattern
        #     [a-zA-Z0-9_]\\{1,64}.
        class InfoType; end

        # A reference to a StoredInfoType to use with scanning.
        # @!attribute [rw] name
        #   @return [String]
        #     Resource name of the requested `StoredInfoType`, for example
        #     `organizations/433245324/storedInfoTypes/432452342` or
        #     `projects/project-id/storedInfoTypes/432452342`.
        # @!attribute [rw] create_time
        #   @return [Google::Protobuf::Timestamp]
        #     Timestamp indicating when the version of the `StoredInfoType` used for
        #     inspection was created. Output-only field, populated by the system.
        class StoredType; end

        # Custom information type provided by the user. Used to find domain-specific
        # sensitive information configurable to the data in question.
        # @!attribute [rw] info_type
        #   @return [Google::Privacy::Dlp::V2::InfoType]
        #     CustomInfoType can either be a new infoType, or an extension of built-in
        #     infoType, when the name matches one of existing infoTypes and that infoType
        #     is specified in `InspectContent.info_types` field. Specifying the latter
        #     adds findings to the one detected by the system. If built-in info type is
        #     not specified in `InspectContent.info_types` list then the name is treated
        #     as a custom info type.
        # @!attribute [rw] likelihood
        #   @return [Google::Privacy::Dlp::V2::Likelihood]
        #     Likelihood to return for this CustomInfoType. This base value can be
        #     altered by a detection rule if the finding meets the criteria specified by
        #     the rule. Defaults to `VERY_LIKELY` if not specified.
        # @!attribute [rw] dictionary
        #   @return [Google::Privacy::Dlp::V2::CustomInfoType::Dictionary]
        #     A list of phrases to detect as a CustomInfoType.
        # @!attribute [rw] regex
        #   @return [Google::Privacy::Dlp::V2::CustomInfoType::Regex]
        #     Regular expression based CustomInfoType.
        # @!attribute [rw] surrogate_type
        #   @return [Google::Privacy::Dlp::V2::CustomInfoType::SurrogateType]
        #     Message for detecting output from deidentification transformations that
        #     support reversing.
        # @!attribute [rw] stored_type
        #   @return [Google::Privacy::Dlp::V2::StoredType]
        #     Load an existing `StoredInfoType` resource for use in
        #     `InspectDataSource`. Not currently supported in `InspectContent`.
        # @!attribute [rw] detection_rules
        #   @return [Array<Google::Privacy::Dlp::V2::CustomInfoType::DetectionRule>]
        #     Set of detection rules to apply to all findings of this CustomInfoType.
        #     Rules are applied in order that they are specified. Not supported for the
        #     `surrogate_type` CustomInfoType.
        # @!attribute [rw] exclusion_type
        #   @return [Google::Privacy::Dlp::V2::CustomInfoType::ExclusionType]
        #     If set to EXCLUSION_TYPE_EXCLUDE this infoType will not cause a finding
        #     to be returned. It still can be used for rules matching.
        class CustomInfoType
          # Custom information type based on a dictionary of words or phrases. This can
          # be used to match sensitive information specific to the data, such as a list
          # of employee IDs or job titles.
          #
          # Dictionary words are case-insensitive and all characters other than letters
          # and digits in the unicode [Basic Multilingual
          # Plane](https://en.wikipedia.org/wiki/Plane_%28Unicode%29#Basic_Multilingual_Plane)
          # will be replaced with whitespace when scanning for matches, so the
          # dictionary phrase "Sam Johnson" will match all three phrases "sam johnson",
          # "Sam, Johnson", and "Sam (Johnson)". Additionally, the characters
          # surrounding any match must be of a different type than the adjacent
          # characters within the word, so letters must be next to non-letters and
          # digits next to non-digits. For example, the dictionary word "jen" will
          # match the first three letters of the text "jen123" but will return no
          # matches for "jennifer".
          #
          # Dictionary words containing a large number of characters that are not
          # letters or digits may result in unexpected findings because such characters
          # are treated as whitespace. The
          # [limits](https://cloud.google.com/dlp/limits) page contains details about
          # the size limits of dictionaries. For dictionaries that do not fit within
          # these constraints, consider using `LargeCustomDictionaryConfig` in the
          # `StoredInfoType` API.
          # @!attribute [rw] word_list
          #   @return [Google::Privacy::Dlp::V2::CustomInfoType::Dictionary::WordList]
          #     List of words or phrases to search for.
          # @!attribute [rw] cloud_storage_path
          #   @return [Google::Privacy::Dlp::V2::CloudStoragePath]
          #     Newline-delimited file of words in Cloud Storage. Only a single file
          #     is accepted.
          class Dictionary
            # Message defining a list of words or phrases to search for in the data.
            # @!attribute [rw] words
            #   @return [Array<String>]
            #     Words or phrases defining the dictionary. The dictionary must contain
            #     at least one phrase and every phrase must contain at least 2 characters
            #     that are letters or digits. [required]
            class WordList; end
          end

          # Message defining a custom regular expression.
          # @!attribute [rw] pattern
          #   @return [String]
          #     Pattern defining the regular expression. Its syntax
          #     (https://github.com/google/re2/wiki/Syntax) can be found under the
          #     google/re2 repository on GitHub.
          # @!attribute [rw] group_indexes
          #   @return [Array<Integer>]
          #     The index of the submatch to extract as findings. When not
          #     specified, the entire match is returned. No more than 3 may be included.
          class Regex; end

          # Message for detecting output from deidentification transformations
          # such as
          # [`CryptoReplaceFfxFpeConfig`](https://cloud.google.com/dlp/docs/reference/rest/v2/organizations.deidentifyTemplates#cryptoreplaceffxfpeconfig).
          # These types of transformations are
          # those that perform pseudonymization, thereby producing a "surrogate" as
          # output. This should be used in conjunction with a field on the
          # transformation such as `surrogate_info_type`. This CustomInfoType does
          # not support the use of `detection_rules`.
          class SurrogateType; end

          # Rule for modifying a CustomInfoType to alter behavior under certain
          # circumstances, depending on the specific details of the rule. Not supported
          # for the `surrogate_type` custom info type.
          # @!attribute [rw] hotword_rule
          #   @return [Google::Privacy::Dlp::V2::CustomInfoType::DetectionRule::HotwordRule]
          #     Hotword-based detection rule.
          class DetectionRule
            # Message for specifying a window around a finding to apply a detection
            # rule.
            # @!attribute [rw] window_before
            #   @return [Integer]
            #     Number of characters before the finding to consider.
            # @!attribute [rw] window_after
            #   @return [Integer]
            #     Number of characters after the finding to consider.
            class Proximity; end

            # Message for specifying an adjustment to the likelihood of a finding as
            # part of a detection rule.
            # @!attribute [rw] fixed_likelihood
            #   @return [Google::Privacy::Dlp::V2::Likelihood]
            #     Set the likelihood of a finding to a fixed value.
            # @!attribute [rw] relative_likelihood
            #   @return [Integer]
            #     Increase or decrease the likelihood by the specified number of
            #     levels. For example, if a finding would be `POSSIBLE` without the
            #     detection rule and `relative_likelihood` is 1, then it is upgraded to
            #     `LIKELY`, while a value of -1 would downgrade it to `UNLIKELY`.
            #     Likelihood may never drop below `VERY_UNLIKELY` or exceed
            #     `VERY_LIKELY`, so applying an adjustment of 1 followed by an
            #     adjustment of -1 when base likelihood is `VERY_LIKELY` will result in
            #     a final likelihood of `LIKELY`.
            class LikelihoodAdjustment; end

            # The rule that adjusts the likelihood of findings within a certain
            # proximity of hotwords.
            # @!attribute [rw] hotword_regex
            #   @return [Google::Privacy::Dlp::V2::CustomInfoType::Regex]
            #     Regular expression pattern defining what qualifies as a hotword.
            # @!attribute [rw] proximity
            #   @return [Google::Privacy::Dlp::V2::CustomInfoType::DetectionRule::Proximity]
            #     Proximity of the finding within which the entire hotword must reside.
            #     The total length of the window cannot exceed 1000 characters. Note that
            #     the finding itself will be included in the window, so that hotwords may
            #     be used to match substrings of the finding itself. For example, the
            #     certainty of a phone number regex "\(\d\\{3}\) \d\\{3}-\d\\{4}" could be
            #     adjusted upwards if the area code is known to be the local area code of
            #     a company office using the hotword regex "\(xxx\)", where "xxx"
            #     is the area code in question.
            # @!attribute [rw] likelihood_adjustment
            #   @return [Google::Privacy::Dlp::V2::CustomInfoType::DetectionRule::LikelihoodAdjustment]
            #     Likelihood adjustment to apply to all matching findings.
            class HotwordRule; end
          end

          module ExclusionType
            # A finding of this custom info type will not be excluded from results.
            EXCLUSION_TYPE_UNSPECIFIED = 0

            # A finding of this custom info type will be excluded from final results,
            # but can still affect rule execution.
            EXCLUSION_TYPE_EXCLUDE = 1
          end
        end

        # General identifier of a data field in a storage service.
        # @!attribute [rw] name
        #   @return [String]
        #     Name describing the field.
        class FieldId; end

        # Datastore partition ID.
        # A partition ID identifies a grouping of entities. The grouping is always
        # by project and namespace, however the namespace ID may be empty.
        #
        # A partition ID contains several dimensions:
        # project ID and namespace ID.
        # @!attribute [rw] project_id
        #   @return [String]
        #     The ID of the project to which the entities belong.
        # @!attribute [rw] namespace_id
        #   @return [String]
        #     If not empty, the ID of the namespace to which the entities belong.
        class PartitionId; end

        # A representation of a Datastore kind.
        # @!attribute [rw] name
        #   @return [String]
        #     The name of the kind.
        class KindExpression; end

        # Options defining a data set within Google Cloud Datastore.
        # @!attribute [rw] partition_id
        #   @return [Google::Privacy::Dlp::V2::PartitionId]
        #     A partition ID identifies a grouping of entities. The grouping is always
        #     by project and namespace, however the namespace ID may be empty.
        # @!attribute [rw] kind
        #   @return [Google::Privacy::Dlp::V2::KindExpression]
        #     The kind to process.
        class DatastoreOptions; end

        # Message representing a set of files in a Cloud Storage bucket. Regular
        # expressions are used to allow fine-grained control over which files in the
        # bucket to include.
        #
        # Included files are those that match at least one item in `include_regex` and
        # do not match any items in `exclude_regex`. Note that a file that matches
        # items from both lists will _not_ be included. For a match to occur, the
        # entire file path (i.e., everything in the url after the bucket name) must
        # match the regular expression.
        #
        # For example, given the input `{bucket_name: "mybucket", include_regex:
        # ["directory1/.*"], exclude_regex:
        # ["directory1/excluded.*"]}`:
        #
        # * `gs://mybucket/directory1/myfile` will be included
        # * `gs://mybucket/directory1/directory2/myfile` will be included (`.*` matches
        #   across `/`)
        # * `gs://mybucket/directory0/directory1/myfile` will _not_ be included (the
        #   full path doesn't match any items in `include_regex`)
        # * `gs://mybucket/directory1/excludedfile` will _not_ be included (the path
        #   matches an item in `exclude_regex`)
        #
        # If `include_regex` is left empty, it will match all files by default
        # (this is equivalent to setting `include_regex: [".*"]`).
        #
        # Some other common use cases:
        #
        # * `{bucket_name: "mybucket", exclude_regex: [".*\.pdf"]}` will include all
        #   files in `mybucket` except for .pdf files
        # * `{bucket_name: "mybucket", include_regex: ["directory/[^/]+"]}` will
        #   include all files directly under `gs://mybucket/directory/`, without matching
        #   across `/`
        # @!attribute [rw] bucket_name
        #   @return [String]
        #     The name of a Cloud Storage bucket. Required.
        # @!attribute [rw] include_regex
        #   @return [Array<String>]
        #     A list of regular expressions matching file paths to include. All files in
        #     the bucket that match at least one of these regular expressions will be
        #     included in the set of files, except for those that also match an item in
        #     `exclude_regex`. Leaving this field empty will match all files by default
        #     (this is equivalent to including `.*` in the list).
        #
        #     Regular expressions use RE2
        #     [syntax](https://github.com/google/re2/wiki/Syntax); a guide can be found
        #     under the google/re2 repository on GitHub.
        # @!attribute [rw] exclude_regex
        #   @return [Array<String>]
        #     A list of regular expressions matching file paths to exclude. All files in
        #     the bucket that match at least one of these regular expressions will be
        #     excluded from the scan.
        #
        #     Regular expressions use RE2
        #     [syntax](https://github.com/google/re2/wiki/Syntax); a guide can be found
        #     under the google/re2 repository on GitHub.
        class CloudStorageRegexFileSet; end

        # Options defining a file or a set of files within a Google Cloud Storage
        # bucket.
        # @!attribute [rw] file_set
        #   @return [Google::Privacy::Dlp::V2::CloudStorageOptions::FileSet]
        #     The set of one or more files to scan.
        # @!attribute [rw] bytes_limit_per_file
        #   @return [Integer]
        #     Max number of bytes to scan from a file. If a scanned file's size is bigger
        #     than this value then the rest of the bytes are omitted. Only one
        #     of bytes_limit_per_file and bytes_limit_per_file_percent can be specified.
        # @!attribute [rw] bytes_limit_per_file_percent
        #   @return [Integer]
        #     Max percentage of bytes to scan from a file. The rest are omitted. The
        #     number of bytes scanned is rounded down. Must be between 0 and 100,
        #     inclusively. Both 0 and 100 means no limit. Defaults to 0. Only one
        #     of bytes_limit_per_file and bytes_limit_per_file_percent can be specified.
        # @!attribute [rw] file_types
        #   @return [Array<Google::Privacy::Dlp::V2::FileType>]
        #     List of file type groups to include in the scan.
        #     If empty, all files are scanned and available data format processors
        #     are applied. In addition, the binary content of the selected files
        #     is always scanned as well.
        # @!attribute [rw] sample_method
        #   @return [Google::Privacy::Dlp::V2::CloudStorageOptions::SampleMethod]
        # @!attribute [rw] files_limit_percent
        #   @return [Integer]
        #     Limits the number of files to scan to this percentage of the input FileSet.
        #     Number of files scanned is rounded down. Must be between 0 and 100,
        #     inclusively. Both 0 and 100 means no limit. Defaults to 0.
        class CloudStorageOptions
          # Set of files to scan.
          # @!attribute [rw] url
          #   @return [String]
          #     The Cloud Storage url of the file(s) to scan, in the format
          #     `gs://<bucket>/<path>`. Trailing wildcard in the path is allowed.
          #
          #     If the url ends in a trailing slash, the bucket or directory represented
          #     by the url will be scanned non-recursively (content in sub-directories
          #     will not be scanned). This means that `gs://mybucket/` is equivalent to
          #     `gs://mybucket/*`, and `gs://mybucket/directory/` is equivalent to
          #     `gs://mybucket/directory/*`.
          #
          #     Exactly one of `url` or `regex_file_set` must be set.
          # @!attribute [rw] regex_file_set
          #   @return [Google::Privacy::Dlp::V2::CloudStorageRegexFileSet]
          #     The regex-filtered set of files to scan. Exactly one of `url` or
          #     `regex_file_set` must be set.
          class FileSet; end

          # How to sample bytes if not all bytes are scanned. Meaningful only when used
          # in conjunction with bytes_limit_per_file. If not specified, scanning would
          # start from the top.
          module SampleMethod
            SAMPLE_METHOD_UNSPECIFIED = 0

            # Scan from the top (default).
            TOP = 1

            # For each file larger than bytes_limit_per_file, randomly pick the offset
            # to start scanning. The scanned bytes are contiguous.
            RANDOM_START = 2
          end
        end

        # Message representing a set of files in Cloud Storage.
        # @!attribute [rw] url
        #   @return [String]
        #     The url, in the format `gs://<bucket>/<path>`. Trailing wildcard in the
        #     path is allowed.
        class CloudStorageFileSet; end

        # Message representing a single file or path in Cloud Storage.
        # @!attribute [rw] path
        #   @return [String]
        #     A url representing a file or path (no wildcards) in Cloud Storage.
        #     Example: gs://[BUCKET_NAME]/dictionary.txt
        class CloudStoragePath; end

        # Options defining BigQuery table and row identifiers.
        # @!attribute [rw] table_reference
        #   @return [Google::Privacy::Dlp::V2::BigQueryTable]
        #     Complete BigQuery table reference.
        # @!attribute [rw] identifying_fields
        #   @return [Array<Google::Privacy::Dlp::V2::FieldId>]
        #     References to fields uniquely identifying rows within the table.
        #     Nested fields in the format, like `person.birthdate.year`, are allowed.
        # @!attribute [rw] rows_limit
        #   @return [Integer]
        #     Max number of rows to scan. If the table has more rows than this value, the
        #     rest of the rows are omitted. If not set, or if set to 0, all rows will be
        #     scanned. Only one of rows_limit and rows_limit_percent can be specified.
        #     Cannot be used in conjunction with TimespanConfig.
        # @!attribute [rw] rows_limit_percent
        #   @return [Integer]
        #     Max percentage of rows to scan. The rest are omitted. The number of rows
        #     scanned is rounded down. Must be between 0 and 100, inclusively. Both 0 and
        #     100 means no limit. Defaults to 0. Only one of rows_limit and
        #     rows_limit_percent can be specified. Cannot be used in conjunction with
        #     TimespanConfig.
        # @!attribute [rw] sample_method
        #   @return [Google::Privacy::Dlp::V2::BigQueryOptions::SampleMethod]
        # @!attribute [rw] excluded_fields
        #   @return [Array<Google::Privacy::Dlp::V2::FieldId>]
        #     References to fields excluded from scanning. This allows you to skip
        #     inspection of entire columns which you know have no findings.
        class BigQueryOptions
          # How to sample rows if not all rows are scanned. Meaningful only when used
          # in conjunction with either rows_limit or rows_limit_percent. If not
          # specified, scanning would start from the top.
          module SampleMethod
            SAMPLE_METHOD_UNSPECIFIED = 0

            # Scan from the top (default).
            TOP = 1

            # Randomly pick the row to start scanning. The scanned rows are contiguous.
            RANDOM_START = 2
          end
        end

        # Shared message indicating Cloud storage type.
        # @!attribute [rw] datastore_options
        #   @return [Google::Privacy::Dlp::V2::DatastoreOptions]
        #     Google Cloud Datastore options specification.
        # @!attribute [rw] cloud_storage_options
        #   @return [Google::Privacy::Dlp::V2::CloudStorageOptions]
        #     Google Cloud Storage options specification.
        # @!attribute [rw] big_query_options
        #   @return [Google::Privacy::Dlp::V2::BigQueryOptions]
        #     BigQuery options specification.
        # @!attribute [rw] timespan_config
        #   @return [Google::Privacy::Dlp::V2::StorageConfig::TimespanConfig]
        class StorageConfig
          # Configuration of the timespan of the items to include in scanning.
          # Currently only supported when inspecting Google Cloud Storage and BigQuery.
          # @!attribute [rw] start_time
          #   @return [Google::Protobuf::Timestamp]
          #     Exclude files or rows older than this value.
          # @!attribute [rw] end_time
          #   @return [Google::Protobuf::Timestamp]
          #     Exclude files or rows newer than this value.
          #     If set to zero, no upper time limit is applied.
          # @!attribute [rw] timestamp_field
          #   @return [Google::Privacy::Dlp::V2::FieldId]
          #     Specification of the field containing the timestamp of scanned items.
          #     Used for data sources like Datastore or BigQuery.
          #     If not specified for BigQuery, table last modification timestamp
          #     is checked against given time span.
          #     The valid data types of the timestamp field are:
          #     for BigQuery - timestamp, date, datetime;
          #     for Datastore - timestamp.
          #     Datastore entity will be scanned if the timestamp property does not exist
          #     or its value is empty or invalid.
          # @!attribute [rw] enable_auto_population_of_timespan_config
          #   @return [true, false]
          #     When the job is started by a JobTrigger we will automatically figure out
          #     a valid start_time to avoid scanning files that have not been modified
          #     since the last time the JobTrigger executed. This will be based on the
          #     time of the execution of the last run of the JobTrigger.
          class TimespanConfig; end
        end

        # Row key for identifying a record in BigQuery table.
        # @!attribute [rw] table_reference
        #   @return [Google::Privacy::Dlp::V2::BigQueryTable]
        #     Complete BigQuery table reference.
        # @!attribute [rw] row_number
        #   @return [Integer]
        #     Absolute number of the row from the beginning of the table at the time
        #     of scanning.
        class BigQueryKey; end

        # Record key for a finding in Cloud Datastore.
        # @!attribute [rw] entity_key
        #   @return [Google::Privacy::Dlp::V2::Key]
        #     Datastore entity key.
        class DatastoreKey; end

        # A unique identifier for a Datastore entity.
        # If a key's partition ID or any of its path kinds or names are
        # reserved/read-only, the key is reserved/read-only.
        # A reserved/read-only key is forbidden in certain documented contexts.
        # @!attribute [rw] partition_id
        #   @return [Google::Privacy::Dlp::V2::PartitionId]
        #     Entities are partitioned into subsets, currently identified by a project
        #     ID and namespace ID.
        #     Queries are scoped to a single partition.
        # @!attribute [rw] path
        #   @return [Array<Google::Privacy::Dlp::V2::Key::PathElement>]
        #     The entity path.
        #     An entity path consists of one or more elements composed of a kind and a
        #     string or numerical identifier, which identify entities. The first
        #     element identifies a _root entity_, the second element identifies
        #     a _child_ of the root entity, the third element identifies a child of the
        #     second entity, and so forth. The entities identified by all prefixes of
        #     the path are called the element's _ancestors_.
        #
        #     A path can never be empty, and a path can have at most 100 elements.
        class Key
          # A (kind, ID/name) pair used to construct a key path.
          #
          # If either name or ID is set, the element is complete.
          # If neither is set, the element is incomplete.
          # @!attribute [rw] kind
          #   @return [String]
          #     The kind of the entity.
          #     A kind matching regex `__.*__` is reserved/read-only.
          #     A kind must not contain more than 1500 bytes when UTF-8 encoded.
          #     Cannot be `""`.
          # @!attribute [rw] id
          #   @return [Integer]
          #     The auto-allocated ID of the entity.
          #     Never equal to zero. Values less than zero are discouraged and may not
          #     be supported in the future.
          # @!attribute [rw] name
          #   @return [String]
          #     The name of the entity.
          #     A name matching regex `__.*__` is reserved/read-only.
          #     A name must not be more than 1500 bytes when UTF-8 encoded.
          #     Cannot be `""`.
          class PathElement; end
        end

        # Message for a unique key indicating a record that contains a finding.
        # @!attribute [rw] datastore_key
        #   @return [Google::Privacy::Dlp::V2::DatastoreKey]
        # @!attribute [rw] big_query_key
        #   @return [Google::Privacy::Dlp::V2::BigQueryKey]
        # @!attribute [rw] id_values
        #   @return [Array<String>]
        #     Values of identifying columns in the given row. Order of values matches
        #     the order of field identifiers specified in the scanning request.
        class RecordKey; end

        # Message defining the location of a BigQuery table. A table is uniquely
        # identified  by its project_id, dataset_id, and table_name. Within a query
        # a table is often referenced with a string in the format of:
        # `<project_id>:<dataset_id>.<table_id>` or
        # `<project_id>.<dataset_id>.<table_id>`.
        # @!attribute [rw] project_id
        #   @return [String]
        #     The Google Cloud Platform project ID of the project containing the table.
        #     If omitted, project ID is inferred from the API call.
        # @!attribute [rw] dataset_id
        #   @return [String]
        #     Dataset ID of the table.
        # @!attribute [rw] table_id
        #   @return [String]
        #     Name of the table.
        class BigQueryTable; end

        # Message defining a field of a BigQuery table.
        # @!attribute [rw] table
        #   @return [Google::Privacy::Dlp::V2::BigQueryTable]
        #     Source table of the field.
        # @!attribute [rw] field
        #   @return [Google::Privacy::Dlp::V2::FieldId]
        #     Designated field in the BigQuery table.
        class BigQueryField; end

        # An entity in a dataset is a field or set of fields that correspond to a
        # single person. For example, in medical records the `EntityId` might be a
        # patient identifier, or for financial records it might be an account
        # identifier. This message is used when generalizations or analysis must take
        # into account that multiple rows correspond to the same entity.
        # @!attribute [rw] field
        #   @return [Google::Privacy::Dlp::V2::FieldId]
        #     Composite key indicating which field contains the entity identifier.
        class EntityId; end

        # Definitions of file type groups to scan.
        module FileType
          # Includes all files.
          FILE_TYPE_UNSPECIFIED = 0

          # Includes all file extensions not covered by text file types.
          BINARY_FILE = 1

          # Included file extensions:
          #   asc, brf, c, cc, cpp, csv, cxx, c++, cs, css, dart, eml, go, h, hh, hpp,
          #   hxx, h++, hs, html, htm, shtml, shtm, xhtml, lhs, ini, java, js, json,
          #   ocaml, md, mkd, markdown, m, ml, mli, pl, pm, php, phtml, pht, py, pyw,
          #   rb, rbw, rs, rc, scala, sh, sql, tex, txt, text, tsv, vcard, vcs, wml,
          #   xml, xsl, xsd, yml, yaml.
          TEXT_FILE = 2

          # Included file extensions:
          #   bmp, gif, jpg, jpeg, jpe, png.
          # bytes_limit_per_file has no effect on image files.
          IMAGE = 3

          # Included file extensions:
          #   avro
          AVRO = 7
        end

        # Categorization of results based on how likely they are to represent a match,
        # based on the number of elements they contain which imply a match.
        module Likelihood
          # Default value; same as POSSIBLE.
          LIKELIHOOD_UNSPECIFIED = 0

          # Few matching elements.
          VERY_UNLIKELY = 1

          UNLIKELY = 2

          # Some matching elements.
          POSSIBLE = 3

          LIKELY = 4

          # Many matching elements.
          VERY_LIKELY = 5
        end
      end
    end
  end
end