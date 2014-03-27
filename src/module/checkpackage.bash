function required {
    if which $1 > /dev/null;then
        echo -n "."
    else
        echo "\nplease install the [$1] package with your favortie package manager "
    fi
}

