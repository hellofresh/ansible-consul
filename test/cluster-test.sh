#/bin/sh
set -e

echo "Phase 1 (basic-server) Converge & Verify"
bundle exec kitchen test basic-server

echo "Phase 2 (basic-agent) Converge & Verify"
bundle exec kitchen test basic-agent

echo "Phase 3 (cluster-) converge"
bundle exec kitchen converge cluster-*

echo "Phase 3 (cluster-) verify"
bundle exec kitchen verify cluster-*

echo "Phase 3 (cluster-) destroy"
bundle exec kitchen verify cluster-*
