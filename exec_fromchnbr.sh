#!/bin/bash

echo "Execute script from which chapter? "
read userInput
counter=$(grep -n "$userInput" transwatch.sh| head -n 1 | cut -d: -f1)
#./transwatch.sh $counter
awk -v start_line="$counter" 'NR >= start_line' "transwatch.sh"

