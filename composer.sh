#!/usr/bin/env bash

su www-data <<EOSU

/usr/local/bin/composer $@

EOSU
