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

import web

from nailgun.api.handlers.cluster import ClusterHandler
from nailgun.api.handlers.cluster import ClusterCollectionHandler
from nailgun.api.handlers.cluster import ClusterChangesHandler
from nailgun.api.handlers.cluster import ClusterAttributesHandler
from nailgun.api.handlers.cluster import ClusterAttributesDefaultsHandler

from nailgun.api.handlers.network_configuration \
    import NetworkConfigurationHandler
from nailgun.api.handlers.network_configuration \
    import NetworkConfigurationVerifyHandler

from nailgun.api.handlers.release import ReleaseHandler
from nailgun.api.handlers.release import ReleaseCollectionHandler

from nailgun.api.handlers.node import NodeHandler
from nailgun.api.handlers.node import NodeCollectionHandler
from nailgun.api.handlers.node import NodeAttributesHandler
from nailgun.api.handlers.node import NodeAttributesDefaultsHandler
from nailgun.api.handlers.node import NodeAttributesByNameHandler
from nailgun.api.handlers.node import NodeAttributesByNameDefaultsHandler
from nailgun.api.handlers.node import NodeNICsHandler
from nailgun.api.handlers.node import NodeNICsDefaultHandler
from nailgun.api.handlers.node import NodeCollectionNICsHandler
from nailgun.api.handlers.node import NodeCollectionNICsDefaultHandler
from nailgun.api.handlers.node import NodeNICsVerifyHandler

from nailgun.api.handlers.tasks import TaskHandler
from nailgun.api.handlers.tasks import TaskCollectionHandler

from nailgun.api.handlers.notifications import NotificationHandler
from nailgun.api.handlers.notifications import NotificationCollectionHandler

from nailgun.api.handlers.logs import LogEntryCollectionHandler
from nailgun.api.handlers.logs import LogPackageHandler
from nailgun.api.handlers.logs import LogSourceCollectionHandler
from nailgun.api.handlers.logs import LogSourceByNodeCollectionHandler

from nailgun.api.handlers.version import VersionHandler

urls = (
    r'/releases/?$',
    'ReleaseCollectionHandler',
    r'/releases/(?P<release_id>\d+)/?$',
    'ReleaseHandler',
    r'/clusters/?$',
    'ClusterCollectionHandler',
    r'/clusters/(?P<cluster_id>\d+)/?$',
    'ClusterHandler',
    r'/clusters/(?P<cluster_id>\d+)/changes/?$',
    'ClusterChangesHandler',
    r'/clusters/(?P<cluster_id>\d+)/attributes/?$',
    'ClusterAttributesHandler',
    r'/clusters/(?P<cluster_id>\d+)/attributes/defaults/?$',
    'ClusterAttributesDefaultsHandler',
    r'/clusters/(?P<cluster_id>\d+)/network_configuration/?$',
    'NetworkConfigurationHandler',
    r'/clusters/(?P<cluster_id>\d+)/network_configuration/verify/?$',
    'NetworkConfigurationVerifyHandler',
    r'/nodes/?$',
    'NodeCollectionHandler',
    r'/nodes/(?P<node_id>\d+)/?$',
    'NodeHandler',
    r'/nodes/(?P<node_id>\d+)/attributes/?$',
    'NodeAttributesHandler',
    r'/nodes/(?P<node_id>\d+)/attributes/defaults/?$',
    'NodeAttributesDefaultsHandler',
    r'/nodes/(?P<node_id>\d+)/attributes/(?P<attr_name>[-\w]+)/?$',
    'NodeAttributesByNameHandler',
    r'/nodes/(?P<node_id>\d+)/attributes/(?P<attr_name>[-\w]+)/defaults/?$',
    'NodeAttributesByNameDefaultsHandler',
    r'/nodes/interfaces/?$',
    'NodeCollectionNICsHandler',
    r'/nodes/interfaces/default_assignment?$',
    'NodeCollectionNICsDefaultHandler',
    r'/nodes/(?P<node_id>\d+)/interfaces/?$',
    'NodeNICsHandler',
    r'/nodes/(?P<node_id>\d+)/interfaces/default_assignment?$',
    'NodeNICsDefaultHandler',
    r'/nodes/interfaces_verify/?$',
    'NodeNICsVerifyHandler',
    r'/tasks/?$',
    'TaskCollectionHandler',
    r'/tasks/(?P<task_id>\d+)/?$',
    'TaskHandler',
    r'/notifications/?$',
    'NotificationCollectionHandler',
    r'/notifications/(?P<notification_id>\d+)/?$',
    'NotificationHandler',
    r'/logs/?$',
    'LogEntryCollectionHandler',
    r'/logs/package/?$',
    'LogPackageHandler',
    r'/logs/sources/?$',
    'LogSourceCollectionHandler',
    r'/logs/sources/nodes/(?P<node_id>\d+)/?$',
    'LogSourceByNodeCollectionHandler',
    r'/version/?$',
    'VersionHandler'
)

app = web.application(urls, locals())
