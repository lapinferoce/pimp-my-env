#!/usr/bin/env bash

FINAL_NAME="pimp-my-env.bash"

function require_module {
    echo "" #>> $FINAL_NAME
    cat ./module/$1.bash | gawk '
    BEGIN{}
    {
        if ($0 ~ /include_default_resource/)
            {
                print $2
                system("cat ./resource/" $2 "/default")
            }
        else
            print $0
    }
    END{}'
 # >> $FINAL_NAME
}


echo "#!/usr/bin/env bash" #> $FINAL_NAME
. ./pimp-my-env.conf

