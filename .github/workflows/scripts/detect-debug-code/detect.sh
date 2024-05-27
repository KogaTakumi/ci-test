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
            # echo "[detected] $file:$debug_code"
            # split debug_code into line number and code
            IFS=':' read -r -a debug_code_parts <<< "$debug_code"
            echo "${file}:${debug_code_parts[0]}:0:Debug code found\n```${debug_code_parts[1]}```"
        done
    fi
done
