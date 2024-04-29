status=$(fcitx5-remote)
if [ "$status" -eq 2 ];
then
    echo ZH
else
    echo EN
fi
