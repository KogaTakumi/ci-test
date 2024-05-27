files=$@
debug_code_exists=false

for file in ${files[@]}; do
    if [ ${file: -3} != ".js" ]; then
        continue
    fi

    echo "Checking $file"
    debug_code=(`grep -n -E 'console.log\(|' ${file}`)
    if [ -n "$debug_code" ]; then
        echo "$file: $debug_code"
        debug_code_exists=true
    fi
done

if $debug_code_exists; then
    echo "Debug code exists in the diff. Please remove it."
    exit 1
fi