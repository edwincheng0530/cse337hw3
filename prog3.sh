#!/bin/bash
# Check if data file is provided
if [ "$#" -lt 1 ]; then
    echo "missing data file"
    exit 1
fi

# Get the data file
data_file="$1"
shift  # Remove first argument, leaving only weights

# Check if file exists
if [ ! -f "$data_file" ]; then
    echo "$data_file not found"
    exit 1
fi

awk '
BEGIN {
    FS=","
    weight_sum = 0
    score_sum = 0
    student_count = 0

    # print "ARGC:", ARGC
    # for (i = 0; i < ARGC; i++) {
    #     print "ARGV[" i "] =", ARGV[i]
    # }
}

# Process header row
NR == 1 {
    num_questions = NF - 1  # Subtract 1 for ID column
    for (i = 1; i <= num_questions; i++) {
        if (i + 1 < ARGC) {
            weights[i] = ARGV[i + 1]
        } else {
            weights[i] = 1
        }
        weight_sum += weights[i]
    }
    # Remove so that awk doesnt run on these arguments
    for (i = 2; i < ARGC; i++) {
        ARGV[i] = ""
    }
    next
}

{
    student_sum = 0
    for (i = 2; i <= NF; i++) {
        part_index = i - 1
        student_sum += $i * weights[part_index]
    }
    student_count++
    student_total[student_count] = student_sum
}

END {
    total_average = 0
    for(i = 1; i <= student_count; i++) {
        average = student_total[i]/weight_sum
        total_average += average
    }
    weighted_class_average = total_average / student_count
    print weighted_class_average
}' "$data_file" "$@"