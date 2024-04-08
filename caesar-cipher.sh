#!/usr/bin/env bash

regex_filename='^[a-zA-Z]+\.[a-z]+$'
regex_message='^[A-Z ]+$'

display_menu() {
    echo "0. Exit
1. Create a file
2. Read a file
3. Encrypt a file
4. Decrypt a file
Enter an option:"
}

create_file() {
    echo "Enter the filename:"
    read filename
    if [[ "$filename" =~ $regex_filename ]]; then
        echo "Enter a message:"
        read message
        if [[ "$message" =~ $regex_message ]]; then
            echo "$message" > "$filename"
            echo -e "The file was created successfully!\n"
        else
            echo -e "This is not a valid message!\n"
        fi
    else
        echo -e "File name can contain letters and dots only!\n"
    fi
}

read_file() {
    echo "Enter the filename:"
    read filename
    if [[ -f "$filename" ]]; then
        echo "File content:"
        cat "$filename"
        echo ""
    else
        echo -e "File not found!\n"
    fi
}

encrypt_decrypt_file() {
    echo "Enter the filename:"
    read filename
    if [[ -f "$filename" ]]; then
        type="$1"
        message=$(< "$filename")
        length=${#message}
        key=3
        offset=26
        new_filename="${filename}.enc"
        if [[ "$type" -eq 4 ]]; then
            key=-3
            offset=-26
            new_filename=${filename::-4}
        fi
        for ((i = 0; i < length; i++)); do
            char="${message:i:1}"
            if [[ "$char" != " " ]]; then
                value=$(printf "%d\n" "'$char")
                value=$(($value + $key))
                if [[ "$value" -ge 91 || "$value" -le 64 ]]; then
                    value=$(($value - $offset))
                fi
                char=$(printf "%b\n" "$(printf "\\%03o" "$value")")
            fi
            echo -n "$char" >> "$new_filename"
        done
        rm "$filename"
        echo -e "Success\n"
    else
        echo -e "File not found!\n"
    fi
}

echo -e "Welcome to the Enigma!\n"
while true; do
    display_menu
    read option
    case "$option" in

        0)
            echo "See you later!"
            break;;
        1)
            create_file;;
        2)
            read_file;;
        3)
            encrypt_decrypt_file "$option";;
        4)
            encrypt_decrypt_file "$option";;
        *)
            echo -e "Invalid option!\n";;
    esac
done