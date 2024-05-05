#!/usr/bin/dumb-init /bin/bash
set -euxo pipefail

conf_file=/config/ruvchain.conf

[ -f "${conf_file}" ] || ruvchain -genconf >${conf_file}

exec ruvchain -useconffile ${conf_file}
