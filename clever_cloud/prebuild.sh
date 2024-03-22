#!/bin/env bash

echo "export DATABASE_URL=$POSTGRESQL_ADDON_URI" >> ../applicationrc
echo "export DATABASE_DIRECT_URL=$POSTGRESQL_ADDON_URI" >> ../applicationrc