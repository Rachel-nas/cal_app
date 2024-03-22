#!/bin/env bash

echo "DATABASE_URL=$POSTGRESQL_ADDON_URI" >> ../applicationrc
echo "DATABASE_DIRECT_URL=$POSTGRESQL_ADDON_URI" >> ../applicationrc