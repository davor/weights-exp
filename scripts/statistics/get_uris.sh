cat log_file |  grep " http://toxcreate3.in-silico.ch:8086/validation/crossvalidation/" | gawk -F " " '{print $2}' | sed 's/http/,http/' | tr -d "\n"
