#!/usr/bin/env bash
set -eux
region=US

while getopts "h?a:d:k:r:" opt; do
    case "${opt}" in
    h|\?)
        show_help
        exit 0
        ;;
    a)  accountId=${OPTARG}
        ;;
    d)  dashboard=${OPTARG}
        ;;
    k)  apikey=${OPTARG}
        ;;
    r) region=${OPTARG} 
        ;;
    esac
done

if [ -z "${accountId}" ] || [ -z "${dashboard}" ] || [ -z "${apikey}" ]; then
    echo "usage: ./create-dashboard.sh -a <accountId> -d <./path/to/dashboard.json> -k <NRAPI-KEY>"
    exit
fi


dashjson=$(sed "s/\"accountId\": 1567277/\"accountId\": ${accountId}/" ${dashboard})

NEW_RELIC_REGION=${region} NEW_RELIC_API_KEY=${apikey} newrelic nerdgraph query 'mutation create($dashboard: Input!) {
  dashboardCreate(accountId: '${accountId}', dashboard: $dashboard) {
    entityResult {
      guid
      name
    }
    errors {
      description
    }
  }
}'  --variables "${dashjson}"