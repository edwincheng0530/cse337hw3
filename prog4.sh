#!bin/bash

SRC_DIR="$1"

if [ ! -d "$SRC_DIR" ]; then
    echo "$SRC_DIR is not a directory"
    exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "score directory is missing"
    exit 1
fi

for file in "$SRC_DIR"/*; do
    awk '
    BEGIN {
        FS=","
        student_count = 0
    }
    NR > 1 {
        student_count += 1
        student_id[student_count] = $1
        grade_sum = 0
        for (i = 2; i <= NF; i++) {
            grade_sum += $i
            field_value = $i   
            # print "Field " i ": " field_value 
        }
        percent_grade = grade_sum*2
        if (percent_grade >= 93) {
            grade = "A"
        } else if (percent_grade >= 80) {
            grade = "B"
        } else if (percent_grade >= 65) {
            grade = "C"
        } else {
            grade = "D"
        }
        student_grade[student_count] = grade
    }
    END {
        for(i = 1; i <= student_count; i++) {
            print student_id[i] ":" student_grade[i]
        }
    }
    ' "$file"
done



# TEST CASES
# Test cases can be found in prog4_test_cases/test_cases.txt