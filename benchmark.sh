i=50
output_file="time_analysis_results.txt"

make
# Write header to file
echo -e "Input Size   Dynamic Mean (ms)   Dynamic StdDev (ms)   Dynamic StdErr (ms)   Static Mean (ms)   Static StdDev (ms)   Static StdErr (ms)" > $output_file

echo -e "Running performance tests..."

values=(25 50 100 250 5000)

for i in "${values[@]}"; do
 
    dynamic_times=()
    static_times=()
    for _ in {1..10}; do
        output=$(./arrf_dynamic $i)
        time_taken=$(echo "$output" | grep -Eio "[0-9]+\.[0-9]+.*ms" | grep -Eo "[0-9]+\.[0-9]+")
        dynamic_times+=("$time_taken")

        output=$(./arrf_static $i)
        time_taken=$(echo "$output" | grep -Eio "[0-9]+\.[0-9]+.*ms" | grep -Eo "[0-9]+\.[0-9]+")
        static_times+=("$time_taken")
    done

    # Courtesy: https://stackoverflow.com/questions/21812074/sum-variable-in-awk-if-condition-under-for-loop
    
    dynamic_mean=$(echo "${dynamic_times[@]}" | awk '{sum=0; for(i=1;i<=NF;i++) sum+=$i; print sum/NF}')
    dynamic_stddev=$(echo "${dynamic_times[@]}" | awk -v mean=$dynamic_mean '{sum=0; for(i=1;i<=NF;i++) sum+=($i-mean)^2; print sqrt(sum/NF)}')
    dynamic_stderr=$(echo "${dynamic_times[@]}" | awk -v stddev=$dynamic_stddev -v n=${#dynamic_times[@]} 'BEGIN {print stddev/sqrt(n)}')

    static_mean=$(echo "${static_times[@]}" | awk '{sum=0; for(i=1;i<=NF;i++) sum+=$i; print sum/NF}')
    static_stddev=$(echo "${static_times[@]}" | awk -v mean=$static_mean '{sum=0; for(i=1;i<=NF;i++) sum+=($i-mean)^2; print sqrt(sum/NF)}')
    static_stderr=$(echo "${static_times[@]}" | awk -v stddev=$static_stddev -v n=${#static_times[@]} 'BEGIN {print stddev/sqrt(n)}')

    printf "%10d %20.3f %20.3f %20.3f %20.3f %20.3f %20.3f\n" \
           $i $dynamic_mean $dynamic_stddev $dynamic_stderr $static_mean $static_stddev $static_stderr >> $output_file
done

echo -e "Completed within $output_file"
