# files=$@
files=git diff origin/main --name-only
debug_code_exists=false

for file in ${files[@]}; do
    # switchで分岐
    case ${file##*.} in
        "js")
            debug_code=(`grep -n -E 'console.log\(|' ${file}`)
            ;;
        "php")
            debug_code=(`grep -n -E 'debug\(|var_dump\(|dump\(' ${file}`)
            ;;
        *)
            debug_code=()
            ;;
    esac

    if [ -n "$debug_code" ]; then
        echo "[detected] $file: $debug_code"
        debug_code_exists=true
    fi
done