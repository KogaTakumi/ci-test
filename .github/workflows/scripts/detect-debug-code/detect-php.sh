files=$1
debug_code_exists=false

for file in ${files[@]}; do
    if [ ${file: -4} != ".php" ]; then
        continue
    fi

    echo "Checking $file"
    debug_code=(`grep -E 'debug\(|var_dump\(|dump\(' ${file}`)
    if [ -n "$debug_code" ]; then
        echo "$file: $debug_code"
        debug_code_exists=true
    fi
done

if $debug_code_exists; then
    echo "Debug code exists in the diff. Please remove it."
    exit 1
fi