#!/usr/bin/env bash

if [ $# -eq 0 ]; then
   php import.php > import.side
else
    php import.php $1 > import.side
fi

../importFile.sh  import.side -o  import_final.side
php tests.php > tests.side
../importFile.sh tests.side -o tests_final.side
