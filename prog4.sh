#!bin/bash

SRC_DIR="$1"

# If SRC_DIR doesn't exist, then error
if [ ! -d "$SRC_DIR" ]; then
    echo "$SRC_DIR is not a directory"
    exit 1
fi

# If input isn't exactly 1, then error
if [ "$#" -ne 1 ]; then
    echo "score directory is missing"
    exit 1
fi

for file in "$SRC_DIR"/*; do
    awk '
    BEGIN {
        FS=","
        # Count number of students
        student_count = 0
    }
    # Ignore first row of metadata, and parse second line of data
    NR > 1 {
        student_count += 1
        student_id[student_count] = $1
        grade_sum = 0
        # Obtain grade out of 50
        for (i = 2; i <= NF; i++) {
            grade_sum += $i
            field_value = $i
        }
        # Obtain percent grade out of 100 and translate into letter grade
        percent_grade = (grade_sum*2)
        rounded_grade = int(percent_grade+0.5)
        if (rounded_grade >= 93) {
            grade = "A"
        } else if (rounded_grade >= 80) {
            grade = "B"
        } else if (rounded_grade >= 65) {
            grade = "C"
        } else {
            grade = "D"
        }
        student_grade[student_count] = grade
    }
    END {
        # Print out each student_id along with the letter grade
        for(i = 1; i <= student_count; i++) {
            print student_id[i] ":" student_grade[i]
        }
    }
    ' "$file"
done



# TEST CASES
# Test cases can be found in prog4_test_cases/test_cases.txt