# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""This script is used to synthesize generated parts of this library."""

import synthtool as s
import synthtool.gcp as gcp
import synthtool.languages.ruby as ruby
import logging
import os
import re
import subprocess


logging.basicConfig(level=logging.DEBUG)

gapic = gcp.GAPICGenerator()

v1_library = gapic.ruby_library(
    'securitycenter', 'v1',
    artman_output_name='google-cloud-ruby/google-cloud-securitycenter'
)
for path in (v1_library / 'lib/google/cloud/securitycenter/v1').glob('*.rb'):
    os.rename(
        v1_library / 'lib/google/cloud/securitycenter/v1' / path.name,
        v1_library / 'lib/google/cloud/security_center/v1' / path.name
    )
s.copy(v1_library / 'lib/google/cloud/security_center/v1')
s.copy(v1_library / 'lib/google/cloud/security_center/v1.rb')
s.copy(v1_library / 'lib/google/cloud/security_center.rb')
s.copy(v1_library / 'test/google/cloud/security_center/v1')
s.copy(v1_library / 'README.md')
s.copy(v1_library / 'LICENSE')
s.copy(v1_library / '.gitignore')
s.copy(v1_library / '.yardopts')
s.copy(v1_library / 'google-cloud-security_center.gemspec', merge=ruby.merge_gemspec)

# Copy common templates
templates = gcp.CommonTemplates().ruby_library()
s.copy(templates)

# Permanent: rename securitycenter file paths to security_center
s.replace(
    [
        'lib/google/cloud/security_center/**/*.rb',
        'test/**/*.rb'
    ],
    'google/cloud/securitycenter/v1',
    'google/cloud/security_center/v1'
)
s.replace(
    [
        'lib/google/cloud/security_center/**/*.rb',
        'test/**/*.rb'
    ],
    'Google::Cloud::Securitycenter',
    'Google::Cloud::SecurityCenter'
)

# https://github.com/googleapis/gapic-generator/issues/2196
s.replace(
    [
      'README.md',
      'lib/google/cloud/security_center.rb',
      'lib/google/cloud/security_center/v1.rb'
    ],
    '\\[Product Documentation\\]: https://cloud\\.google\\.com/securitycenter\n',
    '[Product Documentation]: https://cloud.google.com/security-command-center/\n')

# https://github.com/googleapis/gapic-generator/issues/2243
s.replace(
    'lib/google/cloud/security_center/*/*_client.rb',
    '(\n\\s+class \\w+Client\n)(\\s+)(attr_reader :\\w+_stub)',
    '\\1\\2# @private\n\\2\\3')

# https://github.com/googleapis/gapic-generator/issues/2279
s.replace(
    'lib/**/*.rb',
    '\\A(((#[^\n]*)?\n)*# (Copyright \\d+|Generated by the protocol buffer compiler)[^\n]+\n(#[^\n]*\n)*\n)([^\n])',
    '\\1\n\\6')

# https://github.com/googleapis/gapic-generator/issues/2323
s.replace(
    [
        'lib/**/*.rb',
        'README.md'
    ],
    'https://github\\.com/GoogleCloudPlatform/google-cloud-ruby',
    'https://github.com/googleapis/google-cloud-ruby'
)
s.replace(
    [
        'lib/**/*.rb',
        'README.md'
    ],
    'https://googlecloudplatform\\.github\\.io/google-cloud-ruby',
    'https://googleapis.github.io/google-cloud-ruby'
)

# https://github.com/googleapis/gapic-generator/issues/2393
s.replace(
    'google-cloud-security_center.gemspec',
    'gem.add_development_dependency "rubocop".*$',
    'gem.add_development_dependency "rubocop", "~> 0.64.0"'
)

s.replace(
    'lib/**/credentials.rb',
    'SECURITYCENTER_',
    'SECURITY_CENTER_'
)

# Require the helpers file
s.replace(
    f'lib/google/cloud/security_center/v1.rb',
    f'require "google/cloud/security_center/v1/security_center_client"',
    '\n'.join([
        f'require "google/cloud/security_center/v1/security_center_client"',
        f'require "google/cloud/security_center/v1/helpers"'
    ])
)

s.replace(
    'google-cloud-security_center.gemspec',
    '"README.md", "LICENSE"',
    '"README.md", "AUTHENTICATION.md", "LICENSE"'
)
s.replace(
    '.yardopts',
    'README.md\n',
    'README.md\nAUTHENTICATION.md\nLICENSE\n'
)

# https://github.com/googleapis/google-cloud-ruby/issues/3058
s.replace(
    'google-cloud-security_center.gemspec',
    '\nGem::Specification.new do',
    'require File.expand_path("../lib/google/cloud/security_center/version", __FILE__)\n\nGem::Specification.new do'
)
s.replace(
    'google-cloud-security_center.gemspec',
    '(gem.version\s+=\s+).\d+.\d+.\d.*$',
    '\\1Google::Cloud::SecurityCenter::VERSION'
)
s.replace(
    'lib/google/cloud/security_center/v1/*_client.rb',
    '(require \".*credentials\"\n)\n',
    '\\1require "google/cloud/security_center/version"\n\n'
)
s.replace(
    'lib/google/cloud/security_center/v1/*_client.rb',
    'Gem.loaded_specs\[.*\]\.version\.version',
    'Google::Cloud::SecurityCenter::VERSION'
)

# Generate the helper methods
subprocess.call('bundle update && bundle exec rake generate_partials', shell=True)

# Exception tests have to check for both custom errors and retry wrapper errors
for version in ['v1']:
    s.replace(
        f'test/google/cloud/security_center/{version}/*_client_test.rb',
        'err = assert_raises Google::Gax::GaxError do',
        f'err = assert_raises Google::Gax::GaxError, CustomTestError_{version} do'
    )

# Deal with weirdness where RunAssetDiscoveryResponse is defined in a separate
# file that doesn't get required properly.
s.replace(
    'lib/google/cloud/security_center/v1/security_center_client.rb',
    '\nrequire "google/cloud/security_center/v1/securitycenter_service_pb"\n',
    '\nrequire "google/cloud/security_center/v1/securitycenter_service_pb"\nrequire "google/cloud/security_center/v1/run_asset_discovery_response_pb"\n'
)
