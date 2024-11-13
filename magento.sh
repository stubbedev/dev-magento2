#!/bin/bash

su www-data <<EOSU

/var/www/html/bin/magento $@

EOSU
