# -*- coding: utf-8 -*-
#    Copyright 2013 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

from nailgun.api.validators.base import BasicValidator
from nailgun.errors import errors


class RedHatAcountValidator(BasicValidator):
    @classmethod
    def validate(cls, data):
        d = cls.validate_json(data)
        if not "license_type" in d:
            raise errors.InvalidData(
                message="No License Type specified"
            )
        if d["license_type"] not in ["rhsm", "rhn"]:
            raise errors.InvalidData(
                message="Invalid License Type"
            )
        if d["license_type"] == "rhsm":
            if "username" not in d or "password" not in d:
                raise errors.InvalidData(
                    message="Username or password not specified"
                )
        else:
            if "hostname" not in d or "activation_key" not in d:
                raise errors.InvalidData(
                    message="Satellite hostname or activation key "
                            "not specified"
                )
        if settings.FAKE_TASKS:
            pass
        else:
            # TODO: check Red Hat Account credentials
            pass
