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

require "helper"

describe Google::Cloud::Bigquery::Convert do
  it "converts nil to nil with no error" do
    t = Google::Cloud::Bigquery::Convert.millis_to_time nil
    t.must_be :nil?
  end

  it "converts time in millis to a Time object with same value in seconds" do
    t = Google::Cloud::Bigquery::Convert.millis_to_time 3333
    t.must_be_kind_of ::Time
    t.to_i.must_equal 3
    t.to_f.must_equal 3.333
  end

  describe :format_value do
    it "converts all floats correctly" do
      float_type = Google::Apis::BigqueryV2::TableFieldSchema.new(type: "FLOAT")

      f = Google::Cloud::Bigquery::Convert.format_value({ v: "3.333" }, float_type)
      f.must_be_kind_of ::Float
      f.must_equal 3.333

      f = Google::Cloud::Bigquery::Convert.format_value({ v: "Infinity" }, float_type)
      f.must_be_kind_of ::Float
      f.must_equal Float::INFINITY

      f = Google::Cloud::Bigquery::Convert.format_value({ v: "-Infinity" }, float_type)
      f.must_be_kind_of ::Float
      f.must_equal -Float::INFINITY

      f = Google::Cloud::Bigquery::Convert.format_value({ v: "NaN" }, float_type)
      f.must_be_kind_of ::Float
      f.must_be :nan?
    end
  end
end
