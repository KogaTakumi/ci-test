files=$@
debug_code_exists=false

for file in ${files[@]}; do
    case ${file##*.} in
        "js")
            IFS=$'\n' read -r -d '' -a debug_codes < <(grep -n -E 'console.log\(' ${file})
            ;;
        "php")
            IFS=$'\n' read -r -d '' -a debug_codes < <(grep -n -E 'debug\(|var_dump\(|dump\(' ${file})
            ;;
        *)
            debug_codes=()
            ;;
    esac

    if [ -n "$debug_codes" ]; then
        debug_code_exists=true
        for debug_code in "${debug_codes[@]}"; do
            IFS=':' read -r -a debug_code_parts <<< "$debug_code"
            echo "::error:: Debug code found in ${file}:${debug_code_parts[0]}: \`${debug_code_parts[1]}\`"
            # For reviewdog
            # In github actions, reviewdog is used to comment on PRs
            # reviewdog -efm="%f:%l:%c: %m" -name="detect-debug-code" -reporter=github-pr-review -level=error
            # echo "${file}:${debug_code_parts[0]}:0: Debug code found \`${debug_code_parts[1]}\`"
        done
    fi
done

if [ "$debug_code_exists" = true ]; then
    exit 1
fi
