#!/bin/bash
# turningledge.sh

_V=0
while getopts "v" OPTION
do
    case $OPTION in
        v) _V=1
            ;;
    esac
done

function log () {
    if  [[ $_V -eq 1 ]]; then
        printf "$@"
    fi
}


printf "*******************\n"
printf "Turningledge Report \n"
printf "%s          \n"         "$(date +"%d/%m/%Y")"
printf "*******************\n"

log "Reading config file...\n"
source ~/.turningledgerc

log "\n"
log "Income \n"
log "====== \n"

function monthlyincome {
    ledger budget $salaryaccount \
        -p "last 30 days" \
        --budget-format "%(get_at(display_total, 1))\n"
}
monthlyincome=$(tr -dc '0-9.' <<< $(monthlyincome))

function monthlyincomeex {
    ledger budget \
    $regularexpensesinclude \
    -p "last 30 days" \
    --budget-format "%(trim(scrub(get_at(T, 1))))\n" -n | awk "END {print $NF}"
}
monthlyincomeex=$(tr -dc '0-9.' <<< $(monthlyincomeex))

log "Deriving salary from account \"%s\".\n" "$salaryaccount"
log "Adding \"%s\" to monthly expense calculations.\n\n" "$regularexpensesinclude" 
log "Monthly income:             £ %7s \n" "$monthlyincome"
log "    Less regular expenses:  £ %7s \n" "$monthlyincomeex"

log "\n"
log "Unbudgeted expenses\n"
log "===================\n"

function unbudgetedday {
    ledger --unbudgeted register not "Liabilities" \
        -p "today" \
        --format "%(display_total)\n" --tail 1 | tail -1
}
unbudgetedday=$(tr -dc '0-9.' <<< $(unbudgetedday))
if [[ -z $(unbudgetedday) ]] ; then
    unbudgetedday=0.00
else
    unbudgetedday=$(tr -dc '0-9.' <<< $(unbudgetedday))
fi

function unbudgetedweek {
    ledger --unbudgeted register not "Liabilities" \
        -p "last 7 days" \
        --format "%(display_total)\n" --tail 1 | tail -1
}

if [[ -z $(unbudgetedweek) ]] ; then
    unbudgetedweek=0.00
else
    unbudgetedweek=$(tr -dc '0-9.' <<< $(unbudgetedweek))
fi

function unbudgetedmonth {
    ledger --unbudgeted register not "Liabilities" \
        -p "last 30 days" \
        --format "Past month: %(display_total)\n" --tail 1 | tail -1
}
if [[ -z $(unbudgetedmonth) ]] ; then
    unbudgetedmonth=0.00
else
    unbudgetedmonth=$(tr -dc '0-9.' <<< $(unbudgetedmonth))
fi

function unbudgetedyear {
    ledger --unbudgeted register not "Liabilities" \
        -p "last 365 days" \
        --format "Past year: %(display_total)\n" --tail 1 | tail -1
}
if [[ -z $(unbudgetedyear) ]] ; then
    unbudgetedyear=0.00
else
    unbudgetedyear=$(tr -dc '0-9.' <<< $(unbudgetedyear))
fi

log "Past day:      £ %8s\n" "$unbudgetedday"
log "Past week:     £ %8s\n" "$unbudgetedweek"
log "Past month:    £ %8s\n" "$unbudgetedmonth"
log "Past year:     £ %8s\n" "$unbudgetedyear"

printf "\n"
printf "Allowable spending\n"
printf "==================\n"

function allowableday {
    echo "scale=2; ($monthlyincomeex/30.4375)-$unbudgetedday" | bc
}

function allowableweek {
    echo "scale=2; ($monthlyincomeex/4.348)-$unbudgetedweek" | bc
}

function allowablemonth {
    echo "scale=2; $monthlyincomeex-$unbudgetedmonth" | bc
}

function allowableyear {
    echo "scale=2; ($monthlyincomeex*12)-$unbudgetedyear" | bc
}

printf "Today:         £ %8s\n" "$(allowableday)"
printf "This week:     £ %8s\n" "$(allowableweek)"
printf "This month:    £ %8s\n" "$(allowablemonth)"
printf "This year:     £ %8s\n" "$(allowableyear)"
