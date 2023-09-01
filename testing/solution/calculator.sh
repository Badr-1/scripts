#!/bin/bash
echo "1. Addition"
echo "2. subtraction"
echo "3. Multiplication"
echo "4. Exit"
while [[ true ]]; do
    read -p "Enter your choice: " choice
    if [[ $choice -eq 4 ]]; then
        echo "Exiting..."
        break
    fi
    read -p "Enter the first number: " num1
    read -p "Enter the second number: " num2
    case $choice in
    1)
        echo "$num1 + $num2 = $(($num1 + $num2))"
        ;;
    2)
        echo "$num1 - $num2 = $(($num1 - $num2))"
        ;;
    3)
        echo "$num1 * $num2 = $(($num1 * $num2))"
        ;;
    esac
done
