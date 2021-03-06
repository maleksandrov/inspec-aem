# Copyright 2018 Shine Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative './helper'

# Aem class contains checks for AEM instance resource
class Aem < Inspec.resource(1)
  name 'aem'

  desc "
    Custom resource for AEM instance
  "

  def initialize
    conf = read_config
    @client = init_aem_client(conf)

    @params = {}
  end

  def has_login_page?
    result = @client.aem.get_login_page_wait_until_ready(
      _retries:
      {
        max_tries: '60',
        base_sleep_seconds: '2',
        max_sleep_seconds: '2'
      }
    )
    return false unless result.message.eql? 'Login page retrieved'
  end

  def has_no_login_page?
    result = @client.aem.get_login_page
    return true unless result.message.eql? 'Login page retrieved'
  end

  def has_crxde_enabled?
    result = @client.aem.get_crxde_status
    result.data == true
  end

  def has_crxde_disabled?
    result = @client.aem.get_crxde_status
    result.data == false
  end
end
