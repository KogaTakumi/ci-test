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
            echo "[detected] $file:$debug_code"
        done
    fi
done